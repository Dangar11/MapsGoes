//
//  GooglePlaceCustomAnnotation.swift
//  MapsGoes
//
//  Created by Igor Tkach on 14.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import MapKit
import UIKit
import GooglePlaces

class GooglePlaceCustomAnnotation: MKPointAnnotation {
  
  let place: GMSPlace
  
  init(place: GMSPlace) {
    self.place = place
  }
  
}
