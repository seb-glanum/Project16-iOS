//
//  ViewController.swift
//  Project16
//
//  Created by Sebastien Carreno on 05/10/2021.
//

import UIKit
import MapKit

class CustomButton : UIButton {
    var value: String?
}

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let london = Capital(title: "Londres", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Welcome to London !")
        
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Welcome to Oslo !")
        
        let glanum =  Capital(title: "Avignon", coordinate: CLLocationCoordinate2D(latitude: 43.943354, longitude: 4.797313), info: "Welcome to Glanum !")
        
        mapView.addAnnotations([london, oslo, glanum])
        
        let ac = UIAlertController(title: "Quel type de map souhaitez-vous ??", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Normal", style: .default, handler: setMapStyle))
        ac.addAction(UIAlertAction(title: "Satelite", style: .default, handler: setMapStyle))
        
        present(ac, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            let annotationPin = annotationView as? MKPinAnnotationView
            annotationPin?.pinTintColor = UIColor.blue
            annotationPin?.canShowCallout = true
            
            let btn = CustomButton(type: .detailDisclosure)
            btn.value = annotation.title!
            btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            annotationPin?.rightCalloutAccessoryView = btn
            return annotationPin
        }
        else {
            annotationView?.annotation = annotation
            let annotationPin = annotationView as? MKPinAnnotationView
            annotationPin?.pinTintColor = UIColor.blue
            return annotationPin
        }
    
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
        
        present(ac, animated: true)
        
    }
    
    func setMapStyle(action: UIAlertAction) {
        guard mapView != nil else { return }
        
        if(action.title == "Satelite") {
            mapView.mapType = .satellite
        }
    
    }
    
    @objc func buttonTapped(sender: CustomButton){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.city = sender.value
                    navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

