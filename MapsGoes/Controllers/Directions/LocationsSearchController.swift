//
//  LocationsSearchController.swift
//  MapsGoes
//
//  Created by Igor Tkach on 10.01.2020.
//  Copyright © 2020 Igor Tkach. All rights reserved.
//

import SwiftUI
import UIKit
import LBTATools
import MapKit
import Combine


class LocationsSearchController: LBTAListController<LocationSearchCell, MKMapItem> {
  
  
  //MARK: - Properties
  
  //Delegate for name population textfield
  var selectionHandler: ((MKMapItem) -> ())?
 
  let navBarHeight: CGFloat = 80
  
  var textFieldNotification: AnyCancellable!
  
  let searchTextField = IndentedTextField(placeholder: "Enter Search Place", padding: 12)
  let backButtonIcon = UIButton(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), tintColor: .black, target: self, action: #selector(handleBack)).withWidth(50)

  
  //MARK: - ViewLifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    performLocalSearch()
    setupSearchBar()
    searchTextField.becomeFirstResponder()
  }
  
  //MARK: - CollectionView
  
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.popViewController(animated: true)
    let mapItem = self.items[indexPath.item]
    selectionHandler?(mapItem)
    //stop listening to text changes in searchField  in the future
    //Retain Cycle fix
       textFieldNotification?.cancel()
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    .init(top: navBarHeight, left: 0, bottom: 0, right: 0)
  }
  
  

  //MARK: - UI
  
  fileprivate func setupSearchBar() {
    
    let navBar = UIView(backgroundColor: .white)
    view.addSubview(navBar)
    navBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -navBarHeight, right: 0))
    
    // fix scrollbar insets
    collectionView.verticalScrollIndicatorInsets.top = navBarHeight
    
    let container = UIView(backgroundColor: .clear)
    navBar.addSubview(container)
    container.fillSuperviewSafeAreaLayoutGuide()
    container.hstack(backButtonIcon, searchTextField, spacing:12).withMargins(.init(top: 16, left: 0, bottom: 16, right: 16))
    searchTextField.layer.borderWidth = 2
    searchTextField.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    searchTextField.layer.cornerRadius = 5
    setupSearchListener()
    
    backButtonIcon.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    
  }
  
  //MARK: - Functionality
  
  fileprivate func performLocalSearch() {
    
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTextField.text
    
    let search = MKLocalSearch.init(request: request)
    search.start { (response, error) in
      if let error = error {
        print("Unable search for specific query: ", error.localizedDescription)
      }
      
      //Success
      self.items = response?.mapItems ?? []
      
    }
    
  }
  
  
  
  @objc fileprivate func handleBack() {
    navigationController?.popViewController(animated: true)
  }
  
  fileprivate func setupSearchListener() {
    
    textFieldNotification = NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { (_) in
        self.performLocalSearch()
    }
    //stop listening to text changes in searchField  in the future
       
  }
  
  
  
}



//MARK: - DelegateFlowLayout
extension LocationsSearchController: UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: view.frame.width, height: 70)
  }
  
}



//MARK: - SwiftUI Preview
struct LocationsSearchController_Previews: PreviewProvider {
    static var previews: some View {
      ContainerView().edgesIgnoringSafeArea(.all)
    }
  
  
  struct ContainerView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<LocationsSearchController_Previews.ContainerView>) -> UIViewController {
      LocationsSearchController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LocationsSearchController_Previews.ContainerView>) {
      
    }
    
    
    
    
  }
}
