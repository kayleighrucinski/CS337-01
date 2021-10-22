//
//  MapsViewController.swift
//  NJSchoolsMap123
//
//  Created by Kayleigh F. Rucinski on 10/21/21.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var schoolsMap: MKMapView!
    
    let schoolModel = NJSchoolsModel.sharedInstance
    var schoolAnnotatations:[SchoolAnnotation] = []
    let region = 60000.00
    let locationManager = CLLocationManager()
    var selectedSchoolID: Int?
    @IBOutlet weak var mapTypeSelection: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolsMap.delegate = self
        centerMapToNJ()
        addMULocation()
        showSchoolsOnMap()
        locationManager.requestWhenInUseAuthorization()
    }
    override func viewDidAppear(_ animated: Bool) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.stopUpdatingLocation()
        }
    }
    func centerMapToNJ () {
        let centerNJ = CLLocation(latitude: 40.2798587939248, longitude: -74.50477927051948)
        let centerOfNJ2D = CLLocationCoordinate2D(latitude: centerNJ.coordinate.latitude, longitude: centerNJ.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: centerOfNJ2D, latitudinalMeters: region, longitudinalMeters: region)
        schoolsMap.setRegion(coordinateRegion, animated: true)
    }
    func addMULocation () {
        let annotation = MUPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.2798587939248, longitude: -74.00477927051948)
        annotation.title = "MU"
        annotation.subtitle = "Go Hawks!!"
        schoolsMap.addAnnotation(annotation)
    }
    func showSchoolsOnMap() {
        for school in schoolModel.njSchools{
            let annotation = SchoolAnnotation(latitude: school.geometry.coordinates[1], longitude: school.geometry.coordinates[0], title: school.properties.name, subTitle: school.properties.address!, schoolID: school.properties.objectId)
                schoolAnnotatations.append(annotation)
        }
            schoolsMap.addAnnotations(schoolAnnotatations)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard (annotation is SchoolAnnotation || annotation is MUPointAnnotation) else {return nil}
        var annotationView = MKMarkerAnnotationView()
        let identifier = "School"
        if annotation is SchoolAnnotation {
            if let dequeuedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                annotationView = dequeuedAnnotation
            }
            else {
                annotationView.glyphImage = UIImage(systemName: "leaf")
                annotationView.glyphTintColor = .blue
                annotationView.canShowCallout = true
                
                let schoolImageView = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 50.0)))
                schoolImageView.setBackgroundImage(UIImage(named: "school image"), for: UIControl.State())
                annotationView.leftCalloutAccessoryView = schoolImageView
            }
            return annotationView
        }
        else {
            let annotationView = MKPinAnnotationView()
            annotationView.pinTintColor = UIColor.blue
            annotationView.image = UIImage(systemName: "building.columns.fill")
            annotationView.canShowCallout = true
            let muImageView = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 50.0)))
            muImageView.setBackgroundImage(UIImage(named: "mu"), for: UIControl.State())
            annotationView.leftCalloutAccessoryView = muImageView
            return annotationView
        }
    } //end map view
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0]
        print (newLocation)
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.leftCalloutAccessoryView == control {
            if view.annotation  is SchoolAnnotation {
                let selectedSchoolAnnotation = view.annotation as! SchoolAnnotation
                selectedSchoolID = selectedSchoolAnnotation.schoolID
                performSegue(withIdentifier: "schoolSegue", sender: self)
            } else {
                performSegue(withIdentifier: "detailSegue", sender: self)
            }
        }
    }
    /*
    // Step 22 - for parkSegue, set the parkID in DestinationVC

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "schoolSegue" {
            let dvc = segue.destination as! NJSchoolsModel
            dvc.School.properties.objectId = selectedSchoolID!
        }
    }
     */
    @IBAction func selectMapType(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            schoolsMap.mapType = .standard
        case 1:
            schoolsMap.mapType = .satellite
        case 2:
            schoolsMap.mapType = .hybridFlyover
        default:
            schoolsMap.mapType = .standard
        }
    }
}

