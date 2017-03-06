//
//  FireballLocationVC.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import MapKit

/// Displays the location of atmospheric impact of a fireball on a Map
class FireballLocationVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var meteorImageView: UIImageView!
    @IBOutlet weak var replayBarButtonItem: UIBarButtonItem!
    
    var fireball: FireballMO?
    var meteorAnimating: Bool = false {
        didSet {
            replayBarButtonItem.isEnabled = !meteorAnimating
        }
    }
    var initialMapLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meteorAnimating = false
        configureMapView()
        meteorImageView.removeFromSuperview()
    }
    
    private func configureMapView() {
        if let fireball = fireball {
            mapView.region = MKCoordinateRegionForMapRect(MKMapRectWorld)
            mapView.centerCoordinate = fireball.coordinate
            
            let point = MKPointAnnotation()
            point.coordinate = fireball.coordinate
            mapView.addAnnotation(point)
            mapView.delegate = self
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "Fireball")
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Fireball")
        }
        view?.annotation = annotation
        return view
    }
    
    /// Automatically launches the meteor animation on first load
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        guard !initialMapLoad else {
            return
        }
        initialMapLoad = true
        launchMeteor()
    }
    
    /// Animation that launches meteor from top right location to the center
    @IBAction func launchMeteor() {
        guard !meteorAnimating else {
            return
        }
        guard let fireball = self.fireball else {
            return
        }
        
        mapView.isScrollEnabled = false
        meteorAnimating = true
        meteorImageView.alpha = 1.0
        meteorImageView.transform = CGAffineTransform.identity
        meteorImageView.center = CGPoint(x: CGFloat(view.bounds.width), y: 0)
        mapView.addSubview(meteorImageView)
        
        UIView.animate(withDuration: 2.0, animations: {
            let scale: CGFloat = 0.25
            self.meteorImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.meteorImageView.center = self.mapView.bounds.localCenter
            self.meteorImageView.alpha = 0.0
            self.mapView.centerCoordinate = fireball.coordinate
    
        }, completion: { (completed) in
            self.meteorImageView.removeFromSuperview()
            self.meteorAnimating = false
            self.mapView.isScrollEnabled = true
        })
    }
}
