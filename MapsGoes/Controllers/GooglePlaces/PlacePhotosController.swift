//
//  PlacePhotosController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 15.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools


class PlacePhotosController: LBTAListController<PlacePhotosCell, UIImage> {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}


extension PlacePhotosController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width - 20, height: 300)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    .init(top: 12, left: 0, bottom: 0, right: 0)
  }
  
}
