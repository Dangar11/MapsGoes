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
    mapView.mapType = .satellite
    
  
  }
  
}
