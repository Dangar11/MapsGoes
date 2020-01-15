//
//  PlacePhotosCell.swift
//  MapsGoes
//
//  Created by Igor Tkach on 15.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools


class PlacePhotosCell: LBTAListCell<UIImage> {
  
 
  
  override var item: UIImage! {
    didSet {
      imageView.image = item

    }
  }
  
   let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
  
  
  
  
  
  override func setupViews() {
    
 
    addSubview(imageView)
    imageView.fillSuperview()
    layer.cornerRadius = 10
     clipsToBounds = true
    imageView.layer.borderWidth = 2
    imageView.layer.borderColor = UIColor.lightGray.cgColor
    
  }
  
  
  
}

