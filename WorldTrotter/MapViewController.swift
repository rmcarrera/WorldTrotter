//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Roxana Carrera on 2/3/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate{//, CLLocationManagerDelegate{
    var mapView: MKMapView!
    var curLoc: CLLocationCoordinate2D!
    //curLoc = self.mapView.centerCoordinate
    //mapView delegate
    //mapview will start locating

    //self.mapView.setCenter
    let locationManager = CLLocationManager()
    var doubleTap : Bool! = false
    var isHighLighted:Bool = false
    let annotation1 = MKPointAnnotation()
    let annotation2 = MKPointAnnotation()
    let annotation3 = MKPointAnnotation()
    var pinCount = 0
    
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
        
        //mapView.delegate = self
        
        //set it as the view of this view controller
        view = mapView
        
        mapView.delegate = self
        
        //curLoc = self.mapView.centerCoordinate
        
        let button:UIButton = UIButton(type: .system)
        button.frame = CGRect.init(x: 210, y: 570, width: 120, height: 25)
        button.setTitle("My Location", for: .normal)
        //Programatically added a button for the map view
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0).cgColor
        //let locationString = NSLocalizedString("Current Location", comment: "Current Location Button")
       // button.setTitle(locationString, for: .normal)
        //button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchDown)
        self.view.addSubview(button)
        
        
        let pinsButton:UIButton = UIButton(type: .system)
        pinsButton.frame = CGRect.init(x: 30, y: 570, width: 120, height: 25)
        pinsButton.setTitle("Pins", for: .normal)
        pinsButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinsButton.layer.cornerRadius = 5
        pinsButton.layer.borderWidth = 1
        pinsButton.layer.borderColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0).cgColor
        self.view.addSubview(pinsButton)
        pinsButton.addTarget(self, action: #selector(pressPins(button:)), for: .touchDown)
        
        
        /*annotation1.coordinate = CLLocationCoordinate2DMake(35.973128, -79.994954)
        annotation1.title = "High Point University"
        mapView.addAnnotation(annotation1)*/
        /*annotation2.coordinate = CLLocationCoordinate2DMake(16.555595, -96.027757)
        annotation2.title = "Oaxaca, Mexico"
        mapView.addAnnotation(annotation2)*/
       /* annotation3.coordinate = CLLocationCoordinate2DMake(28.385261, -81.563498)
        annotation3.title = "Disney World"
        mapView.addAnnotation(annotation3)*/
        
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
        
        /*let bottomConst = button.bottomAnchor.constraint(equalTo: bottomLayoutGuide.bottomAnchor, constant: -8)
        bottomConst.isActive = true
        let  leadC = button.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        leadC.isActive = true*/
        
        
        topConstriant.isActive = true
        leadingConstriant.isActive = true
        trailingConstriant.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Programatically added a button for the map view
        /*let button = UIButton(frame: CGRect(x: 210, y: 550, width: 140, height: 44))
        //button.buttonType = UIButtonType.roundedRect
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.blue.cgColor
        let locationString = NSLocalizedString("Current Location", comment: "Current Location Button")
        button.setTitle(locationString, for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(pressButton(button:)), for: .touchDown)
        self.view.addSubview(button)*/
        
        //Pins
       /* let annotation1 = MKPointAnnotation()
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
        mapView.addAnnotation(annotation3)*/
        
      
        
        print("MapViewController did load")
    }
    
    /*func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations[0]
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }*/
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)
        let mylocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(userLocation.coordinate.latitude,userLocation.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(mylocation, span)
        mapView.setRegion(region, animated: true)
       // self.mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    func pressButton(button: UIButton){
        if (doubleTap == true) {
            //Second Tap
            pinCount = 0
            loadView()
            doubleTap = false
        } else {
            //First Tap
            button.backgroundColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
           // locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            //mapView.
            //locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
            pinCount = 0 //reset pins
            doubleTap = true
        }
        /*locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()*/
        print("Pressed")
    }
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        // get the particular pin that was tapped
        let pinToZoomOn = view.annotation
        
        // optionally you can set your own boundaries of the zoom
        let span = MKCoordinateSpanMake(0.5, 0.5)
        
        // or use the current map zoom and just center the map
        // let span = mapView.region.span
        
        // now move the map
        let region = MKCoordinateRegion(center: pinToZoomOn!.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func pressPins(button: UIButton){
       /* if isHighLighted == true{
            loadView()
            isHighLighted = false
        }*/
       // else{
            //let region = MKCoordinateRegion(
            let span = MKCoordinateSpanMake(0.5, 0.5)
            var region: MKCoordinateRegion
            if pinCount == 0{
                //doubleTap = false;//reset to current location
                annotation1.coordinate = CLLocationCoordinate2DMake(35.973128, -79.994954)
                annotation1.title = "High Point University"
                mapView.addAnnotation(annotation1)
                region = MKCoordinateRegion(center: annotation1.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                pinCount += 1
                print("1")
            }
            else if pinCount == 1{
                //doubleTap = false;
                annotation2.coordinate = CLLocationCoordinate2DMake(16.555595, -96.027757)
                annotation2.title = "Oaxaca, Mexico"
                mapView.addAnnotation(annotation2)
                region = MKCoordinateRegion(center: annotation2.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                pinCount += 1
                print("2")
            }
            else if pinCount == 2 {
                //doubleTap = false;
                annotation3.coordinate = CLLocationCoordinate2DMake(28.385261, -81.563498)
                annotation3.title = "Disney World"
                mapView.addAnnotation(annotation3)
                region = MKCoordinateRegion(center: annotation3.coordinate, span: span)
                mapView.setRegion(region, animated: true)
                pinCount += 1
                print("3")
            }
            else if doubleTap == true {
                doubleTap = false
                pinCount = 0
                //locationManager.delegate = self
                //locationManager.desiredAccuracy = kCLLocationAccuracyBest
               // locationManager.startUpdatingLocation()
            }
            else{
                pinCount = 0
               // region = MKCoordinateRegion(center: curLoc, span: span)
                //self.mapView.setRegion(region, animated: true)
                //let curLoc = self.mapView.centerCoordinate
                //self.mapView.setCenter(curLoc, animated: true)
                //mapView.centerCoordinate
                loadView()
            }
            button.backgroundColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
            button.setTitleColor(UIColor.white, for: .normal)
            isHighLighted = true
        //}
    }
    
}
