//
//  MapSearchingViewModel.swift
//  MapsGoes
//
//  Created by Igor Tkach on 16.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

//track all properties which swiftUI render
class MapSearchingViewModel: ObservableObject {
  
  //
   @Published var annotations = [MKPointAnnotation]()
   @Published var isSearching = false
   @Published var searchQuery = "" {
    didSet {
//      performSearch(query: searchQuery)
    }
  }
  
  var textFieldNotification: AnyCancellable?
  
  init() {
    print("Initializing view model")
    //Combine
    textFieldNotification = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] (searchString) in
        guard let self = self else { return }
        self.performSearch(query: searchString)
    }
  }
  
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
