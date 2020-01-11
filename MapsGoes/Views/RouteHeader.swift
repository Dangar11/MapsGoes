//
//  RouteHeader.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import SwiftUI

class RouteHeader: UICollectionReusableView {
  
  
  let routeNameLabel = UILabel(text: "Route Name", font: .systemFont(ofSize: 16))
  let distanceLabel = UILabel(text: "Distance", font: .systemFont(ofSize: 16))
  let estimatedTimeLabel = UILabel(text: "Est time...", font: .systemFont(ofSize: 16))
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    hstack(stack(routeNameLabel,
                 distanceLabel,
                 estimatedTimeLabel),
           spacing: 8,
           alignment: .center)
      .withMargins(.allSides(16))
    
    routeNameLabel.attributedText = generateAttributeString(title: "Route", description: "US 101S")
    distanceLabel.attributedText = generateAttributeString(title: "Distance", description: "13.4mi")
    
  }
  
   func generateAttributeString(title: String, description: String) -> NSAttributedString {
    
    let attributeString = NSMutableAttributedString(string: title + ": ",
                                                    attributes: [.font : UIFont.boldSystemFont(ofSize: 16)])
    attributeString.append(.init(string: description, attributes: [.font : UIFont.systemFont(ofSize: 16)]))
    return attributeString
    
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
}



//MARK: - SwiftUI Preview
struct RouteHeader_Previews: PreviewProvider {
  static var previews: some View {
    Container()
  }
  
  struct Container: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<RouteHeader_Previews.Container>) -> UIView {
      return RouteHeader()
    }
    
    func updateUIView(_ uiView: RouteHeader_Previews.Container.UIViewType, context: UIViewRepresentableContext<RouteHeader_Previews.Container>) {
      
    }
  }
}

