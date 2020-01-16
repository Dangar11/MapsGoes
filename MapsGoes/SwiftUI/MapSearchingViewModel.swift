//
//  MapSearchingViewModel.swift
//  MapsGoes
//
//  Created by Igor Tkach on 16.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import MapKit

//track all properties which swiftUI render
class MapSearchingViewModel: ObservableObject {
  
  //
   @Published var annotations = [MKPointAnnotation]()
  @Published var isSearching = false
  
    func performSearch(query: String) {
      isSearching = true
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
        self.isSearching = false
    }
  }
  
  
}
