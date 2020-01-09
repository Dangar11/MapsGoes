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
    
    //Using LBTATools for contstaints mapView to all edges
    mapView.fillSuperview()
    
    setupRegionForMap()
    
  
  }
  
  
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
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
