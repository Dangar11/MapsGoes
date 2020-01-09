//
//  LocationCell.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools


class LocationCell: LBTAListCell<String> {
  
  override func setupViews() {
    backgroundColor = .white
    
    setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .black)
    layer.cornerRadius = 10
    
  }
  
}


