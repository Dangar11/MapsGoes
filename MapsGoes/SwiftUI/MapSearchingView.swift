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
  
  
  
  typealias UIViewType = MKMapView
  
  var annotations = [MKPointAnnotation]()
  var selectedMapItem: MKMapItem?
  var currentLocation = CLLocationCoordinate2D(latitude: 50.439833, longitude: 30.540917)
  
  let mapView = MKMapView()
  

  
  func makeUIView(context: UIViewRepresentableContext<MapViewContainer>) -> MKMapView {
    //setup region
    setupRegionForMap()
    mapView.showsUserLocation = true
    return mapView
  }
  
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 50.439833, longitude: 30.540917)
    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewContainer>) {
    
    let span = MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
    let region = MKCoordinateRegion(center: currentLocation, span: span)
    uiView.setRegion(region, animated: true)
  
    
    uiView.removeAnnotations(uiView.annotations)
    uiView.addAnnotations(annotations)
    uiView.showAnnotations(uiView.annotations, animated: true)
    
    uiView.annotations.forEach { (annotation) in
      if annotation.title == selectedMapItem?.name {
        uiView.selectAnnotation(annotation, animated: true)
      }
    }
  }
  
  
  //MARK: Coordinator
  func makeCoordinator() -> MapViewContainer.Coordinator {
    return Coordinator(mapView: mapView)
  }
  
   
  
  // set mapView.delegate
  class Coordinator: NSObject, MKMapViewDelegate {
    
    init(mapView: MKMapView) {
      super.init()
      mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if !(annotation is MKPointAnnotation) { return nil }
      let pinAnnoationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
      pinAnnoationView.canShowCallout = true
      return pinAnnoationView
    }
    
  }
  
  
}






struct MapSearchingView: View {
  
  //watch for changes occuring in viewModel
  @ObservedObject var viewModel = MapSearchingViewModel()

  
    var body: some View {
      ZStack(alignment: .top) {
        
        MapViewContainer(annotations: viewModel.annotations, selectedMapItem: viewModel.selectedMapItem, currentLocation: viewModel.currentLocation)
          .edgesIgnoringSafeArea(.all)
        VStack(spacing: 12) {
          HStack {
            TextField("Search terms", text: $viewModel.searchQuery, onCommit: {
//              UIApplication.shared.keyWindow?.endEditing(true)
            })
                       .padding(.horizontal, 16)
                       .padding(.vertical, 12)
                       .background(Color.white)
          }
          .padding()
                      
          if viewModel.isSearching {
            Text("Searching...")
          }
          Spacer()
          
          ScrollView(.horizontal) {
            HStack(spacing: 16) {
              ForEach(viewModel.mapItems, id: \.self) { mapItem in
                Button(action: {
                  self.viewModel.selectedMapItem = mapItem
                }) {
                   VStack(alignment: .leading, spacing: 4) {
                                    Text(mapItem.name ?? "")
                                      .font(.headline)
                                    Text(mapItem.placemark.title ?? "")
                }
                }
                .foregroundColor(.black)
                .padding()
                .frame(width: 200)
                  .background(Color.white)
                .cornerRadius(5)
              }
            }
          .padding(.horizontal, 16)
          }
          .shadow(radius: 5)
          
          Spacer().frame(height: self.viewModel.keyboardHeight)
          
        }
        
      }
  }
      
 



struct MapSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchingView()
    }
}

}
