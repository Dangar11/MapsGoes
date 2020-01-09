//
//  MainController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import MapKit
import LBTATools
import Combine

class MapViewController: UIViewController {
  
  
  //MARK: - Properties
  
  let locationController = LocationCarouselController(scrollDirection: .horizontal)
  
  let mapView = MKMapView()
  
  let locationManager = CLLocationManager()
  
  //Combine framework
  var textFieldNotification: AnyCancellable?
  
  let searchTextField = UITextField(placeholder: "Search query")
  
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mapView)
    mapView.delegate = self
    mapView.showsUserLocation = true
    //Using LBTATools for contstaints mapView to all edges
    mapView.fillSuperview()
    
    
    requestUserLocation()
    
    setupRegionForMap()
    performLocalSearch()
    setupSearchUI()
    setupLocationCarousel()
    locationController.mainController = self
  
  }
  
  //MARK: - Functionality
  
  fileprivate func setupLocationCarousel() {
    
    guard let locationView = locationController.view else { return }
    
    view.addSubview(locationView)
    locationView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
  }
  
  fileprivate func setupSearchUI() {
    
    let whiteContainer = UIView(backgroundColor: .white)
    view.addSubview(whiteContainer)
    whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
    whiteContainer.stack(searchTextField).withMargins(.allSides(16))
    
    
    //Combine
    //search on the last keystroke of text change and basically wait 500 millisecond
    
    self.textFieldNotification = NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { (_) in
        self.performLocalSearch()
    }
  }
  
  
  
  @objc fileprivate func handleSearchChanges() {
    performLocalSearch()
  }
 
  
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  fileprivate func performLocalSearch() {
     let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTextField.text
     request.region = mapView.region
     let localSearch = MKLocalSearch(request: request)
     localSearch.start { (response, error) in
       //Error
       if let error = error {
         print("Failed local search:", error)
         return
       }
       
       //Success
      //remove old annotations
      self.mapView.removeAnnotations(self.mapView.annotations)
      self.locationController.items.removeAll()
      
       response?.mapItems.forEach({ (mapItem) in
        
        //transform to fullAddress
        print(mapItem.address())
        
        
         let annotation = MKPointAnnotation()
         annotation.coordinate = mapItem.placemark.coordinate
         annotation.title = mapItem.name
         self.mapView.addAnnotation(annotation)
        
        //fill the carousel items array with mapItems from Search
        self.locationController.items.append(mapItem)
        //scroll carousel to the initial pozition
        self.locationController.collectionView.scrollToItem(at: [0,0], at: .centeredHorizontally, animated: true)
       })
      self.mapView.showAnnotations(self.mapView.annotations, animated: true)
     }
   }
  
  
  
}




//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    // Check for blue dot userLocation 
    if (annotation is MKPointAnnotation) {
      let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
      annotationView.canShowCallout = true
      return annotationView
    }
    return nil
  }
  
  
}



//MARK: - SwiftUI - Preview

//SwiftUI Preview
import SwiftUI

//Preview containerView
struct MainPreview: PreviewProvider {
  static var previews: some View {
    ContainerView().edgesIgnoringSafeArea(.all)
  }
  
  //Make container view for Controller
  struct ContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> MapViewController {
      return MapViewController()
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
      
    }
    
    typealias UIViewControllerType = MapViewController
    
    
  }
}
