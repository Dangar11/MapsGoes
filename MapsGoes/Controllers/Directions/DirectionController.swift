//
//  DirectionController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 10.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import UIKit
import LBTATools
import MapKit
import SwiftUI

class DirectionController: UIViewController {
  
  //MARK: - Properties
  let mapView = MKMapView()
  
  let startTextField = IndentedTextField(placeholder: "Start", padding: 12, cornerRadius: 5)
  let endTextField = IndentedTextField(placeholder: "End", padding: 12, cornerRadius: 5)
  
  
  
  //MARK: - ViewLifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupRegionForMap()
    
    setupNavBarUI()
    
    mapView.showsUserLocation = true
    mapView.delegate = self
    
    setupStardEndDummyAnnotataion()
    requestForDirections()
    navigationController?.navigationBar.isHidden = true
    
  }
  
  //MARK: - Functionality
  fileprivate func setupRegionForMap() {
    let centerCoordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let region = MKCoordinateRegion(center: centerCoordinate, span: span)
    mapView.setRegion(region, animated: true)
    
  }
  
  fileprivate func setupStardEndDummyAnnotataion() {
    
    let startAnnotation = MKPointAnnotation()
    startAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605)
    startAnnotation.title = "Start"
    
    let endAnnotation = MKPointAnnotation()
    endAnnotation.coordinate = CLLocationCoordinate2D(latitude: 49.410400, longitude: 26.978805)
    endAnnotation.title = "End"
    
    
    mapView.addAnnotation(startAnnotation)
    mapView.addAnnotation(endAnnotation)
    
  }
  
  
  fileprivate func requestForDirections() {
    
    let request = MKDirections.Request()
    
    let startingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.420382, longitude: 26.988605))
    
    let endingPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.410400, longitude: 26.978805))
    
    //start point
    request.source = .init(placemark: startingPlacemark)
    //end point
    request.destination = .init(placemark: endingPlacemark)
    
    request.requestsAlternateRoutes = true
    
    let directions = MKDirections(request: request)
    directions.calculate { (response, error) in
      if let error = error {
        print("Unable to calculate route: ", error.localizedDescription)
      }
      
      //Success
      //Iterate throught routes and show alternate routes
      response?.routes.forEach({ (route) in
        //need to render in MKMapViewDelegate
        
        self.mapView.addOverlay(route.polyline)
      })
      
      
      
      
    }
    
  }
  
  
  //MARK: - UI
  
  fileprivate func setupNavBarUI() {
    
    
    let navBar = UIView(backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
    view.addSubview(navBar)
    navBar.setupShadow(opacity: 0.5, radius: 5)
    navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -120, right: 0))
    
    view.addSubview(mapView)
    mapView.anchor(top: navBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    
    
    let font = UIFont.systemFont(ofSize: 22, weight: .light)
    startTextField.attributedPlaceholder = .init(string: "Start",
                                                 attributes: [.foregroundColor: UIColor.init(white: 1, alpha: 0.9), .font : font])
    
    endTextField.attributedPlaceholder = .init(string: "End",
                                               attributes: [.foregroundColor: UIColor.init(white: 1, alpha: 0.9), .font : font])
    
    [startTextField, endTextField].forEach { (tf) in
      tf.backgroundColor = .init(white: 1, alpha: 0.3)
      tf.textColor = .white
      tf.font = font
    }
    
    let startImageView = UIImageView(image: #imageLiteral(resourceName: "start").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
    startImageView.tintColor = .white
    startImageView.constrainWidth(35)
    let endImageView = UIImageView(image: #imageLiteral(resourceName: "end").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
    endImageView.tintColor = .white
    endImageView.constrainWidth(35)
    
    
    let containerView = UIView(backgroundColor: .clear)
    navBar.addSubview(containerView)
    containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: navBar.leadingAnchor, bottom: navBar.bottomAnchor, trailing: navBar.trailingAnchor)
    
    let topHorizonStackView = containerView.hstack(startImageView, startTextField, spacing: 16)
    let bottomHorizonStackView = containerView.hstack(endImageView, endTextField, spacing: 16)
    
    containerView.stack(topHorizonStackView,
                        bottomHorizonStackView,
                        spacing: 12,
                        distribution: .fillEqually)
      .withMargins(.init(top: 12, left: 12, bottom: 12, right: 12))
    
    startTextField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangeStartLocation)))
    
  }
  
  
  @objc fileprivate func handleChangeStartLocation() {
    let vc = UIViewController()
    vc.view.backgroundColor = .green
    
    // back button hack
    let button = UIButton(title: "Back", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .clear, target: self, action: #selector(handleBackButton))
    vc.view.addSubview(button)
    button.fillSuperviewSafeAreaLayoutGuide()
    navigationController?.pushViewController(vc, animated: true)
    
  }
  
  
  @objc fileprivate func handleBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
}




//MARK: - MKMapViewDelegate
extension DirectionController: MKMapViewDelegate {
  
  //Render Polyline

  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polylineRenderer = MKPolylineRenderer(overlay: overlay)
    polylineRenderer.strokeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    polylineRenderer.lineWidth = 5
    return polylineRenderer
  }
  
}
  
  
  
  
  //MARK: - SwiftUI Preview
  struct DirectionPreview: PreviewProvider {
    
    static var previews: some View {
      ContainerView().edgesIgnoringSafeArea(.all) // ignore safe area and fill fullscreen
//        .environment(\.colorScheme, .dark)  // darkMode
    }
    
    
    // View Container
    struct ContainerView: UIViewControllerRepresentable {
      

      //viewController instance to present
      func makeUIViewController(context: UIViewControllerRepresentableContext<DirectionPreview.ContainerView>) -> UIViewController {
        return UINavigationController(rootViewController: DirectionController())
      }
      
      //updates to latest changes
      func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DirectionPreview.ContainerView>) {
        
      }
    }
  }
  
  

  
  

