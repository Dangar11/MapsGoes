//
//  DirectionsSearchView.swift
//  MapsGoes
//
//  Created by Igor Tkach on 18.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import MapKit
import Combine



struct DirectionMapView: UIViewRepresentable {
  
  
  @EnvironmentObject var environment: DirectionEnvironment
  
  typealias UIViewType = MKMapView
  
  let mapView = MKMapView()
  
  
  
  func makeCoordinator() -> DirectionMapView.Coordinator {
    return Coordinator(mapView: mapView)
  }
  
  //It's works like delegate pattern but with initializer, inherit from UIViewRepresentable
  class Coordinator: NSObject, MKMapViewDelegate {
    
    init(mapView: MKMapView) {
      super.init()
      mapView.delegate = self
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let renderer = MKPolylineRenderer(overlay: overlay)
      renderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
      renderer.lineWidth = 5
      return renderer
    }
    
  }
  
  func makeUIView(context: UIViewRepresentableContext<DirectionMapView>) -> MKMapView {
    mapView
    
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<DirectionMapView>) {
    
    uiView.removeAnnotations(uiView.annotations)
    uiView.removeOverlays(uiView.overlays)
    
    //Remove all optionals with compactMap and go loop thought all environment mapItem information
    [environment.selectedSourceMapItem, environment.destinationMapItem].compactMap{$0}.forEach { (mapItem) in
      let annotation = MKPointAnnotation()
      annotation.title = mapItem.name
      annotation.coordinate = mapItem.placemark.coordinate
      uiView.addAnnotation(annotation)
    }
  
  
    //Show on map two placemark
    uiView.showAnnotations(uiView.annotations, animated: true)
    
    //Show route
    guard let route = environment.route else { return }
    uiView.addOverlay(route.polyline)
  }
  
  
}


// application brain keep tracking
class DirectionEnvironment: ObservableObject {
  
  @Published var isCalculationDirections = false
  
  @Published var selectedSourceMapItem: MKMapItem?
  @Published var destinationMapItem: MKMapItem?
  
  @Published var isSelectingSource = false
  @Published var isSelectingDestination = false
  
  @Published var route: MKRoute?
  
  var cancellable: AnyCancellable?
  
  init() {
    //listen for changes in selectedSourceMapItem, destinationMapItem
    cancellable = Publishers.CombineLatest($selectedSourceMapItem, $destinationMapItem).sink {[weak self] (items) in
      guard let self = self else { return }
      //route directions calculation
      let request = MKDirections.Request()
      request.source = items.0
      request.destination = items.1
      let directions = MKDirections(request: request)
      self.isCalculationDirections = true
      //clear the old route when building a new route
      self.route = nil
      
      directions.calculate { [weak self] (response, error) in
        guard let self = self else { return }
        //Error
        if let error = error {
          print("Failed to calculate a routes directions: ", error)
        }
        //Success
        self.isCalculationDirections = false
        self.route = response?.routes.first
      }
    }
  }
  
}


//MARK: Direction View Screen
  
  
  struct DirectionsSearchView: View {
    
    @EnvironmentObject var environment: DirectionEnvironment
    
    
    var body: some View {
      
      NavigationView {
        ZStack(alignment: .top) {
          VStack(spacing: 0) {
            VStack(spacing: 12) {
              
              MapItemView(selectingSource: $environment.isSelectingSource, title: environment.selectedSourceMapItem != nil ?
                (environment.selectedSourceMapItem?.name ?? "") : "Source", image: #imageLiteral(resourceName: "start"))
              
              MapItemView(selectingSource: $environment.isSelectingDestination, title: environment.destinationMapItem != nil ?
                (environment.destinationMapItem?.name ?? "") : "Destination", image: #imageLiteral(resourceName: "end"))
            }
            .padding()
            .background(Color.blue)
            
            DirectionMapView()
              .edgesIgnoringSafeArea(.bottom)
          }
          //status bar cover up
          StatusBarCover()
          
          if environment.isCalculationDirections {
             ActivityIndicatorView()
          }
        }
        .navigationBarTitle("Directions")
        .navigationBarHidden(true)
      }
    }
}


struct LoadingHUD: UIViewRepresentable {
  typealias UIViewType = UIActivityIndicatorView
  
  func makeUIView(context: UIViewRepresentableContext<LoadingHUD>) -> UIActivityIndicatorView {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .white
    activityIndicator.startAnimating()
    return activityIndicator
  }
  
  func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingHUD>) {
    
  }
}


struct ActivityIndicatorView: View {
  
  var body: some View {
  VStack {
    Spacer()
    VStack {
      LoadingHUD()
      Text("Loading...").foregroundColor(.white)
        .font(.headline)
    }
  .padding()
    .background(Color.black)
    .cornerRadius(5)
    Spacer()
  }
  }
  
}

struct MapItemView: View {
  
  @EnvironmentObject var environment: DirectionEnvironment
  
  @Binding var selectingSource: Bool
  var title: String
  var image: UIImage
  
  var body: some View {
    HStack(spacing: 16) {
                   Image(uiImage: image.withRenderingMode(.alwaysTemplate)).resizable()
                     .frame(width: 32, height: 32)
                     .foregroundColor(.white)
                   NavigationLink(destination: SelectLocationView(), isActive: $selectingSource) {
                     HStack {
                      Text(title)
                       Spacer()
                     }
                     .padding()
                     .background(Color.white)
                     .cornerRadius(5)
                   }
                 }
  }
}


  

struct StatusBarCover: View {
  var body: some View {
    Spacer().frame(width: UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.width,
                 height: UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)
    .background(Color.blue)
    .edgesIgnoringSafeArea(.top)
  }
}
  
  
  struct DirectionsSearchView_Previews: PreviewProvider {
    
    static var environment = DirectionEnvironment()
    
    static var previews: some View {
      DirectionsSearchView().environmentObject(environment)
    }
}


//MARK: - Selection View Screen

struct SelectLocationView: View {
  
  @EnvironmentObject var environment: DirectionEnvironment
  
  // here is the magic
//  @Binding var isShowing: Bool
  
  @State var mapItems = [MKMapItem]()
  
  @State var searchQuery = ""
  
  var body: some View {
    VStack {
      HStack(spacing: 16) {
        Button(action: {
          
          // dismiss view
          self.environment.isSelectingSource = false
          self.environment.isSelectingDestination = false
          
        }, label: {
          Image(uiImage: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)).resizable()
            .foregroundColor(.black)
            .frame(width: 32, height: 32)
        })
        
        TextField("Enter search term", text: $searchQuery)
          .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification).debounce(for: .milliseconds(500), scheduler: RunLoop.main)) {_ in
            //search
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = self.searchQuery
            let search = MKLocalSearch(request: request)
            search.start { (response, error) in
              //Error
              if let error = error {
                print("Unable to search: ", error)
              }
              guard let mapItemsResponse = response?.mapItems else { return }
              self.mapItems = mapItemsResponse
            }
        }
        }.padding()
        
        if mapItems.count > 0 {
          ScrollView {
            ForEach(mapItems, id: \.self) { item in
              Button(action: {
                if self.environment.isSelectingSource {
                  //dismiss view
                  self.environment.isSelectingSource = false
                  //pass value from search
                  self.environment.selectedSourceMapItem = item
                } else {
                  self.environment.isSelectingDestination = false
                  self.environment.destinationMapItem  = item
                }
                
              }) {
                HStack {
                  VStack(alignment: .leading) {
                    Text("\(item.name ?? "")")
                      .font(.headline)
                    Text("\(item.address())")
                  }
                  Spacer()
                }
                .padding()
              }
              .foregroundColor(.black)
            }
          }
        }
        Spacer()
      }
      .edgesIgnoringSafeArea(.bottom)
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
  }

