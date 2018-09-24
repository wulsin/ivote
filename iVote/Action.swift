//
//  Action.swift
//  iVote
//
//  Created by BFar on 8/8/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit
import MagicalRecord
import WebKit
import SafariServices //#CLEANUP

/**  Enum for Action states. */
enum ActionType: Int {
    case registration  //Register to vote
    case mailInBallot    //Request Mail-In Ballot
    case submitBallot    //Submit Ballot
    case registrationCheck
}

class ActionVC: UIViewController {
    //MARK: Variables & Constants
    /** Current User Object */
    var user : User?
    
    var actionType: ActionType = .registration
    
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var headerImg: UIImageView!
    @IBOutlet var headerStatus: UILabel!
    @IBOutlet var actionBut: UIButton!
    @IBOutlet var actionLabel: UILabel!
    @IBOutlet var checkStatusBut: UIButton!
    @IBOutlet var checkStatusLabel: UILabel!
    @IBOutlet var changeStatusBut: UIButton!
    @IBOutlet var changeStatusLabel: UILabel!
    
    @IBOutlet var checkStatusTopSpace: NSLayoutConstraint!
    @IBOutlet var changeStatusTopSpace: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Retrieve user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = appDelegate.user
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Dismiss View Controller */
    @IBAction func dismissVC() {
        self.dismiss(animated: true) {}
    }
    
    //MARK: View Updates & Management
    /** Configure the view to reflect the current Action Type and status of that action. */
    func updateView() {
        
        let buttonVisibleTopSpace : CGFloat = 103.0
        let buttonHiddenTopSpace : CGFloat = 34.0
        let checkStatusChangeStatusGap : CGFloat = 41.0//96.0
        
        switch actionType {
        case .registration:
            headerLabel.text = "Registration"
            
            let registered = user!.isRegistered
            if registered {
                
                headerImg.image = #imageLiteral(resourceName: "actionComplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You are\nregistered to vote.", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 8))
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 26, length: 1))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = true
                actionLabel.isHidden = true
                
                checkStatusTopSpace.constant = buttonHiddenTopSpace
                changeStatusTopSpace.constant = buttonHiddenTopSpace + checkStatusChangeStatusGap
                
                
            }else {
                
                headerImg.image = #imageLiteral(resourceName: "actionIncomplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You are\nnot registered.", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 8))
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 22, length: 1))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = false
                actionBut.setTitle("Register Now", for: .normal)
                actionLabel.isHidden = false
                
                let actionString = NSMutableAttributedString(string: "Deadline: " + ElectionResourcesVC.registrationDeadline(state: (user?.state)!) + ", 2018", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ])
                actionString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                actionLabel.attributedText = actionString
                
                checkStatusTopSpace.constant = buttonVisibleTopSpace
                changeStatusTopSpace.constant = buttonVisibleTopSpace + checkStatusChangeStatusGap
            }
            
            
            //Update Last Checked:
            let lastCheckedDate = user?.lastCheckedRegistration == nil ? "N/A" : (user?.lastCheckedRegistration)! + ", 2018"
            let lastCheckedString = NSMutableAttributedString(string: "Last Checked: " + lastCheckedDate, attributes: [
                .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!])
            lastCheckedString.addAttributes([
                .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
                .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)], range: NSRange(location: 0, length: 14))
            checkStatusLabel.attributedText = lastCheckedString
            
            break
        case .mailInBallot:
            headerLabel.text = "Request Mail-In Ballot"
            
            
            let ballotRequested = user!.isMailInBallotRequested
            let willVoteInPerson = user!.willVoteInPerson
            if ballotRequested {
                headerImg.image = #imageLiteral(resourceName: "actionComplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You have\nrequested a mail-in ballot", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = true
                actionLabel.isHidden = true
                
                checkStatusTopSpace.constant = buttonHiddenTopSpace
                changeStatusTopSpace.constant = buttonHiddenTopSpace + checkStatusChangeStatusGap
            }else if willVoteInPerson {
                
                headerImg.image = #imageLiteral(resourceName: "actionComplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You will\nvote in person", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = true
                actionLabel.isHidden = true
                
                checkStatusTopSpace.constant = buttonHiddenTopSpace
                
                checkStatusBut.isHidden = true
                checkStatusLabel.isHidden = true
                changeStatusTopSpace.constant = -actionBut.frame.size.height
//                checkStatusTopSpace.constant = buttonHiddenTopSpace
//                changeStatusTopSpace.constant = buttonHiddenTopSpace + checkStatusChangeStatusGap
                
            }else {
                headerImg.image = #imageLiteral(resourceName: "actionIncomplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You have\nnot requested a mail-in ballot.", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = false
                actionBut.setTitle("Request Ballot", for: .normal)
                actionLabel.isHidden = false
                
                let actionString = NSMutableAttributedString(string: "Deadline: " + ElectionResourcesVC.mailInBallotDeadline(state: (user?.state)!) + ", 2018", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ])
                actionString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                actionLabel.attributedText = actionString
                
                checkStatusTopSpace.constant = buttonVisibleTopSpace
                
                checkStatusBut.isHidden = true
                checkStatusLabel.isHidden = true
                changeStatusTopSpace.constant = 48
                
//                checkStatusTopSpace.constant = buttonVisibleTopSpace
//                changeStatusTopSpace.constant = buttonVisibleTopSpace + checkStatusChangeStatusGap
            }
            
            //Update Last Checked:
//            let lastCheckedDate = user?.lastCheckedMailInBallot == nil ? "N/A" : (user?.lastCheckedMailInBallot)! + ", 2018"
//            let lastCheckedString = NSMutableAttributedString(string: "Last Checked: " + lastCheckedDate, attributes: [
//                .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!])
//            lastCheckedString.addAttributes([
//                .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
//                .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)], range: NSRange(location: 0, length: 14))
//            checkStatusLabel.attributedText = lastCheckedString
            
            
            break
        case .submitBallot:
            headerLabel.text = "Submit Ballot"
            
            
            let ballotSubmitted = user!.isBallotSubmitted
            if ballotSubmitted {
                headerImg.image = #imageLiteral(resourceName: "actionComplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You have\nsubmitted your ballot.", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 50.0 / 255.0, green: 183.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 30, length: 1))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = true
                actionLabel.isHidden = true
                
                checkStatusTopSpace.constant = buttonHiddenTopSpace
                
                checkStatusBut.isHidden = true
                checkStatusLabel.isHidden = true
                changeStatusTopSpace.constant = -actionBut.frame.size.height
                
            }else {
                headerImg.image = #imageLiteral(resourceName: "actionIncomplete")
                
                //#LOCALIZE
                let attributedString = NSMutableAttributedString(string: "You have\nnot submitted your ballot.", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-900", size: 32.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ])
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                attributedString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-500", size: 32.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 34, length: 1))
                headerStatus.attributedText = attributedString
                
                //BUTTONS
                actionBut.isHidden = false
                actionBut.setTitle("Submit Your Ballot", for: .normal)
                actionLabel.isHidden = false
                
                let actionString = NSMutableAttributedString(string: "Deadline: November 6, 2018", attributes: [
                    .font: UIFont(name: "MuseoSansRounded-500", size: 16.0)!,
                    .foregroundColor: UIColor(white: 112.0 / 255.0, alpha: 1.0)
                    ])
                actionString.addAttributes([
                    .font: UIFont(name: "MuseoSansRounded-900", size: 16.0)!,
                    .foregroundColor: UIColor(red: 237.0 / 255.0, green: 28.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
                    ], range: NSRange(location: 0, length: 9))
                actionLabel.attributedText = actionString
                
                checkStatusTopSpace.constant = buttonVisibleTopSpace
                
                checkStatusBut.isHidden = true
                checkStatusLabel.isHidden = true
                changeStatusTopSpace.constant = 48
            }
            
            break
        default:
            break
        }
    }
    
    /** Pass Action Type Via Segue */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let changeStatusVC = segue.destination as? ChangeStatusVC {
            changeStatusVC.actionType = actionType
        }
        //#CLEANUP
        /*
        if let webVC = segue.destination as? WebVC {
            webVC.actionType = actionType
            
            //Switch to Registration Check Type if Appropriate
            if actionType == .registration {
                if let button = sender as? UIButton {
                    if button.tag == 1 {
                        webVC.actionType = .registrationCheck
                    }
                }
            }
            
        }
        */
    }
    
    /** Perform Action */
    @IBAction func takeAction(sender: UIButton) {
        
        
        //Update user status //#TEMP
        switch actionType {
        case .registration:
            if sender.tag == 0 {
                self.openWithSafariVC("https://www.vote.org/register-to-vote/")
            }else {
                self.openWithSafariVC("https://www.vote.org/am-i-registered-to-vote/")
            }
//            self.performSegue(withIdentifier: "OpenWebVC", sender: sender)
//            user?.isRegistered = true
            updateLastCheckedRegistration()
            break
        case .mailInBallot:
            self.openWithSafariVC("https://www.vote.org/absentee-ballot/")
//            self.performSegue(withIdentifier: "OpenWebVC", sender: sender)
//            user?.isMailInBallotRequested = true
            updateLastCheckedMailInBallot()
            break
        case .submitBallot:
            self.performSegue(withIdentifier: "OpenElectionResources", sender: sender)
            break
//        case .registrationCheck:
//            self.openWithSafariVC("https://www.vote.org/am-i-registered-to-vote/")
//            self.performSegue(withIdentifier: "OpenWebVC", sender: sender)
//            break
        default:
            break
        }
    }
    
    func updateLastCheckedRegistration(){
        let today = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let todayStr = dateFormatter.string(from: today)
        
        user?.lastCheckedRegistration = todayStr
    }
    
    func updateLastCheckedMailInBallot(){
        let today = Date.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let todayStr = dateFormatter.string(from: today)
        
        user?.lastCheckedMailInBallot = todayStr
    }
    //#CLEANUP
    func openWithSafariVC(_ urlStr: String)
    {
//        let localFilePath = Bundle.main.url(forResource: "testAbsentee", withExtension: "html")
        let url = URL.init(string: urlStr)!
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
////        let request = URLRequest(url: url)
//        let svc = SFSafariViewController(url: url)
////        svc.delegate = self
//        self.present(svc, animated: true, completion: nil)
    }

}
    
//extension ActionVC : SFSafariViewControllerDelegate {
//
//}

//#CLEANUP
/*
class WebVC: UIViewController {
    //MARK: Variables & Constants
    var actionType: ActionType = .registration
    
    /** Webview. */
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.navigationDelegate = self
        
        var html = ""
//        var url : URL = URL.init(string: "https://www.vote.org")!
        switch actionType {
        case .registration:
//            url = URL.init(string: "https://www.vote.org/register-to-vote/")!
            html = "<!DOCTYPE html><html><body><iframe src=\"https://register.vote.org/?partner=111111&campaign=free-tools\" width=\"100%\" marginheight=\"0\" frameborder=\"0\" id=\"frame1\" scrollable =\"no\"></iframe><script type=\"text/javascript\" src=\"//cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.3/iframeResizer.min.js\"></script><script type=\"text/javascript\">iFrameResize({ log:true, checkOrigin:false});</script></body></html>"
            break
        case .mailInBallot:
//            url = URL.init(string: "https://www.vote.org/absentee-ballot/")!
            
            html = "<!DOCTYPE html><html><body><iframe src=\"https://absentee.vote.org/?partner=111111&campaign=free-tools\" width=\"100%\" marginheight=\"0\" frameborder=\"0\" id=\"frame2\" scrollable=\"no\"></iframe><script type=\"text/javascript\" src=\"//cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.3/iframeResizer.min.js\"></script><script type=\"text/javascript\">iFrameResize({ log:true, checkOrigin:false});</script></body></html>"

            break
        case .submitBallot:
            break
        case .registrationCheck:
//            url = URL.init(string: "https://www.vote.org/am-i-registered-to-vote/")!
            html = "<!DOCTYPE html><html><body><iframe src=\"https://verify.vote.org/?partner=111111&campaign=free-tools\" width=\"100%\" marginheight=\"0\" frameborder=\"0\" id=\"frame3\" scrollable=\"no\"></iframe><script type=\"text/javascript\" src=\"//cdnjs.cloudflare.com/ajax/libs/iframe-resizer/3.5.3/iframeResizer.min.js\" ></script><script type=\"text/javascript\">iFrameResize({ log:true, checkOrigin:false});</script></body></html>"
            break
            
        }
        
        
//        let urlRequest = URLRequest.init(url: url)
//        webView.load(urlRequest)
        webView.loadHTMLString(html, baseURL: nil)
        
        //Zoom in
//        webView.scrollView.zoomScale = 2.2 //#CLEANUP
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

extension WebVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //        webView.scrollView.zoomScale = 3.0  //#CLEANUP
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        // Allow navigation for requests loading external web content resources.
        decisionHandler(.allow)
        return
//        guard navigationAction.targetFrame?.isMainFrame != false else {
//            decisionHandler(.allow)
//            return
//        }else {
//            decisionHandler(.cancel)
//        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        return
    }
}*/


class ChangeStatusVC: UIViewController {
    
    //MARK: Variables & Constants
    
    /** Current User Object */
    var user : User?
    
    
    var actionType: ActionType = .registration
    
    /** Label prompting user to select a button. */
    @IBOutlet var headerLabel: UILabel!
    
    @IBOutlet var yesBut: UIButton!
    @IBOutlet var noBut: UIButton!
    @IBOutlet var neitherBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Retrieve user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = appDelegate.user
        
        
        updateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** Dismiss View Controller */
    @IBAction func dismissVC() {
        self.dismiss(animated: true) {}
    }
    
    //MARK: View Updates & Management
    /** Configure the view to reflect the current Action Type and status of that action. */
    //#LOCALIZE
    func updateView() {
        switch actionType {
        case .registration:
            headerLabel.text = "Are you registered to vote?"
            neitherBut.isHidden = true
            break
        case .mailInBallot:
            headerLabel.text = "Have you requested your mail-in ballot?"
            neitherBut.isHidden = false
            break
        case .submitBallot:
            headerLabel.text = "Have you submitted your ballot?"
            neitherBut.isHidden = true
            break
        
        default:
            break
        }
    }
    
    /** User selected Yes Option. */
    @IBAction func selectYes(){
        
        //Update User Defaults for Siri App Extension:
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote")//"group.com.Goldfish.iVote")
        
        switch actionType {
        case .registration:
            user!.isRegistered = true
            userDefaults?.set(true, forKey: "IsRegistered")
            break
        case .mailInBallot:
            user!.isMailInBallotRequested = true
            user!.willVoteInPerson = false

            userDefaults?.set(true, forKey: "IsMailInBallotRequested")
            break
        case .submitBallot:
            user!.isBallotSubmitted = true
            userDefaults?.set(true, forKey: "IsBallotSubmitted")
            break
            
        default:
            break
        }
        
        userDefaults?.synchronize()
        dismissVC()
    }
    
    /** User selected No Option. */
    @IBAction func selectNo(){
        //Update User Defaults for Siri App Extension:
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote") //"group.com.Goldfish.iVote")
        
        
        switch actionType {
        case .registration:
            user!.isRegistered = false
            userDefaults?.set(false, forKey: "IsRegistered")
            break
        case .mailInBallot:
            user!.isMailInBallotRequested = false
            user!.willVoteInPerson = false
            userDefaults?.set(false, forKey: "IsMailInBallotRequested")
            break
        case .submitBallot:
            user!.isBallotSubmitted = false
            userDefaults?.set(false, forKey: "IsBallotSubmitted")
            break
            
        default:
            break
        }
        
        userDefaults?.synchronize()
        
        dismissVC()
    }
    
    /** User selected Will Vote In Person. */
    @IBAction func willVoteInPerson() {
        user!.isMailInBallotRequested = false
        user!.willVoteInPerson = true
        
        //Update User Defaults for Siri App Extension:
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote")//"group.com.Goldfish.iVote")
        userDefaults?.set(false, forKey: "IsMailInBallotRequested")
        userDefaults?.synchronize()
        
        dismissVC()
    }
    
}


