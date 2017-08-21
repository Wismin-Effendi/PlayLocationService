//
//  ViewController.swift
//  PlayLocationService
//
//  Created by Wismin Effendi on 8/19/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import os.log

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchText: UITextField!

    
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    let locationManager = CLLocationManager()
    let localSearchCompleter = MKLocalSearchCompleter()
    
    var currentLocationCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.showsUserLocation = true
        mapView.delegate = self
        setUpLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func textFieldReturn(_ sender: UITextField) {
        _ = sender.resignFirstResponder()
        mapView.removeAnnotations(mapView.annotations)
        self.performSearch()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    private func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 500
        locationManager.requestLocation()
    }
    
    fileprivate func setupLocalSearchCompleter(region: MKCoordinateRegion) {
        localSearchCompleter.delegate = self
        localSearchCompleter.region = region
        localSearchCompleter.filterType = .locationsAndQueries
    }
}

// MARK: - Search TextField
extension ViewController {
    
    func performSearch() {
        
        matchingItems.removeAll()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, error) in
            
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                
                for item in response!.mapItems {
                    print("Name = \(item.name)")
                    print("Phone = \(item.phoneNumber)")
                    print("Address = \(item.placemark)")
                    
                    self.matchingItems.append(item as MKMapItem)
                    print("Matching items = \(self.matchingItems.count)")
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.placemark.title
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
        
    }
}

// MARK: - MKMapViewDelegate 
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if annotation.title! == "My Location" {
                view.pinTintColor = MKPinAnnotationView.greenPinColor()
            }
            view.canShowCallout = true
            view.animatesDrop = true
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation!.coordinate
        showOptionToChoose(location: location)
    }
    
    func showOptionToChoose(location: CLLocationCoordinate2D) {
        let alertController = UIAlertController(title: "Choose Location", message: "Choose this location?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("We have selected this location: \(location)")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}


// MARK: - LocationManager Delegate 
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        os_log("Error getting user location: %s", error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            fatalError("We should have one location but we didn't have one")
        }
        let locationCoordinate = location.coordinate
        currentLocationCoordinate = locationCoordinate
        print("Current location: ", locationCoordinate.latitude, locationCoordinate.longitude)
        let region = makeRegion(center: locationCoordinate)
        setupLocalSearchCompleter(region: region)
        mapView.region = region
        localSearchCompleter.queryFragment = "sams"
        
    }
    
    // MARK: - Local Search helper
    private func makeRegion(center: CLLocationCoordinate2D, milesRadius: Int = 20) -> MKCoordinateRegion {
        let delta:Double = 2.0 * Double(milesRadius)/69.0 * 0.1
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: center, span: span)
        return region
    }
    
    private func localSearch(region: MKCoordinateRegion) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "sam's club"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response: MKLocalSearchResponse?, error:Error?) in
            //
        }
    }
}


// MARK: - MKLocalSearchCompleterDelegate 
extension ViewController: MKLocalSearchCompleterDelegate {
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        os_log("Error getting search completer result: %s", error.localizedDescription)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        print("Completer result: ")
        for result in results {
            print("\(result.title)")
            print("\(result.subtitle)")
            print("---------")
        }
        
    }
}
