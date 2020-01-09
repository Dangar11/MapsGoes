//
//  LocationCarouselController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 09.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit


class LocationCarouselController: LBTAListController<LocationCell, MKMapItem> {
  
  
  weak var mainController: MainController?
  
  let pickingSizeContent:CGFloat = 64

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.clipsToBounds = false
    collectionView.backgroundColor = .clear
    
  }
  
  
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print(self.items[indexPath.item].placemark.coordinate)
    let annotations = mainController?.mapView.annotations
    let selectedAnnotation = items[indexPath.item].placemark.name
    //compare selected annotation with annotation showing in the map and move to selected one
    
    annotations?.forEach({ (annotation) in
      if annotation.title == selectedAnnotation {
        mainController?.mapView.selectAnnotation(annotation, animated: true)
      }
    })
    
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
