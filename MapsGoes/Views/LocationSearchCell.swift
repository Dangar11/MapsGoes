//
//  LocationSearchCell.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit


class LocationSearchCell: LBTAListCell<MKMapItem> {
  
  
  override var item: MKMapItem! {
     didSet {
      nameLabel.text = item.name
      addressLabel.text = item.address()
     }
   }
  
  let nameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 16))
  let addressLabel = UILabel(text: "Address", font: .systemFont(ofSize: 14), textColor: .darkGray)
  
  
  override func setupViews() {
//    backgroundColor = .green
    stack(nameLabel,
          addressLabel).withMargins(.allSides(16))
    addSeparatorView(leftPadding: 16)
  }
  
}
