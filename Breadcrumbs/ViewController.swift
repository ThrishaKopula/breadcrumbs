//
//  ViewController.swift
//  Breadcrumbs
//
//  Created by Thrisha Kopula on 8/13/21.
//

import UIKit
import InstantSearchVoiceOverlay
import MapKit
import CoreLocation
import MediaPlayer
import AVKit
import AVFoundation



class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var player: AVPlayer?
    
    
    @IBAction func Mic(_ sender: UIButton) {
        voiceOverlay.start(on: self, textHandler: {text, final, _ in
            
            if (text == "Crumb" || text == "Place pin" || text == "Pin" || text == "Place crumb" || text == "Drop crumb") {
                guard let locValue: CLLocationCoordinate2D = self.manager.location?.coordinate else { return }
                print("locations = \(locValue.latitude) \(locValue.longitude)")
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
                self.mapView.addAnnotation(annotation)
            }
            if final {
                print("Final text: \(text)")
            } else {
                print("In progress: \(text)")
            }
            
        }, errorHandler: {error in})
    }
    @IBAction func crumb(_ sender: UIButton) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        mapView.addAnnotation(annotation)
    }
    
    
    
    @IBOutlet weak var mapView: MKMapView!
        
    let manager = CLLocationManager()
    let voiceOverlay = VoiceOverlayController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadVideo()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
        
        
        
        
        
        //PIN THIS PINS
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        mapView.addAnnotation(annotation)
        
        
        
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
            mapView.addAnnotation(annotation)
            
            let location = locations.last! as CLLocation

            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            //set region on the map
            mapView.setRegion(region, animated: true)
            //let newPin = MKPointAnnotation()
            //newPin.coordinate = location.coordinate
            //mapView.addAnnotation(newPin)
            
        }
        
        mapView.showsUserLocation = true
        mapView.showsCompass = false  // Hide built-in compass
        var compassButton = MKCompassButton(mapView: mapView)
        compassButton = MKCompassButton(mapView: mapView)   // Make a new compass
        compassButton.compassVisibility = .visible          // Make it visible

        mapView.addSubview(compassButton) // Add it to the view
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView)
        {
            mapView.setUserTrackingMode(.followWithHeading, animated: true)
        }
        // Position it as required

        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12).isActive = true
        //let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        //mapView.setRegion(region, animated: true)
        
    }

        
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        if let location = locations.first{
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    
    func render(_ location:CLLocation) {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    private func loadVideo() {

            //this line is important to prevent background music stop
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            } catch { }

            let path = Bundle.main.path(forResource: "movie", ofType:"mp4")

            let filePathURL = NSURL.fileURL(withPath: path!)
            let player = AVPlayer(url: filePathURL)
            let playerLayer = AVPlayerLayer(player: player)

            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            playerLayer.zPosition = -1

            self.view.layer.addSublayer(playerLayer)

            player.seek(to: CMTime.zero)
            player.play()
        }

}

