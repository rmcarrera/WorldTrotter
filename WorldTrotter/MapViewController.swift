/* Roxana Carrera
 * CSC-2310-01
 * 02/20/2017
 * This will display a map view with options to switch map types. It also includes button that allow a user
 * to capture and zoom into their current location. A second button allows the user to iterate through a
 * series of pins which will be displayed on the map one by one.
 */

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    var mapView: MKMapView!
    var curLoc: CLLocationCoordinate2D!
    var CurSpan: MKCoordinateSpan!
    let locationManager = CLLocationManager()
    var isPinUsed:Bool = false
    var pins = [MKPointAnnotation]()
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
        
        //set it as the view of this view controller
        view = mapView
        
        mapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()//triggers a message to allow user of app access to user loc
        
        let button = UIButton.init(type: .system)
        initLocButton(button)
        
        button.addTarget(self, action: #selector(pressLocation(button:)), for: .touchDown)
        let pinsButton = UIButton.init(type: .system)
        initPinButton(pinsButton)
        pinsButton.addTarget(self, action: #selector(pressPins(button:)), for: .touchDown)
        
        initPins()//pins are initalized
        
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
        
        print("MapViewController did load")
    }
    
    /* This function initalizes a button that will allow the user to zoom into their current location. 
     * The form of the button and constriants are set in this function.
     */
    func initLocButton(_ button: UIButton)
    {
        button.setTitle("My Location", for: .normal)
        button.frame.size.height = 25
        button.frame.size.width = 140
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        //Adding constriants to button
        let bottomConst = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        let leadConst = button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        let HConst = button.heightAnchor.constraint(equalToConstant: 25)
        let WConst = button.widthAnchor.constraint(equalToConstant: 120)
        HConst.isActive = true
        WConst.isActive = true
        bottomConst.isActive = true
        leadConst.isActive = true
    }
    
    /* This function initalizes a button that will allow the user to display pins when selected. The form of the
     * button and constriants are set in this function.
     */
    func initPinButton(_ button: UIButton)
    {
        button.setTitle("Pins", for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        
        //Adding constriants to button
        let bottomConst = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        let leadConst = button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let HConst = button.heightAnchor.constraint(equalToConstant: 25)
        let WConst = button.widthAnchor.constraint(equalToConstant: 120)
        HConst.isActive = true
        WConst.isActive = true
        bottomConst.isActive = true
        leadConst.isActive = true
        
    }
    
    /* This function initalizes the pins that will be displayed in the mapView once the Pins Button is 
     * selected by the user. The pins are stored into an array named pins.
     */
    func initPins(){
        annotation1.coordinate = CLLocationCoordinate2DMake(35.973128, -79.994954)
        annotation1.title = "High Point University"
        pins.append(annotation1)
        print(pins[0].title!)
        
        annotation2.coordinate = CLLocationCoordinate2DMake(17.058969, -96.727495)
        annotation2.title = "Oaxaca, Mexico"
        pins.append(annotation2)
         print(pins[1].title!)
        
        annotation3.coordinate = CLLocationCoordinate2DMake(28.385261, -81.563498)
        annotation3.title = "Disney World"
        pins.append(annotation3)
        print(pins[2].title!)
    }
    
    
    /* This function will tell the delegate that the location of the user was updated. The map will zoom
     * into the user's current location.
     */
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let Cspan:MKCoordinateSpan = MKCoordinateSpanMake(0.01,0.01)//sets zoom level
        let region:MKCoordinateRegion = MKCoordinateRegionMake(userLocation.coordinate, Cspan)
        mapView.setRegion(region, animated: true)
        print("test2")
    }

    /* This function is used to tell the delegate that the map view stopped tracking the user's location.
     * the map will return to the previous location that the user was found in before selecting their current
     * location.
     */
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        let span:MKCoordinateSpan = MKCoordinateSpanMake(CurSpan.latitudeDelta,CurSpan.longitudeDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(curLoc, span)
        mapView.setRegion(region, animated: true)
    }
    
    
    /* This function captures the current location of a user whenever its button is selected. The
     * showUserLocation property of the mapView is turned on and off depending on how many times the user
     * selects the button.
     */
    func pressLocation(button: UIButton){
        mapView.removeAnnotations(pins)//removes any pins from map
        
        /* Checks if current location button was not enabled to capture most recent location and if
         * any pins were being traversed through. This will only capture location if these two conditions
         * did not occur.
         */
        if mapView.showsUserLocation == false && isPinUsed == false {
            curLoc = mapView.centerCoordinate//captures current coordinates
            CurSpan = mapView.region.span//captures current zoom level
            print(curLoc)
        }

        
        if mapView.showsUserLocation == true && isPinUsed == false{
            mapView.showsUserLocation = false
        }
        else{
            isPinUsed = false
            mapView.showsUserLocation = true
        }
        
        print("Pressed")
    }
    
    /* This function will display a series of pins onto the map view depending on the number of times the 
     * button is selected. Only one pin is added onto the map view at a time and is removed as soon as the
     * next pin is displayed. After being pressed three consecutive times, the view returns to the default
     * location or the last location the user was in before selecting the pin button.
     */
    func pressPins(button: UIButton){
        if pinCount == 0 && mapView.showsUserLocation == false{
            curLoc = mapView.centerCoordinate
            CurSpan = mapView.region.span
           print(curLoc)
        }
        
        //current location is turned off if it was being used to allow user to return to their current location
        //if they had previously selected the my location button
        mapView.showsUserLocation = false
        let span = MKCoordinateSpanMake(0.5, 0.5)
        var region: MKCoordinateRegion
        
        //goes through each pin
        if pinCount == 0{
            isPinUsed = true
            mapView.addAnnotation(pins[0])
            region = MKCoordinateRegion(center: pins[0].coordinate, span: span)
            mapView.setRegion(region, animated: true)
            pinCount += 1
            print("1")
        }
        else if pinCount == 1{
            isPinUsed = true
            mapView.removeAnnotations(pins)
            mapView.addAnnotation(pins[1])
            region = MKCoordinateRegion(center: pins[1].coordinate, span: span)
            mapView.setRegion(region, animated: true)
            pinCount += 1
            print("2")
        }
        else if pinCount == 2 {
            isPinUsed = true
            mapView.removeAnnotations(pins)
            mapView.addAnnotation(pins[2])
            region = MKCoordinateRegion(center: pins[2].coordinate, span: span)
            mapView.setRegion(region, animated: true)
            pinCount += 1
            print("3")
        }
        else{ //returns to default location
            isPinUsed = false
            pinCount = 0//reset to beginning of pins
            mapView.removeAnnotations(pins)//remove any pins in view
            let span:MKCoordinateSpan = MKCoordinateSpanMake(CurSpan.latitudeDelta,CurSpan.longitudeDelta)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(curLoc, span)//back to default location
            mapView.setRegion(region, animated: true)
        }
    }
    
}
