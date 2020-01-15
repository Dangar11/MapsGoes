//
//  PlacesController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 11.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import LBTATools
import MapKit
import GooglePlaces
import JGProgressHUD

class PlacesController: UIViewController {
  
  //MARK: - Properties
  let mapView = MKMapView()
  let locationManager = CLLocationManager()
  let client = GMSPlacesClient()
  
  var currentCustomCallout: UIView?
  
  lazy var infoButton = UIButton(type: .infoLight)
  let hudNameLabel = UILabel(text: "Name", font: .boldSystemFont(ofSize: 16))
  let hudAddressLabel = UILabel(text: "Address", font: .systemFont(ofSize: 16))
  let hudTypesLabel = UILabel(text: "Types", textColor: .gray)
  let hudContainer = UIView(backgroundColor: .white)
  
  
  //MARK: - ViewLifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(mapView)
    mapView.fillSuperview()
    mapView.showsUserLocation = true
    locationManager.delegate = self
    mapView.delegate = self
    
    requestForLocationAuthorization()
    
  }
  
  
  //MARK: - Functionality
  
  //Retrieve places from GoogleLikelyhood
   func findNearbyPlaces() {
    client.currentPlace { [weak self] (likelihoodList, err) in
      if let err = err {
        print("Failed to find current place:", err)
        return
      }
      
      likelihoodList?.likelihoods.forEach({  (likelihood) in
        print(likelihood.place.name ?? "")
        
        let place = likelihood.place
        
        let annotation = GooglePlaceCustomAnnotation(place: place)
        annotation.title = place.name
        annotation.coordinate = place.coordinate
        
        self?.mapView.addAnnotation(annotation)
      })
      
      self?.mapView.showAnnotations(self?.mapView.annotations ?? [], animated: false)
    }
  }
  
  
  
  fileprivate func requestForLocationAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  
  func selectedAnnotationHUD() {
    
    infoButton.addTarget(self, action: #selector(handlePlacePhoto), for: .touchUpInside)
    
    view.addSubview(hudContainer)
    hudContainer.layer.cornerRadius = 5
    hudContainer.setupShadow(opacity: 0.2, radius: 5, offset: .zero, color: .darkGray)
    hudContainer.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .allSides(16), size: .init(width: 0, height: 125))
    
    let topRow = UIView()
    topRow.hstack(hudNameLabel, infoButton.withWidth(44))
    hudContainer.hstack(hudContainer.stack(topRow,
                                           hudAddressLabel,
                                           hudTypesLabel, spacing: 8), alignment: .center).withMargins(.allSides(16))
    
  }
  
  @objc fileprivate func handlePlacePhoto() {
    
    guard let placeAnnotation = mapView.selectedAnnotations.first as? GooglePlaceCustomAnnotation else { return }
    guard let placeId = placeAnnotation.place.placeID else { return }
    
    let hud = JGProgressHUD(style: .dark)
    hud.textLabel.text = "Loading photos..."
    hud.show(in: view)
    
    //all photos for place
    client.lookUpPhotos(forPlaceID: placeId) { (list, error) in
      //Error
      if let error = error {
        hud.dismiss()
        print("Failed to load list: ", error.localizedDescription)
      }
      
      //Success
      let dispatchGroup = DispatchGroup()
      
      var images = [UIImage]()
      
      list?.results.forEach({ [weak self](photoMetaData) in
        dispatchGroup.enter()
        
        guard let self = self else { return }
        self.client.loadPlacePhoto(photoMetaData) { (image, error) in
          //Error
          if let error = error {
            hud.dismiss()
            print("Failed to load photoMetaData: ", error.localizedDescription)
          }
          
          //Success
          dispatchGroup.leave()
          guard let image = image else { return }
          images.append(image)
        }
      })
      
      //Notify when other call leaving dispatch
      dispatchGroup.notify(queue: .main) {
        hud.dismiss()
        let controller = PlacePhotosController()
        controller.items = images
          self.present(UINavigationController(rootViewController: controller), animated: true, completion: nil)
        controller.navigationItem.title = placeAnnotation.place.name
      }
    }
  }
  
  
  
  
  
  
}



//MARK: - SwiftUI Preview
struct PlacesController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlacesController_Previews.Container>) -> UIViewController {
      PlacesController()
    }
    
    func updateUIViewController(_ uiViewController: PlacesController_Previews.Container.UIViewControllerType, context: UIViewControllerRepresentableContext<PlacesController_Previews.Container>) {
      
    }
  }
}
