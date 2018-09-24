//
//  Settings.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit
import MagicalRecord

class SettingsVC: KeyboardAwareVC {
    
    //MARK: Variables & Constants
    /** Current User Object */
    var user : User?
    
    /** State Picker */
    @IBOutlet var picker: UIPickerView!
    
    /** Picker Bottom Space */
    @IBOutlet var pickerBottomSpace: NSLayoutConstraint!
    
    /** First Name Text Field */
    @IBOutlet var firstNameTF: IndentedTextField!
    
    /** Select State Button */
    @IBOutlet var selectStateBut: UIButton!
    
    /** Continue Button */
    @IBOutlet var continueBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Retrieve user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = appDelegate.user
        
        //Update Fields based on user data
        if user != nil {
            if user?.firstName != "" && user?.firstName != nil {
                firstNameTF.text = user?.firstName
            }
            if user?.state != "" && user?.state != nil {
                //Determine state num & select appropriate picker row
                var i = 0
                while i < 51 {
                    if title(row: i) == user?.state {
                        picker.selectRow(i, inComponent: 0, animated: false)
                        selectStateBut.setTitle(user?.state, for: .normal)
                        break
                    }
                    i += 1
                }
            }
        }else {
            //Create User
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            if user == nil {
                let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
                user = (NSManagedObject(entity: entity!, insertInto: context) as! User)
            }
            
            //Retrieve Context and Save
            appDelegate.user = user
            appDelegate.saveContext()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /** Dismiss View Controller */
    @IBAction func dismissVC() {
        self.dismiss(animated: true) {}
    }
    
    /** Continue to Home Screen */
    @IBAction func continueHome() {
        //Validate that user data exists
        if user?.firstName != "" && user?.firstName != nil && user?.state != "" && user?.state != nil {
            self.performSegue(withIdentifier: "OpenHome", sender: nil)
        }else {
            let alertController = UIAlertController(title: "Data Required",
                                                    message: "Oops, you need to fill all required fields to continue.",
                                                    preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Okay", style: .cancel) { (action: UIAlertAction) in}
            alertController.addAction(dismiss)
            
            //Handle iPad
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = continueBut
            }
            
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    /** Show Picker */
    @IBAction func showPicker() {
        
        if firstNameTF.isFirstResponder { firstNameTF.resignFirstResponder() }
        
        UIView.animate(withDuration: 0.5) {
            self.pickerBottomSpace.constant = 0.0
        }
    }
    
    /** Hide Picker */
    func hidePicker() {
        
        
        UIView.animate(withDuration: 0.5) {
            self.pickerBottomSpace.constant = -162.0
        }
    }
}


extension SettingsVC : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 51
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return title(row: row)
    }
    
    func title(row: Int) -> String? {
        switch row {
        case 0:
            return "Alabama"
        case 1:
            return "Alaska"
        case 2:
            return "Arizona"
        case 3:
            return "Arkansas"
        case 4:
            return "California"
        case 5:
            return "Colorado"
        case 6:
            return "Connecticut"
        case 7:
            return "Delaware"
        case 8:
            return "District of Columbia"
        case 9:
            return "Florida"
        case 10:
            return "Georgia"
        case 11:
            return "Hawaii"
        case 12:
            return "Idaho"
        case 13:
            return "Illinois"
        case 14:
            return "Indiana"
        case 15:
            return "Iowa"
        case 16:
            return "Kansas"
        case 17:
            return "Kentucky"
        case 18:
            return "Louisiana"
        case 19:
            return "Maine"
        case 20:
            return "Maryland"
        case 21:
            return "Massachusetts"
        case 22:
            return "Michigan"
        case 23:
            return "Minnesota"
        case 24:
            return "Mississippi"
        case 25:
            return "Missouri"
        case 26:
            return "Montana"
        case 27:
            return "Nebraska"
        case 28:
            return "Nevada"
        case 29:
            return "New Hampshire"
        case 30:
            return "New Jersey"
        case 31:
            return "New Mexico"
        case 32:
            return "New York"
        case 33:
            return "North Carolina"
        case 34:
            return "North Dakota"
        case 35:
            return "Ohio"
        case 36:
            return "Oklahoma"
        case 37:
            return "Oregon"
        case 38:
            return "Pennsylvania"
        case 39:
            return "Rhode Island"
        case 40:
            return "South Carolina"
        case 41:
            return "South Dakota"
        case 42:
            return "Tennessee"
        case 43:
            return "Texas"
        case 44:
            return "Utah"
        case 45:
            return "Vermont"
        case 46:
            return "Virginia"
        case 47:
            return "Washington"
        case 48:
            return "West Virginia"
        case 49:
            return "Wisconsin"
        case 50:
            return "Wyoming"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = title(row: row)
        selectStateBut.setTitle(state, for: .normal)
        hidePicker()
        
        //Update User
        user?.state = state
        
        //Update User Defaults for Siri App Extension:
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote")//"group.com.Goldfish.iVote")
        userDefaults?.set(state, forKey: "state")
        userDefaults?.set(ElectionResourcesVC.registrationDeadline(state: state!), forKey: "registrationDeadline")
        userDefaults?.set(ElectionResourcesVC.mailInBallotDeadline(state: state!), forKey: "mailInDeadline")
        userDefaults?.synchronize()
    }
}


/** Handle updates to First Name */
extension SettingsVC : UITextFieldDelegate {
    
    func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
//        showPicker()
        return true
    }
    
    /** Record bottom edge of active text field frame (for proper adjustment when user types keyboard) */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "First Name" {
            textField.text = ""
        }
        
        bottomEdge = textField.frame.origin.y + textField.frame.size.height + 75
        updateOffset()
        return true
    }
    
    //** When editing is over, dismiss keyboard & reset bottom edge*/
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        //Update user
        if textField.text != "First Name" && textField.text != "" { //#LOCALIZE
            user?.firstName = textField.text
        }
        
        bottomEdge = 0
    }
}
