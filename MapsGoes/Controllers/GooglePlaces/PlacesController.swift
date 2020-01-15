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
  
  lazy var infoButton = UIButton(type: .infoLight)
  let hudNameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 16))
  let hudAddressLabel = UILabel(text: "Address", font: .systemFont(ofSize: 16))
  let hudTypesLabel = UILabel(text: "Types", textColor: .gray)
  let hudContainer = UIView(backgroundColor: .white)
  
  
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
  
  fileprivate func selectedAnnotationHUD() {
    
    view.addSubview(hudContainer)
    hudContainer.layer.cornerRadius = 5
    hudContainer.setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .darkGray)
    hudContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .allSides(16), size: .init(width: 0, height: 125))
    
    let topRow = UIView()
    topRow.hstack(hudNameLabel, infoButton.withWidth(44))
    hudContainer.hstack(hudContainer.stack(topRow,
                                           hudAddressLabel,
                                           hudTypesLabel, spacing: 8), alignment: .center).withMargins(.allSides(16))
    
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
  
  
  fileprivate func setupHUD(view: MKAnnotationView) {
    guard let annotation = view.annotation as? GooglePlaceCustomAnnotation else { return }
    
    selectedAnnotationHUD()
    
    let place = annotation.place
    hudNameLabel.text = place.name
    hudAddressLabel.text = place.formattedAddress
    hudTypesLabel.text = place.types?.joined(separator: ", ")
    
  }
  
  
  
  //MARK: Selected Annotation
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    setupHUD(view: view)
    //Refresh
    currentCustomCallout?.removeFromSuperview()
    
    let customCalloutContainer = CalloutContainer()
    
    
    view.addSubview(customCalloutContainer)
    
    let widthAnchor = customCalloutContainer.widthAnchor.constraint(equalToConstant: 100)
    widthAnchor.isActive = true
    let heightAnchor = customCalloutContainer.heightAnchor.constraint(equalToConstant: 200)
    heightAnchor.isActive = true
    customCalloutContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    customCalloutContainer.bottomAnchor.constraint(equalTo: view.topAnchor).isActive = true
    
    
    currentCustomCallout = customCalloutContainer
    
    //load photo
    guard let firstPhotoMetadata = (view.annotation as? GooglePlaceCustomAnnotation)?.place.photos?.first else { return }
    
    
    self.client.loadPlacePhoto(firstPhotoMetadata) { [weak self] (image, error) in
      guard let self = self else { return }
      //Error
      if let error = error {
        print("Failed to load photo from metaDataList: ", error.localizedDescription)
      }
      
      //Success
      guard let image = image else { return }
      
      //Image showing ration
      let bestCalloutSize = self.bestCalloutImageSize(image: image)
      widthAnchor.constant = bestCalloutSize.width
      heightAnchor.constant = bestCalloutSize.height
      
      let imageView = UIImageView(image: image, contentMode: .scaleAspectFill)
      customCalloutContainer.addSubview(imageView)
      imageView.fillSuperview()
      //Success
      
      //label
      let labelContainer = UIView(backgroundColor: .white)
      labelContainer.layer.opacity = 0.8
      let text = (view.annotation as? GooglePlaceCustomAnnotation)?.place.name
      let nameLabel = UILabel(text: text, textAlignment: .center)
      labelContainer.stack(nameLabel)
      customCalloutContainer.stack(UIView(), labelContainer.withHeight(30))
      
    }
  }
  
  
  fileprivate func bestCalloutImageSize(image: UIImage) -> CGSize {
    if image.size.width > image.size.height {
       //  w1/h1 = w2/h2
       let newWidth: CGFloat = 300
       let newHeight = newWidth / image.size.width * image.size.height
      return .init(width: newWidth, height: newHeight)
     } else {
       let newHeight: CGFloat = 300
       let newWidth = newHeight / image.size.height * image.size.width
      return .init(width: newWidth, height: newHeight)
     }
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
