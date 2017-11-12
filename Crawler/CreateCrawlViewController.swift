//
//  CreateCrawlViewController.swift
//  Crawler
//
//  Created by Jack Chorley on 11/11/2017.
//  Copyright © 2017 Jack Chorley. All rights reserved.
//

import UIKit
import CoreLocation

class CreateCrawlViewController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var startLocButton: UIButton!
    @IBOutlet weak var destLocButton: UIButton!
    @IBOutlet weak var sliderHolder: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var pubsLabel: UILabel!
    
    @IBOutlet weak var startLocationButtonLabel: UILabel!
    @IBOutlet weak var destinationButtonLabel: UILabel!
    
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var goButtonStretcher: UIView!
    
    var pubCount = 5
    
    var startLoc: CLLocationCoordinate2D!
    var destinationLoc: CLLocationCoordinate2D!
    
    var pickingFirstLocation = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disableButton()
        
        headerView.layer.shadowPath = CGPath(roundedRect: headerView.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        headerView.clipsToBounds = false
        headerView.layer.shadowColor = shadowColor.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        headerView.layer.shadowRadius = 10
        headerView.layer.shadowOpacity = 1
        
        
        startLocButton.layer.shadowPath = CGPath(roundedRect: startLocButton.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        startLocButton.clipsToBounds = false
        startLocButton.layer.shadowColor = shadowColorLight.cgColor
        startLocButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        startLocButton.layer.shadowRadius = 10
        startLocButton.layer.shadowOpacity = 1
        
        
        destLocButton.layer.shadowPath = CGPath(roundedRect: destLocButton.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        destLocButton.clipsToBounds = false
        destLocButton.layer.shadowColor = shadowColorLight.cgColor
        destLocButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        destLocButton.layer.shadowRadius = 10
        destLocButton.layer.shadowOpacity = 1
        
        sliderHolder.layer.shadowPath = CGPath(roundedRect: sliderHolder.bounds, cornerWidth: 0, cornerHeight: 0, transform: nil)
        sliderHolder.clipsToBounds = false
        sliderHolder.layer.shadowColor = shadowColorLight.cgColor
        sliderHolder.layer.shadowOffset = CGSize(width: 0, height: 3)
        sliderHolder.layer.shadowRadius = 10
        sliderHolder.layer.shadowOpacity = 1
        
        slider.setThumbImage(#imageLiteral(resourceName: "ThumbImage"), for: .normal)
        slider.setThumbImage(#imageLiteral(resourceName: "ThumbImage"), for: .highlighted)
        slider.setThumbImage(#imageLiteral(resourceName: "ThumbImage"), for: .focused)
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let val = Int(slider.value)
        
        if pubCount != val {
            pubCount = val
            pubsLabel.text = slider.value == slider.maximumValue ? "Max Pubs: Too many!" : "Max Pubs: \(pubCount)"
        }
        pubCount = Int(slider.value)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startLocationButtonPressed(_ sender: Any) {
        
        pickingFirstLocation = true
        
        self.performSegue(withIdentifier: "presentLocationPicker", sender: nil)
    }
    
    @IBAction func destinationButtonPressed(_ sender: Any) {
        pickingFirstLocation = false
        self.performSegue(withIdentifier: "presentLocationPicker", sender: nil)
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentLocationPicker" {
            let dest = segue.destination as! LocationPickerViewController
            dest.transitioningDelegate = self
        }
    }
    
    @IBAction func prepareForUnwind(_ segue: UIStoryboardSegue) {
        
        let source = segue.source as! LocationPickerViewController
        
        print(String(format: "a float number: %.5f", 1.0321))
        
        let locationString = String(format: "%.5f, %.5f", source.returnCoordinate.latitude, source.returnCoordinate.longitude)
        
        if pickingFirstLocation {
            
            startLoc = source.returnCoordinate
            startLocationButtonLabel.text = locationString
            
            startLocationButtonLabel.textColor = UIColor.colorWithHsb(201, s: 59, b: 15)
            
        } else {
            
            
            destinationLoc = source.returnCoordinate
            destinationButtonLabel.text = locationString
            
            destinationButtonLabel.textColor = UIColor.colorWithHsb(201, s: 59, b: 15)
        }
        
        if startLoc != nil && destinationLoc != nil {
            enableButton()
        } else {
            disableButton()
        }
    }
    
    func disableButton() {
        goButton.isEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.goButton.backgroundColor = UIColor.colorWithHsb(120, s: 0, b: 89)
            self.goButtonStretcher.backgroundColor = UIColor.colorWithHsb(120, s: 0, b: 89)
        }
    }
    
    func enableButton() {
        goButton.isEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.goButton.backgroundColor = UIColor.colorWithHsb(323, s: 72, b: 44)
            self.goButtonStretcher.backgroundColor = UIColor.colorWithHsb(323, s: 72, b: 44)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension CreateCrawlViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pageDismisser
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pageAnimator
    }
}
