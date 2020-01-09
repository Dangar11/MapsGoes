//
//  MKMapExtension.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import MapKit


extension MKMapItem {
  
  func address() -> String {
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
  
}
