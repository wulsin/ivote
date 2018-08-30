//
//  NotificationScheduler.swift
//  iVote
//
//  Created by BFar on 8/13/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationScheduler: NSObject {
    /** Request Notifications Access */
    class func requestNotifAccess() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
    }
    
    /** Schedule all Local Notifications */
    class func scheduleNotifs(){
        
        //Retrieve user
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        
        
        let center = UNUserNotificationCenter.current()
        
        //Registration Notif
        if !user!.isRegistered {
            let content = UNMutableNotificationContent()
            content.title = "Don't forget to register!" //#LOCALIZE
            content.body = "Register to vote by " + ElectionResourcesVC.registrationDeadline(state: (user?.state)!) + ", 2018"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60,
                                                            repeats: true)
            
            let identifier = "RegistrationLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
//                if let error = error {
//                    // Something went wrong
//                }
            })
        }
        
        //Mail-in Ballot Notif
        else if !user!.isMailInBallotRequested && !user!.willVoteInPerson {
            let content = UNMutableNotificationContent()
            content.title = "Don't forget to request a ballot!" //#LOCALIZE
            content.body = "Request your mail-in ballot by " + ElectionResourcesVC.mailInBallotDeadline(state: (user?.state)!) + ", 2018"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60,
                                                            repeats: true)
            
            let identifier = "MailInBallotLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
//                if let error = error {
//                    // Something went wrong
//                }
            })
        }
        //Submit Ballot Notif
        else if !user!.isBallotSubmitted {
            let content = UNMutableNotificationContent()
            content.title = "Don't forget to submit your ballot!" //#LOCALIZE
            content.body = "Submit ballot by November 6, 2018"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60,
                                                            repeats: true)
            
            let identifier = "SubmitBallotLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: { (error) in
//                if let error = error {
//                    // Something went wrong
//                }
            })
        }
    }
    
    /** Remove all scheduled Notifications */
    class func removeNotifs(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}
