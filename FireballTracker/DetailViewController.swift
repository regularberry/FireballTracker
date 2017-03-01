//
//  DetailViewController.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var fireball: FireballMO?

    func configureView() {
        if let fireball = fireball {
            mapView.region = MKCoordinateRegionForMapRect(MKMapRectWorld)
            mapView.centerCoordinate = fireball.coordinate
            let point = MKPointAnnotation()
            point.coordinate = fireball.coordinate
            mapView.addAnnotation(point)
            mapView.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Fireball")
        
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Fireball")
        }
        view?.annotation = annotation
        return view
    }
}

