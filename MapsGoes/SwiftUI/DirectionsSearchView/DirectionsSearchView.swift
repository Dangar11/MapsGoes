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
  
  typealias UIViewType = MKMapView
  
  
  func makeUIView(context: UIViewRepresentableContext<DirectionMapView>) -> MKMapView {
    MKMapView()
  }
  
  func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<DirectionMapView>) {
    
  }
}


// application brain keep tracking
class DirectionEnvironment: ObservableObject {
  
  @Published var selectedSourceMapItem: MKMapItem?
  @Published var destinationMapItem: MKMapItem?
  
  @Published var isSelectingSource = false
  @Published var isSelectingDestination = false
  
}


//MARK: Direction View Screen
  
  
  struct DirectionsSearchView: View {
    
    @EnvironmentObject var environment: DirectionEnvironment
    
    
    var body: some View {
      
      NavigationView {
        ZStack(alignment: .top) {
          VStack(spacing: 0) {
            VStack(spacing: 12) {
              HStack(spacing: 16) {
                Image(uiImage: #imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate)).resizable()
                  .frame(width: 32, height: 32)
                  .foregroundColor(.white)
                NavigationLink(destination: SelectLocationView(), isActive: $environment.isSelectingSource) {
                  HStack {
                    Text(environment.selectedSourceMapItem != nil ?
                      (environment.selectedSourceMapItem?.name ?? "") : "Source")
                    Spacer()
                  }
                  .padding()
                  .background(Color.white)
                  .cornerRadius(5)
                }
              }
              HStack(spacing: 16) {
                Image(uiImage: #imageLiteral(resourceName: "end").withRenderingMode(.alwaysTemplate)).resizable()
                  .frame(width: 32, height: 32)
                  .foregroundColor(.white)
                NavigationLink(destination: SelectLocationView(), isActive: $environment.isSelectingDestination) {
                  HStack {
                    Text(environment.destinationMapItem != nil ? (environment.destinationMapItem?.name ?? "") : "Destination")
                    Spacer()
                  }
                  .padding()
                  .background(Color.white)
                  .cornerRadius(5)
                }
              }
            }
            .padding()
            .background(Color.blue)
            
            DirectionMapView()
              .edgesIgnoringSafeArea(.bottom)
          }
          
          //status bar cover up
          
          Spacer().frame(width: UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.frame.width,
                         height: UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top)
            .background(Color.blue)
            .edgesIgnoringSafeArea(.top)
          
        }
        .navigationBarTitle("Directions")
        .navigationBarHidden(true)
      }
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

