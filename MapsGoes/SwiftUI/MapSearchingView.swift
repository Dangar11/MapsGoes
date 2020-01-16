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
  
  var annotations = [MKPointAnnotation]()
  
  let mapView = MKMapView()
  
  func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
    //setup region
    setupRegionForMap()
    return mapView
  }
  
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 50.439833, longitude: 30.540917)
    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
    uiView.removeAnnotations(uiView.annotations)
    uiView.addAnnotations(annotations)
    uiView.showAnnotations(uiView.annotations, animated: true)

  }
  
  typealias UIViewType = MKMapView
  
}






struct MapSearchingView: View {
  
  //watch for changes occuring in viewModel
  @ObservedObject var viewModel = MapSearchingViewModel()

  
    var body: some View {
      ZStack(alignment: .top) {
        MapViewContainer(annotations: viewModel.annotations)
          .edgesIgnoringSafeArea(.all)
        VStack(spacing: 12) {
          HStack {
            TextField("SearchTerms", text: $viewModel.searchQuery)
                       .padding(.horizontal, 16)
                       .padding(.vertical, 12)
                       .background(Color.white)
          }
          .shadow(radius: 3)
          .padding()
                      
          if viewModel.isSearching {
            Text("Searching...")
          }
          
        }
        
      }
  }
      
 



struct MapSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchingView()
    }
}

}
