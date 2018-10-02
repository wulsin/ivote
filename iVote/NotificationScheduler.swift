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
        
        //Determine CurDate & Specify notifications to send at 8:00AM
        var curDate = Date().addingTimeInterval(interval/2) //Set initial interval to 1 day
        let calendar = Calendar.current
        var dateComponents: DateComponents? = calendar.dateComponents([.year, .month, .day], from: curDate)
        dateComponents?.second = 0
        dateComponents?.minute = 0
        dateComponents?.hour = 8
        curDate = calendar.date(from: dateComponents!)!
        
        //Registration Notif
        if !user!.isRegistered {
            let deadline = ElectionResourcesVC.registrationDeadline(state: (user?.state)!)
            let title = "Don't forget to register!" //#LOCALIZE
            let body = "Register to vote by " + deadline + ", 2018"
            let identifier = "RegistrationLocalNotification"
            
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                print("Registration Notif Scheduled for: ", curDate)
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
            
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                print("Mail-In Notif Scheduled for: ", curDate)
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
            
            let endDate = extractEndDate(from: deadline)
            
            //Schedule Repeating Notifs until end date
            var count: Int = 0
            while curDate.compare(endDate) != .orderedDescending {
                print("Submit Ballot Notif Scheduled for: ", curDate)
                scheduleNotif(identifier:"\(identifier)_\(count)", title: title, body: body, date: curDate)
                curDate = curDate.addingTimeInterval(interval)
                count += 1
            }
        }
    }
    
    
    class func extractEndDate(from dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        var date = dateFormatter.date(from: dateStr)
        
        let calendar = Calendar.current
        var dateComponents: DateComponents? = calendar.dateComponents([.month, .day], from: date!)
        
        //Specify date is 8:01AM in 2018
        dateComponents?.second = 0
        dateComponents?.minute = 1
        dateComponents?.hour = 8
        dateComponents?.year = 2018
        
        date = calendar.date(from: dateComponents!)
        
        print(date!)
        return date!
    }
    
    
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

    
    /** Remove all scheduled Notifications */
    class func removeNotifs(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
}
