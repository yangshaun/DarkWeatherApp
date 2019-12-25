//
//  SpinnerView.swift
//  App
//
//  Created by Shaun Yang on 11/16/19.
//  Copyright © 2019 Shaun Yang. All rights reserved.
//

import UIKit
import SwiftSpinner
class SpinnerView: UIViewController {

    @IBOutlet var labelContainerView: UIView!
    var progress = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelContainerView.transform = CGAffineTransform(translationX: 0, y: 200)
    }
    
    func delay(seconds: Double, completion: @escaping () -> ()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.demoSpinner()
    }
    
    func demoSpinner() {
        UIView.animate(withDuration: 0.5) {
            self.labelContainerView.transform = .identity
        }
        
        SwiftSpinner.show(delay: 0.5, title: "Shouldn't see this one", animated: true)
        SwiftSpinner.hide()
        
        SwiftSpinner.show(delay: 1.0, title: "Connecting...", animated: true)
        
//        delay(seconds: 2.0, completion: {
//            SwiftSpinner.show("Connecting \nto satellite...").addTapHandler({
//                print("tapped")
//                SwiftSpinner.hide()
//            }, subtitle: "Tap to hide while connecting! This will affect only the current operation.")
//        })
  
        delay(seconds: 2.0, completion: {
            self.performSegue(withIdentifier:"SpinToMainPage", sender: self)
            self.delay(seconds: 2.0,completion: {
                SwiftSpinner.hide()
            })
            
        })
        
    }
    
    @objc func timerFire(_ timer: Timer) {
        progress += (timer.timeInterval/5)
        SwiftSpinner.show(progress: progress, title: "Downloading: \(Int(progress * 100))% completed")
        if progress >= 1 {
            progress = 0
            timer.invalidate()
            SwiftSpinner.show(duration: 2.0, title: "Complete!", animated: false)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
