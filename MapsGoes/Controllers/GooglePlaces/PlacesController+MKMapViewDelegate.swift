//
//  PlacesController+MKMapViewDelegate.swift
//  MapsGoes
//
//  Created by Igor Tkach on 15.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import Foundation
import MapKit



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
