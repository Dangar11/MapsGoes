//
//  MapViewController+UserLocation.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import MapKit


extension MapViewController  {
  
  func requestUserLocation() {
    //request when application only in use
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
  }
  
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse:
      print("Recieved authorization of user location")
      //request where the user is?
      locationManager.startUpdatingLocation()
    default:
      print("Failed to authorize")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else { return }
    mapView.setRegion(.init(center: firstLocation.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
//    locationManager.stopUpdatingLocation()
  }
  
}
