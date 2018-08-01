//
//  Settings.swift
//  iVote
//
//  Created by BFar on 7/31/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: KeyboardAwareVC {
    
    //MARK: Variables & Constants
    
    /** State Picker */
    @IBOutlet var picker: UIPickerView!
    
    /** Picker Bottom Space */
    @IBOutlet var pickerBottomSpace: NSLayoutConstraint!
    
    /** First Name Text Field */
    @IBOutlet var firstNameTF: IndentedTextField!
    
    /** Select State Button */
    @IBOutlet var selectStateBut: UIButton!
    
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
    
    /** Continue to Home Screen */
    @IBAction func continueHome() {
        //Validate that user data exists
        
        
        self.performSegue(withIdentifier: "OpenHome", sender: nil)
    }
    
    
    /** Show Picker */
    @IBAction func showPicker() {
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
        return 50
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
            return "Florida"
        case 9:
            return "Georgia"
        case 10:
            return "Hawaii"
        case 11:
            return "Idaho"
        case 12:
            return "Illinois"
        case 13:
            return "Indiana"
        case 14:
            return "Iowa"
        case 15:
            return "Kansas"
        case 16:
            return "Kentucky"
        case 17:
            return "Louisiana"
        case 18:
            return "Maine"
        case 19:
            return "Maryland"
        case 20:
            return "Massachusetts"
        case 21:
            return "Michigan"
        case 22:
            return "Minnesota"
        case 23:
            return "Mississippi"
        case 24:
            return "Missouri"
        case 25:
            return "Montana"
        case 26:
            return "Nebraska"
        case 27:
            return "Nevada"
        case 28:
            return "New Hampshire"
        case 29:
            return "New Jersey"
        case 30:
            return "New Mexico"
        case 31:
            return "New York"
        case 32:
            return "North Carolina"
        case 33:
            return "North Dakota"
        case 34:
            return "Ohio"
        case 35:
            return "Oklahoma"
        case 36:
            return "Oregon"
        case 37:
            return "Pennsylvania"
        case 38:
            return "Rhode Island"
        case 39:
            return "South Carolina"
        case 40:
            return "South Dakota"
        case 41:
            return "Tennessee"
        case 42:
            return "Texas"
        case 43:
            return "Utah"
        case 44:
            return "Vermont"
        case 45:
            return "Virginia"
        case 46:
            return "Washington"
        case 47:
            return "West Virginia"
        case 48:
            return "Wisconsin"
        case 49:
            return "Wyoming"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let state = title(row: row)
        selectStateBut.setTitle(state, for: .normal)
        hidePicker()
    }
}
