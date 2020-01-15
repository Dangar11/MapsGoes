//
//  CalloutContainer.swift
//  MapsGoes
//
//  Created by Igor Tkach on 15.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit

class CalloutContainer: UIView {
  
  
  
  

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    layer.borderWidth = 1
    layer.borderColor = UIColor.black.cgColor
    layer.cornerRadius = 10
    layer.masksToBounds = true
    
    addSpiner()
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func addSpiner() {
    //spinner loading
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.color = .darkGray
    addSubview(spinner)
    spinner.fillSuperview()
    spinner.startAnimating()
  }
  
  
  
}
