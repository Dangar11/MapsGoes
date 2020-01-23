//
//  PlacesController+CLLocationManagerDelegate.swift
//  MapsGoes
//
//  Created by Igor Tkach on 15.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import Foundation
import MapKit


//MARK: - CLLocationManagerDelegate
extension PlacesController: CLLocationManagerDelegate {
  
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let first = locations.first else { return }
    let region = MKCoordinateRegion(center: first.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
    mapView.setRegion(region, animated: true)
    
    findNearbyPlaces()
  }
  
  
}
