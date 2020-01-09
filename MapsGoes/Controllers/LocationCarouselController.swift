//
//  LocationCarouselController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools


class LocationCarouselController: LBTAListController<LocationCell, String> {
  
  
  let pickingSizeContent:CGFloat = 64

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.clipsToBounds = false
    collectionView.backgroundColor = .clear
    self.items = ["1", "2", "3"]
    
  }
  
}


extension LocationCarouselController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - pickingSizeContent, height: view.frame.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 16, bottom: 0, right: 16)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
}
