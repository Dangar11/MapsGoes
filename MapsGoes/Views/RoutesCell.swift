//
//  RoutesCell.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import LBTATools
import UIKit
import MapKit



class RoutesCell: LBTAListCell<MKRoute.Step> {
  
  override var item: MKRoute.Step! {
    didSet {
      nameLabel.text = item.instructions
      distanceLabel.text = "\(Int(item.distance))m"
      print(item.instructions, item.distance)
    }
  }
  
  
  let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 16, weight: .regular))
  let distanceLabel = UILabel(text: "", font: .italicSystemFont(ofSize: 16), textColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), textAlignment: .right)
  
  
  override func setupViews() {
    hstack(nameLabel,
           distanceLabel.withWidth(80)).withMargins(.allSides(12))
    
    addSeparatorView(leftPadding: 12)
  }
  
}
