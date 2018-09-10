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
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let state = appDelegate.user?.state
        
        var url = ""
        switch sender.tag{
        case 0:
            url = "https://www.usa.gov/voter-research"
        case 1:
            url = "https://www.vote411.org/enter-your-address?dest=voting-dossier"
        case 2:
            if state == "Alabama" {
                url = "http://www.alabamavotes.gov"
            }else if state == "Alaska" {
                url = "http://www.elections.alaska.gov"
            }else if state == "Arizona" {
                url = "http://www.azsos.gov/election"
            }else if state == "Arkansas" {
                url = "http://www.sos.arkansas.gov/elections"
            }else if state == "California" {
                url = "http://www.sos.ca.gov/elections"
            }else if state == "Colorado" {
                url = "http://www.sos.state.co.us/pubs/elections/vote/VoterHome.html"
            }else if state == "Connecticut" {
                url = "http://www.sots.ct.gov"
            }else if state == "Delaware" {
                url = "http://elections.delaware.gov"
            }else if state == "District of Columbia" {
                url = "https://www.dcboe.org/home.asp?skip=Y"
            }else if state == "Florida" {
                url = "http://election.dos.state.fl.us"
            }else if state == "Georgia" {
                url = "http://sos.ga.gov"
            }else if state == "Hawaii" {
                url = "http://hawaii.gov/elections"
            }else if state == "Idaho" {
                url = "http://www.idahovotes.gov"
            }else if state == "Illinois" {
                url = "https://www.elections.il.gov"
            }else if state == "Indiana" {
                url = "http://www.in.gov/sos/elections/index.htm"
            }else if state == "Iowa" {
                url = "http://www.sos.state.ia.us"
            }else if state == "Kansas" {
                url = "http://www.kssos.org"
            }else if state == "Kentucky" {
                url = "http://sos.ky.gov/elections"
            }else if state == "Louisiana" {
                url = "http://www.sos.la.gov/ElectionsAndVoting/Pages/default.aspx"
            }else if state == "Maine" {
                url = "http://www.state.me.us/sos/cec/elec/index.html"
            }else if state == "Maryland" {
                url = "http://www.elections.state.md.us"
            }else if state == "Massachusetts" {
                url = "http://www.sec.state.ma.us/ele/eleidx.htm"
            }else if state == "Michigan" {
                url = "http://www.michigan.gov/sos/0,4670,7-127-1633---,00.html"
            }else if state == "Minnesota" {
                url = "http://www.sos.state.mn.us/home/index.asp"
            }else if state == "Mississippi" {
                url = "http://www.sos.ms.gov/Elections-Voting/Pages/default.aspx"
            }else if state == "Missouri" {
                url = "http://www.sos.mo.gov"
            }else if state == "Montana" {
                url = "http://sos.mt.gov/Elections/index.asp"
            }else if state == "Nebraska" {
                url = "http://www.sos.ne.gov/dyindex.html#boxingName"
            }else if state == "Nevada" {
                url = "http://nvsos.gov/index.aspx?page=3"
            }else if state == "New Hampshire" {
                url = "http://sos.nh.gov/Elections.aspx"
            }else if state == "New Jersey" {
                url = "http://www.state.nj.us/state/elections"
            }else if state == "New Mexico" {
                url = "http://www.sos.state.nm.us"
            }else if state == "New York" {
                url = "http://www.elections.ny.gov"
            }else if state == "North Carolina" {
                url = "http://www.ncsbe.gov"
            }else if state == "North Dakota" {
                url = "http://sos.nd.gov/elections"
            }else if state == "Ohio" {
                url = "http://www.sos.state.oh.us"
            }else if state == "Oklahoma" {
                url = "http://www.state.ok.us/~elections/index.html"
            }else if state == "Oregon" {
                url = "http://www.sos.state.or.us/elections/"
            }else if state == "Pennsylvania" {
                url = "http://www.votespa.com"
            }else if state == "Rhode Island" {
                url = "http://www.sos.ri.gov"
            }else if state == "South Carolina" {
                url = "http://www.scvotes.org"
            }else if state == "South Dakota" {
                url = "http://sdsos.gov/default.aspx"
            }else if state == "Tennessee" {
                url = "http://www.tn.gov/sos/election/index.htm"
            }else if state == "Texas" {
                url = "http://www.sos.state.tx.us/elections/index.shtml"
            }else if state == "Utah" {
                url = "http://www.elections.utah.gov"
            }else if state == "Vermont" {
                url = "http://vermont-elections.org/soshome.htm"
            }else if state == "Virginia" {
                url = "http://elections.virginia.gov"
            }else if state == "Washington" {
                url = "http://www.sos.wa.gov/elections"
            }else if state == "West Virginia" {
                url = "http://www.wvsos.com"
            }else if state == "Wisconsin" {
                url = "http://www.elections.wi.gov"
            }else if state == "Wyoming"{
                url = "http://soswy.state.wy.us/Elections/Elections.aspx"
            }
            
        default:
            break
        }
        
        if url != "" {
            let svc = SFSafariViewController(url: URL(string: url)!)
            self.present(svc, animated: true, completion: nil)
        }
    }
    
    /** Registration Deadline */
    class func registrationDeadline(state: String) -> String {
        if state == "Alabama" {
            return "October 22"
        }else if state == "Alaska" {
            return "October 7"
        }else if state == "Arizona" {
            return "October 9"
        }else if state == "Arkansas" {
            return "October 9"
        }else if state == "California" {
            return "October 22"
        }else if state == "Colorado" {
            return "October 29"
        }else if state == "Connecticut" {
            return "October 30"
        }else if state == "Delaware" {
            return "October 13"
        }else if state == "District of Columbia" {
            return "October 16"
        }else if state == "Florida" {
            return "October 9"
        }else if state == "Georgia" {
            return "October 9"
        }else if state == "Hawaii" {
            return "October 8"
        }else if state == "Idaho" {
            return "October 12"
        }else if state == "Illinois" {
            return "October 9"
        }else if state == "Indiana" {
            return "October 9"
        }else if state == "Iowa" {
            return "October 27"
        }else if state == "Kansas" {
            return "October 16"
        }else if state == "Kentucky" {
            return "October 9"
        }else if state == "Louisiana" {
            return "October 9"
        }else if state == "Maine" {
            return "October 16"
        }else if state == "Maryland" {
            return "October 16"
        }else if state == "Massachusetts" {
            return "October 17"
        }else if state == "Michigan" {
            return "October 9"
        }else if state == "Minnesota" {
            return "October 16"
        }else if state == "Mississippi" {
            return "October 9"
        }else if state == "Missouri" {
            return "October 10"
        }else if state == "Montana" {
            return "October 9"
        }else if state == "Nebraska" {
            return "October 19"
        }else if state == "Nevada" {
            return "October 18"
        }else if state == "New Hampshire" {
            return "October 27"
        }else if state == "New Jersey" {
            return "October 16"
        }else if state == "New Mexico" {
            return "October 9"
        }else if state == "New York" {
            return "October 12"
        }else if state == "North Carolina" {
            return "October 12"
        }else if state == "North Dakota" {
            return "November 6"
        }else if state == "Ohio" {
            return "October 9"
        }else if state == "Oklahoma" {
            return "October 12"
        }else if state == "Oregon" {
            return "October 16"
        }else if state == "Pennsylvania" {
            return "October 9"
        }else if state == "Rhode Island" {
            return "October 7"
        }else if state == "South Carolina" {
            return "October 7"
        }else if state == "South Dakota" {
            return "October 22"
        }else if state == "Tennessee" {
            return "October 9"
        }else if state == "Texas" {
            return "October 9"
        }else if state == "Utah" {
            return "October 30"
        }else if state == "Vermont" {
            return "October 31"
        }else if state == "Virginia" {
            return "October 15"
        }else if state == "Washington" {
            return "October 8"
        }else if state == "West Virginia" {
            return "October 16"
        }else if state == "Wisconsin" {
            return "October 17"
        }else if state == "Wyoming"{
            return "October 22"
        }
        
        return ""
    }
    
    /** Mail-In Ballot Deadline */
    class func mailInBallotDeadline(state: String) -> String {
        if state == "Alabama" {
            return "November 1"
        }else if state == "Alaska" {
            return "October 27"
        }else if state == "Arizona" {
            return "October 26"
        }else if state == "Arkansas" {
            return "October 30"
        }else if state == "California" {
            return "October 30"
        }else if state == "Colorado" {
            return "November 6"
        }else if state == "Connecticut" {
            return "November 5"
        }else if state == "Delaware" {
            return "November 5"
        }else if state == "District of Columbia" {
            return "November 3"
        }else if state == "Florida" {
            return "October 31"
        }else if state == "Georgia" {
            return "November 2"
        }else if state == "Hawaii" {
            return "October 30"
        }else if state == "Idaho" {
            return "October 26"
        }else if state == "Illinois" {
            return "November 1"
        }else if state == "Indiana" {
            return "October 29"
        }else if state == "Iowa" {
            return "October 27"
        }else if state == "Kansas" {
            return "November 2"
        }else if state == "Kentucky" {
            return "October 30"
        }else if state == "Louisiana" {
            return "November 2"
        }else if state == "Maine" {
            return "November 1"
        }else if state == "Maryland" {
            return "November 2"
        }else if state == "Massachusetts" {
            return "November 5"
        }else if state == "Michigan" {
            return "November 3"
        }else if state == "Minnesota" {
            return "November 5"
        }else if state == "Mississippi" {
            return "November 3"
        }else if state == "Missouri" {
            return "October 31"
        }else if state == "Montana" {
            return "November 5"
        }else if state == "Nebraska" {
            return "October 26"
        }else if state == "Nevada" {
            return "October 30"
        }else if state == "New Hampshire" {
            return "November 5"
        }else if state == "New Jersey" {
            return "October 30"
        }else if state == "New Mexico" {
            return "November 2"
        }else if state == "New York" {
            return "October 30"
        }else if state == "North Carolina" {
            return "October 30"
        }else if state == "North Dakota" {
            return "November 5"
        }else if state == "Ohio" {
            return "November 3"
        }else if state == "Oklahoma" {
            return "October 31"
        }else if state == "Oregon" {
            return "November 6"
        }else if state == "Pennsylvania" {
            return "October 30"
        }else if state == "Rhode Island" {
            return "October 16"
        }else if state == "South Carolina" {
            return "November 2"
        }else if state == "South Dakota" {
            return "November 5"
        }else if state == "Tennessee" {
            return "October 30"
        }else if state == "Texas" {
            return "October 26"
        }else if state == "Utah" {
            return "November 1"
        }else if state == "Vermont" {
            return "November 5"
        }else if state == "Virginia" {
            return "October 30"
        }else if state == "Washington" {
            return "October 8"
        }else if state == "West Virginia" {
            return "October 31"
        }else if state == "Wisconsin" {
            return "November 1"
        }else if state == "Wyoming"{
            return "November 5"
        }
        
        return ""
    }
    
}
