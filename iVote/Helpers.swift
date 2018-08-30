//
//  Helpers.swift
//  iVote
//
//  Created by BFar on 7/30/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit

/** View Controller that shifts
 - Precondition: Requires the view controller to have a scroll view amongst its subviews & the scroll view must be connected in storyboard via an outlet.
 */
class KeyboardAwareVC : UIViewController {
    @IBInspectable var bottomEdge: CGFloat = 0.0
    @IBOutlet var scrollView: UIScrollView!
    
    /** Track keyboard Height */
    var keyboardHeight: CGFloat = 0.0
    
    //MARK: View Controller Lifecycle
    /** Setup the view controller */
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()
    }
    
    //MARK: Keyboard Adjustments
    /** Listen for Keyboard Show/Hide notifications.*/
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAwareVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardAwareVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /** Adjust view when keyboard is displayed.  Animates scroll view offset position to remain above keyboard. */
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            updateOffset()
        }
    }
    
    /** Update Scroll View Content Offset based on bottom edge and keyboard height. */
    func updateOffset() {
        //Check if Scroll View Offset needs to shift to display text field just above keyboard
        let margin: CGFloat = 15
        let minimumVisibleOffset: CGFloat = self.view.frame.size.height-keyboardHeight-margin
        
        if minimumVisibleOffset < bottomEdge {
            
            //Bottom Edge will be covered by keyboard -> Must adjust offset
            let shift = bottomEdge - minimumVisibleOffset
            self.scrollView.contentOffset.y = shift
            
        }
    }
    
    /** Adjust view when keyboard is dismissed.  Animates scroll view offset position to remain above keyboard. */
    @objc func keyboardWillHide(notification: NSNotification) {
        //Reset Scrollview Content Offset (Only if not dragging)
        if  !scrollView.isDragging {
            self.scrollView.contentOffset.y = 0
        }
    }
    
    /* Include this in Text Field Delegate
    /** Record bottom edge of active text field frame (for proper adjustment when user types keyboard) */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        bottomEdge = textField.frame.origin.y + textField.frame.size.height + 75
        updateOffset()
        return true
    }
    
    //** When editing is over, dismiss keyboard & reset bottom edge*/
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        bottomEdge = 0
    }
    */
}

//MARK: Border Control Extensions
@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


// MARK: TextField 
class IndentedTextField : UITextField {
    @IBInspectable var textLeftIndent: CGFloat = 0.0
    @IBInspectable var textRightIndent: CGFloat = 0.0
    @IBInspectable var clearButLeftIndent: CGFloat = 0.0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let x = bounds.origin.x + textLeftIndent
        let y = bounds.origin.y
        let width  = bounds.size.width - textLeftIndent - textRightIndent
        let height = bounds.size.height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.x -= clearButLeftIndent
        return rect
    }
}


// MARK: Custom Share Action
extension UIViewController {
    @IBAction func shareApp(_ sender: AnyObject) {
        
        let activityViewController = UIActivityViewController(
            activityItems: ["Don’t forget to vote this election...iVote helped me to register and request a mail-in ballot: https://grvk.app.link/iVote."],
            applicationActivities: nil)
        
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = (sender as! UIView)
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
}
