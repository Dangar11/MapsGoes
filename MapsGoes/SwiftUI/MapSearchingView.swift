//
//  MapSearchingView.swift
//  MapsGoes
//
//  Created by Igor Tkach on 16.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViewContainer: UIViewRepresentable {
  
  let mapView = MKMapView()
  
  func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
    //setup region
    setupRegionForMap()
    return mapView
  }
  
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
    
  }
  
  typealias UIViewType = MKMapView
  
}



struct MapSearchingView: View {
    var body: some View {
      ZStack(alignment: .top) {
        MapViewContainer()
          .edgesIgnoringSafeArea(.all)
        HStack {
          Button(action: {
          }, label: {
            Text("Search for airports")
            .padding()
              .background(Color.white)
          })
          Button(action: {
            
          }, label: {
            Text("Clear Annotation")
            .padding()
              .background(Color.white)
          })
        }
        .shadow(radius: 3)
        
      }
    }
}

struct MapSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchingView()
    }
}
