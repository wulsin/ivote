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
        completeResolveListName(with: possibleLists, for: title, with: completion)
    }

    public func completeResolveListName(with possibleLists: [INSpeakableString], for listName: INSpeakableString, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        completion(.success(with: possibleLists[0]))
    }

    func confirm(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {
        completion(INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil))
    }

    func handle(intent: INSearchForNotebookItemsIntent, completion: @escaping (INSearchForNotebookItemsIntentResponse) -> Void) {

        
        let response = INSearchForNotebookItemsIntentResponse(code: .success, userActivity: nil)
        
        let userDefaults = UserDefaults.init(suiteName: "group.tech.ivote.ivote")
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

