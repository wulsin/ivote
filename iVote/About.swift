//
//  About.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit

class AboutVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Dismiss View Controller */
    @IBAction func dismissVC() {
        self.dismiss(animated: true) {}
    }
    
}
