//
//  IntentHandler.swift
//  Siri
//
//  Created by BFar on 9/20/18.
//  Copyright © 2018 iVote. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any? {
        switch intent {
        case is INSearchForNotebookItemsIntent:
            return SearchItemsIntentHandler()
        default:
            return nil
        }
    }
}

class SearchItemsIntentHandler: NSObject, INSearchForNotebookItemsIntentHandling {
    
    func resolveItemType(for intent: INSearchForNotebookItemsIntent,
                         with completion: @escaping (INNotebookItemTypeResolutionResult) -> Void) {
        
        completion(.success(with: .taskList))
    }

    func resolveTitle(for intent: INSearchForNotebookItemsIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        guard let title = intent.title else {
            completion(.needsValue())
            return
        }
        
        let possibleLists = [INSpeakableString(spokenPhrase: "voting deadlines"),
                             INSpeakableString(spokenPhrase: "deadlines"),
                             INSpeakableString(spokenPhrase: "dates"),
                             INSpeakableString(spokenPhrase: "reminders"),
                             INSpeakableString(spokenPhrase: "date"),
                             INSpeakableString(spokenPhrase: "registration"),
                             INSpeakableString(spokenPhrase: "tasks"),
                             INSpeakableString(spokenPhrase: "task"),
                             INSpeakableString(spokenPhrase: "to-do"),
                             INSpeakableString(spokenPhrase: "todo"),
                             INSpeakableString(spokenPhrase: "todos"),
                             INSpeakableString(spokenPhrase: "to do")]
        //getPossibleLists(for: title)
        completeResolveListName(with: possibleLists, for: title, with: completion)
    }
/*
    public func getPossibleLists(for listName: INSpeakableString) -> [INSpeakableString]
        var possibleLists = [INSpeakableString]()
    
        for l in loadLists() {
            if l.name.lowercased() == listName.spokenPhrase.lowercased() {
                return [INSpeakableString(spokenPhrase: l.name)]
            }
            if l.name.lowercased().contains(listName.spokenPhrase.lowercased()) || listName.spokenPhrase.lowercased() == "all" {
                possibleLists.append(INSpeakableString(spokenPhrase: l.name))
            }
        }
        return possibleLists
    }*/

    public func completeResolveListName(with possibleLists: [INSpeakableString], for listName: INSpeakableString, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        completion(.success(with: possibleLists[0]))
        /*
        switch possibleLists.count {
        case 0:
            completion(.unsupported())
        case 1:
            if possibleLists[0].spokenPhrase.lowercased() == listName.spokenPhrase.lowercased() {
                completion(.success(with: possibleLists[0]))
            } else {
                completion(.confirmationRequired(with: possibleLists[0]))
            }
        default:
            completion(.disambiguation(with: possibleLists))
        }*/
    }

    func confirm(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        completion(INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil))
    }

    func handle(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
//        guard
//            let title = intent.title
//            let list = loadLists().filter({ $0.name.lowercased() == title.spokenPhrase.lowercased()}).first
//            else {
//                completion(INSearchForNotebookItemsIntentResponse(code: .failure, userActivity: nil))
//                return
//        }
        
        let response = INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil)
        
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote") //"group.com.Goldfish.iVote") 
//        let state = userDefaults?.value(forKey: "state")
//        let regDeadline = registrationDeadline(state: state as! String)
        let regDeadline = userDefaults?.value(forKey: "registrationDeadline")
        let regDateComponents = extractDateComponents(from: regDeadline as! String)
        var regComplete = userDefaults?.value(forKey: "IsRegistered") as? Bool
        regComplete = regComplete == nil ? false : regComplete
        
        let mailInDeadline = userDefaults?.value(forKey: "mailInDeadline")
        let mailInDateComponents = extractDateComponents(from: mailInDeadline as! String)
        var mailInComplete = userDefaults?.value(forKey: "IsMailInBallotRequested") as? Bool
        mailInComplete = mailInComplete == nil ? false : mailInComplete
        
        let voteDeadline = "November 6"
        let voteDateComponents = extractDateComponents(from: voteDeadline)
        var voteComplete = userDefaults?.value(forKey: "IsBallotSubmitted") as? Bool
        voteComplete = voteComplete == nil ? false : voteComplete
        
        response.tasks =  [INTask(title: INSpeakableString(spokenPhrase: "Register to Vote"),
                                  status: regComplete! ? INTaskStatus.completed : INTaskStatus.notCompleted,
                                  taskType: INTaskType.completable,
                                  spatialEventTrigger: nil,
                                  temporalEventTrigger: INTemporalEventTrigger(dateComponentsRange: INDateComponentsRange(start: regDateComponents, end:regDateComponents)),
                                  createdDateComponents: nil,
                                  modifiedDateComponents: nil,
                                  identifier: "tasks.register"),
                           INTask(title: INSpeakableString(spokenPhrase: "Request Mail-In Ballot"),
                                  status: mailInComplete! ? INTaskStatus.completed : INTaskStatus.notCompleted,
                                  taskType: INTaskType.completable,
                                  spatialEventTrigger: nil,
                                  temporalEventTrigger: INTemporalEventTrigger(dateComponentsRange: INDateComponentsRange(start: mailInDateComponents , end: mailInDateComponents)),
                                  createdDateComponents: nil,
                                  modifiedDateComponents: nil,
                                  identifier: "tasks.mailinballot"),
                           INTask(title: INSpeakableString(spokenPhrase: "Submit Ballot"),
                                  status: voteComplete! ? INTaskStatus.completed : INTaskStatus.notCompleted,
                                  taskType: INTaskType.completable,
                                  spatialEventTrigger: nil,
                                  temporalEventTrigger: INTemporalEventTrigger(dateComponentsRange: INDateComponentsRange(start: voteDateComponents , end: voteDateComponents)),
                                  createdDateComponents: nil,
                                  modifiedDateComponents: nil,
                                  identifier: "tasks.submitballot")]
        
        completion(response)
    }
    
    
    //DATE MANAGEMENT
    
    func extractDateComponents(from dateStr: String) -> DateComponents {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let date = dateFormatter.date(from: dateStr)
        print(date!)
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        dateComponents.year = 2018
        return dateComponents
    }
}
    /*
    /** Registration Deadline */
    func registrationDeadline(state: String) -> String {
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
    func mailInBallotDeadline(state: String) -> String {
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
    
    /* Submit Ballot Deadline */
    func submitDeadline() -> String {
        return "November 6"
    }
}

*/



/*
import Intents

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension, INSendMessageIntentHandling, INSearchForMessagesIntentHandling, INSetMessageAttributeIntentHandling {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
    // MARK: - INSendMessageIntentHandling
    
    // Implement resolution methods to provide additional information about your intent (optional).
    func resolveRecipients(for intent: INSendMessageIntent, with completion: @escaping ([INPersonResolutionResult]) -> Void) {
        if let recipients = intent.recipients {
            
            // If no recipients were provided we'll need to prompt for a value.
            if recipients.count == 0 {
                completion([INPersonResolutionResult.needsValue()])
                return
            }
            
            var resolutionResults = [INPersonResolutionResult]()
            for recipient in recipients {
                let matchingContacts = [recipient] // Implement your contact matching logic here to create an array of matching contacts
                switch matchingContacts.count {
                case 2  ... Int.max:
                    // We need Siri's help to ask user to pick one from the matches.
                    resolutionResults += [INPersonResolutionResult.disambiguation(with: matchingContacts)]
                    
                case 1:
                    // We have exactly one matching contact
                    resolutionResults += [INPersonResolutionResult.success(with: recipient)]
                    
                case 0:
                    // We have no contacts matching the description provided
                    resolutionResults += [INPersonResolutionResult.unsupported()]
                    
                default:
                    break
                    
                }
            }
            completion(resolutionResults)
        }
    }
    
    func resolveContent(for intent: INSendMessageIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let text = intent.content, !text.isEmpty {
            completion(INStringResolutionResult.success(with: text))
        } else {
            completion(INStringResolutionResult.needsValue())
        }
    }
    
    // Once resolution is completed, perform validation on the intent and provide confirmation (optional).
    
    func confirm(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Verify user is authenticated and your app is ready to send a message.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .ready, userActivity: userActivity)
        completion(response)
    }
    
    // Handle the completed intent (required).
    
    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        // Implement your application logic to send a message here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSendMessageIntent.self))
        let response = INSendMessageIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
    
    // Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.
    
    // MARK: - INSearchForMessagesIntentHandling
    
    func handle(intent: INSearchForMessagesIntent, completion: @escaping (INSearchForMessagesIntentResponse) -> Void) {
        // Implement your application logic to find a message that matches the information in the intent.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSearchForMessagesIntent.self))
        let response = INSearchForMessagesIntentResponse(code: .success, userActivity: userActivity)
        // Initialize with found message's attributes
        response.messages = [INMessage(
            identifier: "identifier",
            content: "I am so excited about SiriKit!",
            dateSent: Date(),
            sender: INPerson(personHandle: INPersonHandle(value: "sarah@example.com", type: .emailAddress), nameComponents: nil, displayName: "Sarah", image: nil,  contactIdentifier: nil, customIdentifier: nil),
            recipients: [INPerson(personHandle: INPersonHandle(value: "+1-415-555-5555", type: .phoneNumber), nameComponents: nil, displayName: "John", image: nil,  contactIdentifier: nil, customIdentifier: nil)]
            )]
        completion(response)
    }
    
    // MARK: - INSetMessageAttributeIntentHandling
    
    func handle(intent: INSetMessageAttributeIntent, completion: @escaping (INSetMessageAttributeIntentResponse) -> Void) {
        // Implement your application logic to set the message attribute here.
        
        let userActivity = NSUserActivity(activityType: NSStringFromClass(INSetMessageAttributeIntent.self))
        let response = INSetMessageAttributeIntentResponse(code: .success, userActivity: userActivity)
        completion(response)
    }
}

*/
