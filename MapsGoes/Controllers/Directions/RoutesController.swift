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

//(<T,T,T> -> <Actual Cell, Data Provide, ReusableViewLayout>)
class RoutesController: LBTAListHeaderController<RoutesCell, MKRoute.Step, RouteHeader> {
  
  
  var route: MKRoute!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return .init(width: view.frame.width, height: 120)
  }
  
  
  override func setupHeader(_ header: RouteHeader) {
    header.routeNameLabel.attributedText = header.generateAttributeString(title: "Route", description: route.name)
    let kmDistance = route.distance / 1000
    let kmString = String(format: "%.2f km", kmDistance)
    header.distanceLabel.attributedText = header.generateAttributeString(title: "Distance", description: kmString)
    
    var timeString = ""
    if route.expectedTravelTime > 3600 {
      let h = Int(route.expectedTravelTime / 60 / 60)
      let m = Int((route.expectedTravelTime
        .truncatingRemainder(dividingBy: 60 * 60)) / 60)
      timeString = String(format: "%d hr %d min", h, m)
    } else {
      let time = Int(route.expectedTravelTime / 60)
      timeString = String(format: "%d min", time)
    }
    
    header.estimatedTimeLabel.attributedText = header.generateAttributeString(title: "Est Time", description: timeString)
  }
  
}


extension RoutesController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 50)
  }
  
}
