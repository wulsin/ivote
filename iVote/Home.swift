//
//  Home.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit


class HomeVC: UIViewController {
    
    //MARK: Variables & Constants
    
    /** Label indicating election date. */
    @IBOutlet var electionDateLabel: UILabel!
    
    /** Label indicating how easy voting is. */
    @IBOutlet var votingLabel: UILabel!
    
    /** Label indicating registration status. */
    @IBOutlet var registrationLabel: UILabel!
    
    /** Button indicating registration status. */
    @IBOutlet var registrationButton: UIButton!
    
    /** Label indicating mail-in-ballot status. */
    @IBOutlet var mailInBallotLabel: UILabel!
    
    /** Button indicating mail-in-ballot status. */
    @IBOutlet var mailInBallotButton: UIButton!
    
    /** Label indicating submit ballot status. */
    @IBOutlet var submitBallotLabel: UILabel!
    
    /** Button indicating submit ballot status. */
    @IBOutlet var submitBallotButton: UIButton!
    
    /** Button indicating facebook status. */
    @IBOutlet var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Configure Labels & Button Titles
        
        //Election Date
        let electionDateString = NSMutableAttributedString(string: "Next Election:\nNovember 6, 2018", attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        electionDateString.addAttribute(.font, value: UIFont(name: "MuseoSansRounded-500", size: 20.0)!, range: NSRange(location: 0, length: 15))
        electionDateLabel.attributedText = electionDateString
        
        //Voting
        let votingString = NSMutableAttributedString(string: "Voting is as simple as…", attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 20.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        votingString.addAttribute(.font, value: UIFont(name: "MuseoSansRounded-900", size: 20.0)!, range: NSRange(location: 0, length: 6))
        votingLabel.attributedText = votingString
        
        //Registration
        let registrationText = "Completed"
        let registrationString = NSMutableAttributedString(string: registrationText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
            ])
        registrationLabel.attributedText = registrationString
        
        //Mail-in Ballot
        let mailInBallotText = "Deadline: October 23, 2018"
        let mailInBallotString = NSMutableAttributedString(string: mailInBallotText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        mailInBallotString.addAttributes([
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 9))
        mailInBallotLabel.attributedText = mailInBallotString
        
        //Submit Ballot
        let submitBallotText = "Deadline: November 6, 2018"
        let submitBallotString = NSMutableAttributedString(string: submitBallotText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        submitBallotString.addAttributes([
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 9))
        submitBallotLabel.attributedText = submitBallotString
        
        //Share Facebook Label
        let facebookString = NSMutableAttributedString(string: "Share to Facebook", attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 20.0)!,
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ])
        facebookString.addAttribute(.font, value: UIFont(name: "MuseoSansRounded-900", size: 20.0)!, range: NSRange(location: 9, length: 8))
        facebookButton.setAttributedTitle(facebookString, for: .normal)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** User pressed Registration Button */
    @IBAction func registerAction() {
        
    }
    
    /** User pressed Mail In Ballot Button */
    @IBAction func mailInBallotAction() {
        
    }
    
    /** User pressed Submit Ballot Button */
    @IBAction func submitBallotAction() {
        
    }
    
    /** User pressed Share Button */
    @IBAction func shareAction() {
        
    }
    
}
