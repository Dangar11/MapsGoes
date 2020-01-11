//
//  RoutesController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit


class RoutesController: LBTAListController<RoutesCell, MKRoute.Step> {
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
}


extension RoutesController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 50)
  }
  
}
