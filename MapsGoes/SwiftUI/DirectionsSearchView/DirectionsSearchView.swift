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


struct SelectLocationView: View {
  
  // here is the magic
  @Binding var isShowing: Bool
  
  @State var mapItems = [MKMapItem]()
  
  @State var searchQuery = ""
  
  var body: some View {
    VStack {
      HStack(spacing: 16) {
        Button(action: {
          
          // need to dismiss this view somehow???
          self.isShowing = false
          
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
          }
        }
        Spacer()
      }
      .edgesIgnoringSafeArea(.bottom)
      .navigationBarTitle("")
      .navigationBarHidden(true)
    }
  }

  
  
  struct DirectionsSearchView: View {
    
    
    @State var isSelectingSource = false
    
    var body: some View {
      
      NavigationView {
        ZStack(alignment: .top) {
          VStack(spacing: 0) {
            VStack {
              HStack(spacing: 16) {
                Image(uiImage: #imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate)).resizable()
                  .frame(width: 32, height: 32)
                  .foregroundColor(.white)
                NavigationLink(destination: SelectLocationView(isShowing: $isSelectingSource), isActive: $isSelectingSource) {
                  HStack {
                    Text("Source")
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
    static var previews: some View {
      DirectionsSearchView()
    }
}

