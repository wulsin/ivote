//
//  Home.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit
import Intents

class HomeVC: UIViewController {
    
    //MARK: Variables & Constants
    /** Current User Object */
    var user : User?
    
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
    
    /** Button to share app. */
    @IBOutlet var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Retrieve user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = appDelegate.user
        
        //Request Siri Access
        INPreferences.requestSiriAuthorization { status in
            if status == .authorized {
                print("Hey, Siri!")
            } else {
                print("Nay, Siri!")
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView()
    }
    
    func updateView() {
        
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
        
        //Completed
        let completeGreen = UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
        let completedText = "Completed"
        let completedString = NSMutableAttributedString(string: completedText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: completeGreen
            ])
        
        //Registration
        let registrationText = "Deadline: " + ElectionResourcesVC.registrationDeadline(state: (user?.state)!) + ", 2018"
        let registrationString = NSMutableAttributedString(string: registrationText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        registrationString.addAttributes([
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 9))
        
        //Mail-in Ballot
        let mailInBallotText = "Deadline: " + ElectionResourcesVC.mailInBallotDeadline(state: (user?.state)!) + ", 2018"
        let mailInBallotString = NSMutableAttributedString(string: mailInBallotText, attributes: [
            .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
            .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
            ])
        mailInBallotString.addAttributes([
            .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
            .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
            ], range: NSRange(location: 0, length: 9))
        
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
        
        //Update Buttons/Labels based on status:
        if user!.isRegistered {
            registrationLabel.attributedText = completedString
            registrationButton.backgroundColor = completeGreen
        }else {
            registrationLabel.attributedText = registrationString
            registrationButton.backgroundColor = UIColor(white: 112.0 / 255.0, alpha: 1.0)
        }
        
        if user!.isMailInBallotRequested || user!.willVoteInPerson {
            mailInBallotLabel.attributedText = completedString
            mailInBallotButton.backgroundColor = completeGreen
        }else {
            mailInBallotLabel.attributedText = mailInBallotString
            mailInBallotButton.backgroundColor = UIColor(white: 112.0 / 255.0, alpha: 1.0)
        }
        
        if user!.isBallotSubmitted {
            submitBallotLabel.attributedText = completedString
            submitBallotButton.backgroundColor = completeGreen
        }else {
            submitBallotLabel.attributedText = submitBallotString
            submitBallotButton.backgroundColor = UIColor(white: 112.0 / 255.0, alpha: 1.0)
        }
        
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let actionVC = segue.destination as? ActionVC {
            
            if let button = sender as? UIButton {
                actionVC.actionType = ActionType(rawValue: button.tag)!
            }
        }
        
        return
    }
}
