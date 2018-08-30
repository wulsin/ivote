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
    
    //MARK: Variables & Constants
    @IBOutlet var aboutLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //#LOCALIZE
        let attributedString = NSMutableAttributedString(string: "The mission of iVote is to use technology to simplify the voting process. iVote is the first digital assistant to lead voters through each step of the voting process, from registering to requesting a mail-in ballot to submitting it on time. iVote is non-partisan and does not support any political party or candidate. If you would like more information please contact the developers at info@iVote.tech", attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 20.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        attributedString.addAttribute(.font, value: UIFont(name: "MuseoSansRounded-900", size: 20.0)!, range: NSRange(location: 15, length: 5))
        attributedString.addAttributes([
            .font: UIFont(name: "MuseoSansRounded-900", size: 20.0)!,
            .foregroundColor: UIColor(red: 13.0 / 255.0, green: 95.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: attributedString.length-15, length: 15))
        
        aboutLabel.attributedText = attributedString
        
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
