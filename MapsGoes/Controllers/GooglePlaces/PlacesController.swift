//
//  PlacesController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import LBTATools
import MapKit
import GooglePlaces

class PlacesController: UIViewController {
  
  //MARK: - Properties
  let mapView = MKMapView()
  let locationManager = CLLocationManager()
  let client = GMSPlacesClient()
  
  var currentCustomCallout: UIView?
  
  
  //MARK: - ViewLifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mapView)
    mapView.fillSuperview()
    mapView.showsUserLocation = true
    locationManager.delegate = self
    mapView.delegate = self
    
    requestForLocationAuthorization()
  }
  
  
  //MARK: - Functionality
  
  //Retrieve places from GoogleLikelyhood
  fileprivate func findNearbyPlaces() {
    client.currentPlace { [weak self] (likelihoodList, err) in
      if let err = err {
        print("Failed to find current place:", err)
        return
      }
      
      likelihoodList?.likelihoods.forEach({  (likelihood) in
        print(likelihood.place.name ?? "")
        
        let place = likelihood.place
        
        let annotation = GooglePlaceCustomAnnotation(place: place)
        annotation.title = place.name
        annotation.coordinate = place.coordinate
        
        self?.mapView.addAnnotation(annotation)
      })
      
      self?.mapView.showAnnotations(self?.mapView.annotations ?? [], animated: false)
    }
  }
  
  
  
  fileprivate func requestForLocationAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
}


//MARK: - CLLocationManagerDelegate
extension PlacesController: CLLocationManagerDelegate {
  
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let first = locations.first else { return }
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: first.coordinate, span: span)
    mapView.setRegion(region, animated: true)
    
    findNearbyPlaces()
  }
  
  
}

//MARK: - MKMapViewDelegate
extension PlacesController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    if !(annotation is GooglePlaceCustomAnnotation) { return nil }
    
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
    annotationView.canShowCallout = true
    if let placeAnnotation = annotation as? GooglePlaceCustomAnnotation {
      let types = placeAnnotation.place.types
      //Cheking for places types annotations
      switch types?.first {
      case "cafe": annotationView.image = #imageLiteral(resourceName: "cafe")
      case "transit_station": annotationView.image = #imageLiteral(resourceName: "train")
      case "point_of_interest": annotationView.image = #imageLiteral(resourceName: "museum")
      case "gas_station": annotationView.image = #imageLiteral(resourceName: "fuel")
      default: annotationView.image = #imageLiteral(resourceName: "star")
      }
    }
    
    return annotationView
  }
  
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //Refresh
    currentCustomCallout?.removeFromSuperview()
    
    let customCalloutContainer = UIView(backgroundColor: .red)
//    customCalloutContainer.frame = .init(x: 0, y: 0, width: 100, height: 200)
    
    view.addSubview(customCalloutContainer)
    
    customCalloutContainer.translatesAutoresizingMaskIntoConstraints = false
    customCalloutContainer.widthAnchor.constraint(equalToConstant: 100).isActive = true
    customCalloutContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
    customCalloutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    customCalloutContainer.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
    
    currentCustomCallout = customCalloutContainer
  }
  
}


//MARK: - SwiftUI Preview
struct PlacesController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacesController_Previews.Container>) -> UIViewController {
      PlacesController()
    }
    
    func updateUIViewController(_ uiViewController: PlacesController_Previews.Container.UIViewControllerType, context: UIViewControllerRepresentableContext<PlacesController_Previews.Container>) {
      
    }
  }
}
