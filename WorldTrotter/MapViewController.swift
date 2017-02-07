//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Roxana Carrera on 2/3/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    override func loadView() {
        //create a map view
        mapView = MKMapView()
        
        //set it as the view of this view controller
        view = mapView
        
        //let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstriant = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstriant = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstriant = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstriant.isActive = true
        leadingConstriant.isActive = true
        trailingConstriant.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(frame: CGRect(x: 210, y: 550, width: 140, height: 44))
        button.backgroundColor = UIColor.clear
        button.setTitle("Current Location", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchDown)
        self.view.addSubview(button)
        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = CLLocationCoordinate2DMake(35.973128, -79.994954)
        annotation1.title = "I AM HERE"
        mapView.addAnnotation(annotation1)
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2DMake(16.555595, -96.027757)
        annotation2.title = "I WAS BORN HERE"
        mapView.addAnnotation(annotation2)
        let annotation3 = MKPointAnnotation()
        annotation3.coordinate = CLLocationCoordinate2DMake(28.385261, -81.563498)
        annotation3.title = "I VISITED HERE"
        mapView.addAnnotation(annotation3)
        print("MapViewController did load")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    func pressButton(button: UIButton){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        print("Pressed")
    }
}
