//
//  SwipingController.swift
//  random-fave
//
//  Created by Nurhasrizal Jamhari on 22/10/2021.
//  Copyright © 2021 rizaljamhari. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Moya

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let provider = MoyaProvider<Fave>()
    let locationManager = CLLocationManager()
    
    var categories = [Category]()
    var currentIndex = 0
    
    private func buildCategoryScreen() {
        fetchFragments(completion: { (fragments) -> Void in
            self.categories = fragments
            
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
            
            
            self.collectionView?.backgroundColor = .white
            self.collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "cellId")
            
            self.collectionView?.isPagingEnabled = true
            
            self.setupBottomControls()
        })
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = categories.count
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = .favePink
        pc.preferredIndicatorImage = UIImage.init(systemName: "heart.fill")
        return pc
    }()
    
    fileprivate func setupBottomControls() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [pageControl])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    fileprivate func setupButton() {
        let button = LoadingButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .favePink
        button.setTitleColor(.mainPink, for: .normal)
        button.setTitle("I'm feeling lucky :)", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 80),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -80),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func buttonAction(sender: LoadingButton!) {
        sender.startAnimatingPressActions()
        sender.showLoading()
        
        let currentCategory = categories[pageControl.currentPage]
        
        fetchOutlets(categoryId: currentCategory.id, completion: { (outlets) -> Void in
            sender.hideLoading()
            guard let randomOutlet = outlets.randomElement() else { return }
            
            let popoutOutletVC = PopupOutletViewController()
            popoutOutletVC.modalPresentationStyle = .overCurrentContext
            popoutOutletVC.outlet = randomOutlet
            self.present(popoutOutletVC, animated: false)
        })
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x / view.frame.width)
    }
    
    private func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            provider.request(.location) { result in
                switch result {
                case let .success(response):
                    do {
                        let filteredResponse = try response.filterSuccessfulStatusCodes()
                        let json = try filteredResponse.map(Location.self)
                        
                        UserDefaults.standard.setUserCountryCode(value: json.city.country_code)
                        UserDefaults.standard.setUserCityId(value: json.city.id)
                    }
                    catch let error {
                        print(error)
                        // TODO: handle the error == best. comment. ever.
                    }
                case let .failure(error):
                    print(error)
                    // TODO: handle the error == best. comment. ever.
                }
            }
        }
    }
    
    private func fetchFragments(completion: @escaping (_ fragments:[Category]) -> Void) {
        provider.request(.fragments) { result in
            var fragments = [Category]()
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    fragments = try filteredResponse.map([Category].self, atKeyPath: "fragments", using: decoder)
                    
                    let blacklistFragments = ["eCards", "Charity"]
                    
                    fragments.removeAll { category in
                        blacklistFragments.contains(category.name)
                    }
                }
                catch let error {
                    print(error)
                    // TODO: handle the error == best. comment. ever.
                }
            case let .failure(error):
                print(error)
                // TODO: handle the error == best. comment. ever.
            }
            
            return completion(fragments)
        }
    }
    
    private func fetchOutlets(categoryId: Int, completion: @escaping (_ outlets:[Outlet]) -> Void) {
        provider.request(.outlets(categoryId: categoryId)) { result in
            var outlets = [Outlet]()
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    outlets = try filteredResponse.map([Outlet].self, atKeyPath: "outlets", using: decoder)
                }
                catch let error {
                    print(error)
                    // TODO: handle the error == best. comment. ever.
                }
            case let .failure(error):
                print(error)
                // TODO: handle the error == best. comment. ever.
            }
            
            return completion(outlets)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        UserDefaults.standard.setUserLatitude(value: String(locValue.latitude))
        UserDefaults.standard.setUserLongitude(value: String(locValue.longitude))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        buildCategoryScreen()
        setupButton()
        
    }
    
}
