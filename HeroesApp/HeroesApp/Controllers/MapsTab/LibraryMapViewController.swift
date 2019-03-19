//
//  LibraryMapViewController.swift
//  HeroesApp
//
//  Created by Andres Leonardo Martinez on 15/03/2019.
//  Copyright © 2019 Andres Leonardo Martinez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LibraryMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let geocoder: CLGeocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMap()
        self.requestLocationAccess()
        self.configureLocation()
        self.configureMap()
        //locationManager.delegate = self   //not necessary
        
    }
    func requestLocationAccess(){
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
        case .denied, .restricted:
            print ("not authorization")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func configureLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            //  locationManager.startUpdatingLocation()
        }
    }
    
    func configureMap(){
        self.mapView.showsUserLocation = true;
        
        
        let places = [("Trilogy Games",-38.7143687,-62.2676689),
                      ("Tienda Arcoiris",-38.7182771,-62.261953),
                      ("Don Bosco", -38.7191509,-62.269599),
                      ("Don Quijote", -38.7222883,-62.2646183)]
        for place in places {
            let anotation = LibraryAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.1, longitude: place.2), title: place.0, subtitle: place.0)
            mapView.addAnnotation(anotation)
        }
        
        
    }
    
    func initMap(){
        let regionRadius: CLLocationDistance = 1000
        let initialLocation = CLLocation(latitude: -38.7196993, longitude: -62.2672425)
        
        centerMapOnLocation(location: initialLocation, regionRadius: regionRadius)
    }
    
    
    private func centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}


extension LibraryMapViewController : MKMapViewDelegate{
    /*
     Show annotations reusing them
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? LibraryAnnotation else { return nil }
        
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker")
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
        
        
    }
    /*
     Function whe the notification appears:
     Show a notification with the name of the place and the address (if was able to find it)
     If the callout accesory is pressed then
     Open the Apple Maps and show how to go to the place
     */
    
    func mapView(_ mapView: MKMapView, annotationView view:
        MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let cordinates = view.annotation?.coordinate else {return}
        //try to find the address with reverseGeocode
        geocoder.reverseGeocodeLocation(CLLocation(latitude: cordinates.latitude, longitude:
            cordinates.longitude), completionHandler: { (placemarks, error) in
                guard error == nil else {print (error); return}
                guard let thePlaceMark = placemarks?.first else {return}
                let street = thePlaceMark.thoroughfare
                let streetNumber = thePlaceMark.subThoroughfare
                var address : String?
                if street != nil{
                    address = street!
                    if streetNumber != nil {
                        address = address! + " " + streetNumber!
                    }
                }
                let alertController = UIAlertController(title: view.annotation?.title!, message: address  ?? "No address detected", preferredStyle:
                    .alert)
                alertController.addAction(UIAlertAction(title: "Go", style: UIAlertAction.Style.default){(UIAlertAction) in
                    //go to place with apple maps
                    let placeMarker = MKPlacemark(coordinate: cordinates)
                    let mapItem = MKMapItem(placemark: placeMarker)
                    mapItem.name = thePlaceMark.name
                    mapItem.openInMaps()
                    
                })
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
        })
    }
}

