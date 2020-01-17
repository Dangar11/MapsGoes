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
class MapSearchingViewModel: NSObject, ObservableObject {
  
  //
   @Published var annotations = [MKPointAnnotation]()
   @Published var isSearching = false
   @Published var searchQuery = "" {
    didSet {
//      performSearch(query: searchQuery)
    }
  }
  
  @Published var mapItems = [MKMapItem]()
  @Published var selectedMapItem: MKMapItem?
  //Keyboard
  @Published var keyboardHeight: CGFloat = 0
  @Published var currentLocation = CLLocationCoordinate2D(latitude: 50.439833, longitude: 30.540917)
  
  var textFieldNotification: AnyCancellable?
  
  
  //user location
  let locationManager = CLLocationManager()
  
  
  override init() {
    super.init()
    //Combine
    textFieldNotification = $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] (searchString) in
        guard let self = self else { return }
        self.performSearch(query: searchString)
    }
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    
    listenForKeyboardNotification()
    
  }
  
  fileprivate func listenForKeyboardNotification() {
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self]
      (notification) in
      guard let self = self else { return }
      guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
      let keyboardFrame = value.cgRectValue
      let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
      guard let bottomSafeArea = window?.safeAreaInsets.bottom else { return }
      
      
      withAnimation(.easeOut(duration: 0.25)) {
        self.keyboardHeight = keyboardFrame.height - bottomSafeArea
      }
      
    }
    
    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
      self?.keyboardHeight = 0
    }
  }
  
    fileprivate func performSearch(query: String) {
      isSearching = true
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = query
      let localSearch = MKLocalSearch(request: request)
      localSearch.start { (response, error) in
        //Error
        if let error = error {
          print("Search query failed: ", error.localizedDescription)
        }
        guard let resonseItems = response?.mapItems else { return }
        self.mapItems = resonseItems
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


extension MapSearchingViewModel: CLLocationManagerDelegate {
  
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
      locationManager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else { return }
    self.currentLocation = firstLocation.coordinate
  }
  
}
