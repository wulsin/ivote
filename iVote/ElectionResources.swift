//
//  ElectionResources.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class ElectionResourcesVC: UIViewController {
    
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
    
    /** Open Election Resource based on Button Tag. */
    @IBAction func openResource(sender: UIButton) {
       
        var url = ""
        switch sender.tag{
        case 0:
            url = "http://www.sos.ca.gov/elections/prior-elections/statewide-election-results/statewide-direct-primary-june-5-2018/2018-california-election-guide/"
        case 1:
            url = "https://ballotpedia.org/"
        case 2:
            url = "https://www.lwv.org/"
        default:
            break
        }
        
        if url != "" {
            let svc = SFSafariViewController(url: URL(string: url)!)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    /** Share App on Facebook */
    @IBAction func shareFacebook() {
        
    }
    
    
}
