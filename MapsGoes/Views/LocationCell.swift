//
//  LocationCell.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit


class LocationCell: LBTAListCell<MKMapItem> {
  
  override var item: MKMapItem! {
    didSet {
      nameLabel.text = item.name
      addressLabel.text = item.address()
      let longitude = item.placemark.coordinate.longitude.rounded(toPlaces: 6)
      let latitude = item.placemark.coordinate.latitude.rounded(toPlaces: 6)
      locationLabel.text = "\n Long:\(longitude) Lat:\(latitude)"
      
    }
  }
  
  let nameLabel = UILabel(text: "Location", font: .boldSystemFont(ofSize: 16))
  
  let addressLabel = UILabel(text: "", font: .systemFont(ofSize: 14, weight: .light), textColor: .darkGray, textAlignment: .left, numberOfLines: 0)
  
  let locationLabel = UILabel(text: "", font: .systemFont(ofSize: 12, weight: .light), textColor: .darkGray, textAlignment: .left, numberOfLines: 0)
  
  
  
  
  override func setupViews() {
    backgroundColor = .white
    
    setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
    layer.cornerRadius = 10
    
    stack(nameLabel, addressLabel, locationLabel).withMargins(.allSides(16))
  }
  
}


