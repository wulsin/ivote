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
        
        let interval : TimeInterval = 60*60*24*2 // 2 Days
        var curDate = Date().addingTimeInterval(interval)
        
        //Registration Notif
        if !user!.isRegistered {
            let deadline = ElectionResourcesVC.registrationDeadline(state: (user?.state)!)
            let title = "Don't forget to register!" //#LOCALIZE
            let body = "Register to vote by " + deadline + ", 2018"
            let identifier = "RegistrationLocalNotification"
            
//            let endDate = Date().addingTimeInterval(interval*2)
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                scheduleNotif(identifier:"\(identifier)_\(count)", title: title, body: body, date: curDate)
                curDate = curDate.addingTimeInterval(interval)
                count += 1
            }
        }
        //Mail-in Ballot Notif
        if !user!.isMailInBallotRequested && !user!.willVoteInPerson {
            
            let deadline = ElectionResourcesVC.mailInBallotDeadline(state: (user?.state)!)
            let title = "Don't forget to request a ballot!" //#LOCALIZE
            let body = "Request your mail-in ballot by " + deadline + ", 2018"
            let identifier = "MailInBallotLocalNotification"
            
//            let endDate = Date().addingTimeInterval(interval*5)
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                scheduleNotif(identifier:"\(identifier)_\(count)", title: title, body: body, date: curDate)
                curDate = curDate.addingTimeInterval(interval)
                count += 1
            }
        }
            
        //Submit Ballot Notif
        if !user!.isBallotSubmitted {
            
            let deadline = "November 6" //#HARDCODE
            let title = "Don't forget to submit your ballot!" //#LOCALIZE
            let body = "Submit ballot by November 6, 2018"
            let identifier = "SubmitBallotLocalNotification"
            
//            let endDate = Date().addingTimeInterval(interval*8)
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                scheduleNotif(identifier:"\(identifier)_\(count)", title: title, body: body, date: curDate)
                curDate = curDate.addingTimeInterval(interval)
                count += 1
            }
        }
    }
    
    class func extractEndDate(from dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let date = dateFormatter.date(from: dateStr)
        print(date!)
        return date!
    }
    
    //#CLEANUP
//    class func scheduleNotifs(from startDate: Date, to endDate: Date, with interval: TimeInterval) {
//        var curDate = startDate
//        var count: Int = 0
//        while curDate.compare(endDate) != .orderedDescending {
//            scheduleNotif(identifier:"\(identifier)_\(count)", title: title, body: body, date: curDate)
//            curDate = curDate.addingTimeInterval(interval)
//            count += 1
//        }
//    }
    
    class func scheduleNotif(identifier: String, title: String, body: String, date: Date) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let triggerTime = Calendar.current.dateComponents([.year, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }
    
    //#CLEANUP
        /*
        //Registration Notif
        if !user!.isRegistered {
            let content = UNMutableNotificationContent()
            content.title = "Don't forget to register!" //#LOCALIZE
            content.body = "Register to vote by " + ElectionResourcesVC.registrationDeadline(state: (user?.state)!) + ", 2018"
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval,
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
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval,
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
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval,
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
        }*/
    
    
    /** Remove all scheduled Notifications */
    class func removeNotifs(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}
