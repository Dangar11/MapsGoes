//
//  DirectionsSearchView.swift
//  MapsGoes
//
//  Created by Igor Tkach on 18.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import MapKit

struct DirectionMapView: UIViewRepresentable {
  
  typealias UIViewType = MKMapView
  
  
  
  func makeUIView(context: UIViewRepresentableContext<DirectionMapView>) -> MKMapView {
    MKMapView()
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<DirectionMapView>) {
    
  }
}


struct DirectionsSearchView: View {
  
  let appWidth = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.frame.width
  let safeAreaHeight = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.safeAreaInsets.top
  
  var body: some View {
    ZStack(alignment: .top) {
      
      VStack(spacing: 0) {
        VStack {
          HStack(spacing: 16) {
            Image(uiImage: #imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate)).resizable()
              .frame(width: 32, height: 32)
              .foregroundColor(.white)
            HStack {
              Text("Source")
              Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(5)
            
          }
          HStack(spacing: 16) {
            Image(uiImage: #imageLiteral(resourceName: "end").withRenderingMode(.alwaysTemplate)).resizable()
              .frame(width: 32, height: 32)
              .foregroundColor(.white)
            HStack {
              Text("Destination")
              Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(5)
          }
        }
        .padding()
        .background(Color.blue)
        
        DirectionMapView()
          .edgesIgnoringSafeArea(.bottom)
      }
      
      //status bar cover up

      Spacer().frame(width: appWidth, height: safeAreaHeight)
        .background(Color.blue)
        .edgesIgnoringSafeArea(.top)
      
    }
  }
}

struct DirectionsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsSearchView()
    }
}
