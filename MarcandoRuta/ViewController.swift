//
//  ViewController.swift
//  MarcandoRuta
//
//  Created by Erick Rodríguez Ramos on 15/09/16.
//  Copyright © 2016 Erick Rodríguez Ramos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    let manejador = CLLocationManager()
    var distanciaRecorrida: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manejador.delegate = self
        manejador.desiredAccuracy=kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        manejador.distanceFilter = 50.0
        mapa.isZoomEnabled = true
mapa.setCenter(CLLocationCoordinate2D(latitude: manejador.location!.coordinate.latitude, longitude: manejador.location!.coordinate.longitude), animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manejador.startUpdatingLocation()
            mapa.showsUserLocation=true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation=false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = manejador.location!.coordinate.latitude
        punto.longitude = manejador.location!.coordinate.longitude
        distanciaRecorrida += 50.0
     let pin = MKPointAnnotation()
        print(locations[0])
        print(manejador.location?.coordinate)
     pin.title="(\(manejador.location!.coordinate.latitude), \(manejador.location!.coordinate.longitude))"
     pin.subtitle="\(distanciaRecorrida) metros"
     pin.coordinate = punto
       mapa.addAnnotation(pin)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alerta = UIAlertController(title: "ERROR", message: "error \(error)", preferredStyle: .alert)
        let accionOK = UIAlertAction(title: "OK", style: .default, handler: {accion in
            //..
        })
        alerta.addAction(accionOK)
        self.present(alerta, animated: true, completion: nil)
    }


    @IBAction func muestraTipo(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
        self.mapa.mapType = MKMapType.standard;
        break;
        case 1:
        self.mapa.mapType = MKMapType.satellite;
        break;
        case 2:
        self.mapa.mapType = MKMapType.hybrid;
        break;
        default:
        break;
        }
    }
   
    @IBAction func zoomIt(_ sender: AnyObject) {
        let userLocation = mapa.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance(
            userLocation.location!.coordinate, 200, 200)
        mapa.setRegion(region, animated: true)
    }
}

