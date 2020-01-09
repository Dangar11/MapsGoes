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

class MainController: UIViewController {
  
  let mapView = MKMapView()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mapView)
    mapView.delegate = self
    
    //Using LBTATools for contstaints mapView to all edges
    mapView.fillSuperview()
    
    setupRegionForMap()
    

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
     request.naturalLanguageQuery = "ресторан"
     request.region = mapView.region
     let localSearch = MKLocalSearch(request: request)
     localSearch.start { (response, error) in
       //Error
       if let error = error {
         print("Failed local search:", error)
         return
       }
       
       //Success
       response?.mapItems.forEach({ (mapItem) in
//        print(mapItem.placemark.subThoroughfare ?? "")
        
        
        let placemark = mapItem.placemark
        
        //transform to fullAddress
        let fullAddresses = self.fullAddress(placemark: placemark)
        

        print(fullAddresses)
        
        
         let annotation = MKPointAnnotation()
         annotation.coordinate = mapItem.placemark.coordinate
         annotation.title = mapItem.name
         self.mapView.addAnnotation(annotation)
       })
      self.mapView.showAnnotations(self.mapView.annotations, animated: true)
     }
   }
  
  
  fileprivate func fullAddress(placemark: MKPlacemark) -> String {
    var addressString = ""
    
    if placemark.thoroughfare != nil {
      addressString = placemark.thoroughfare! + " "
    }
    if placemark.subThoroughfare != nil {
      addressString += placemark.subThoroughfare! + ", "
    }
    if placemark.postalCode != nil {
      addressString += placemark.postalCode! + " "
    }
    if placemark.locality != nil {
      addressString += placemark.locality! + ", "
    }
    if placemark.administrativeArea != nil {
      addressString += placemark.administrativeArea! + " "
    }
    if placemark.country != nil {
             addressString += placemark.country!
           }
    
    return addressString
  }
  
  fileprivate func setupAnnotationsForMap() {
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    annotation.title = "Restuarant Shpigell"
    annotation.subtitle = "The Best Restaurant"
    mapView.addAnnotation(annotation)
    
    let myHomeAnnotation = MKPointAnnotation()
    myHomeAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.442608, longitude: 26.995859)
    myHomeAnnotation.title = "My Home"
    myHomeAnnotation.subtitle = "The best place in the world"
    mapView.addAnnotation(myHomeAnnotation)
    
    mapView.showAnnotations(self.mapView.annotations, animated: true)
    
  }
  
  
}

extension MainController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
    annotationView.canShowCallout = true
//    annotationView.image = #imageLiteral(resourceName: "tourist")
    return annotationView
    
  }
  
  
}



//SwiftUI Preview
import SwiftUI

//Preview containerView
struct MainPreview: PreviewProvider {
  static var previews: some View {
    ContainerView().edgesIgnoringSafeArea(.all)
  }
  
  //Make container view for Controller
  struct ContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> MainController {
      return MainController()
    }
    
    func updateUIViewController(_ uiViewController: MainController, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
      
    }
    
    typealias UIViewControllerType = MainController
    
    
  }
}
