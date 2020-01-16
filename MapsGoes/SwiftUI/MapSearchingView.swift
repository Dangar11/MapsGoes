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
  
  @State var searchQuery = "sushi"
  
  @State var annotations = [MKPointAnnotation]()
  
    var body: some View {
      ZStack(alignment: .top) {
        MapViewContainer(annotations: annotations)
          .edgesIgnoringSafeArea(.all)
        HStack {
          Button(action: {
            //let's perform airport search
            self.performSearch(query: self.searchQuery)
          }, label: {
            Text("Search for \(searchQuery)")
            .padding()
              .background(Color.white)
          })
          Button(action: {
            self.annotations = []
          }, label: {
            Text("Clear Annotation")
            .padding()
              .background(Color.white)
          })
        }
        .shadow(radius: 3)
        
      }
  }
      
      fileprivate func performSearch(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (response, error) in
          //Error
          if let error = error {
            print("Search query failed: ", error.localizedDescription)
          }
          
          var airportAnnotations = [MKPointAnnotation]()
          
          //Success
          response?.mapItems.forEach({ (mapItem) in
            let annotation = MKPointAnnotation()
            annotation.title = mapItem.name
            annotation.coordinate = mapItem.placemark.coordinate
            airportAnnotations.append(annotation)
          })
          self.annotations = airportAnnotations
      }
    }



struct MapSearchingView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchingView()
    }
}

}
