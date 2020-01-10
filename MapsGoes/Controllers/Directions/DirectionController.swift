//
//  DirectionController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 10.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit
import SwiftUI

class DirectionController: UIViewController {
  
  //MARK: - Properties
  let mapView = MKMapView()
  
  
  //MARK: - ViewLifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupRegionForMap()
    
    setupNavBarUI()
    
    mapView.showsUserLocation = true
    mapView.delegate = self
    
    setupStardEndDummyAnnotataion()
    requestForDirections()
    
  }
  
  //MARK: - Functionality
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  fileprivate func setupStardEndDummyAnnotataion() {
    
    let startAnnotation = MKPointAnnotation()
    startAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    startAnnotation.title = "Start"
    
    let endAnnotation = MKPointAnnotation()
    endAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.410400, longitude: 26.978805)
    endAnnotation.title = "End"
    
    
    mapView.addAnnotation(startAnnotation)
    mapView.addAnnotation(endAnnotation)
    
  }
  
  
  fileprivate func requestForDirections() {
    
    let request = MKDirections.Request()
    
    let startingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605))
    
    let endingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.410400, longitude: 26.978805))
    
    //start point
    request.source = .init(placemark: startingPlacemark)
    //end point
    request.destination = .init(placemark: endingPlacemark)
    
    request.requestsAlternateRoutes = true
    
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
      if let error = error {
        print("Unable to calculate route: ", error.localizedDescription)
      }
      
      //Success
      //Iterate throught routes and show alternate routes
      response?.routes.forEach({ (route) in
        //need to render in MKMapViewDelegate
        
        self.mapView.addOverlay(route.polyline)
      })
      
      
      
      
    }
    
  }
  
  
  //MARK: - UI
  
  fileprivate func setupNavBarUI() {
    
    
    let navBar = UIView(backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    view.addSubview(navBar)
    navBar.setupShadow(opacity: 0.5, radius: 5)
    navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -100, right: 0))
    
    view.addSubview(mapView)
    mapView.anchor(top: navBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    
  }
  
  
  
}




//MARK: - MKMapViewDelegate
extension DirectionController: MKMapViewDelegate {
  
  //Render Polyline

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polylineRenderer = MKPolylineRenderer(overlay: overlay)
    polylineRenderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    polylineRenderer.lineWidth = 5
    return polylineRenderer
  }
  
}
  
  
  
  
  //MARK: - SwiftUI Preview
  struct DirectionPreview: PreviewProvider {
    
    static var previews: some View {
      ContainerView().edgesIgnoringSafeArea(.all) // ignore safe area and fill fullscreen
//        .environment(\.colorScheme, .dark)  // darkMode
    }
    
    
    // View Container
    struct ContainerView: UIViewControllerRepresentable {
      

      //viewController instance to present
      func makeUIViewController(context: UIViewControllerRepresentableContext<DirectionPreview.ContainerView>) -> UIViewController {
        return DirectionController()
      }
      
      //updates to latest changes
      func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DirectionPreview.ContainerView>) {
        
      }
    }
  }
  
  

  
  

