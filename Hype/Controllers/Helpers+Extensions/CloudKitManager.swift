//
//  CloudKitManager.swift
//  Hype
//
//  Created by RYAN GREENBURG on 10/3/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

struct CloudKitManager {
    private static let publicDB = CKContainer.default().publicCloudDatabase
    // Create
    static func save(_ record: CKRecord, completion: @escaping (CKRecord?) -> Void) {
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            completion(record)
        }
    }
    
    static func addSubscription(of type: String, with predicate: NSPredicate, completion: @escaping (Error?) -> Void) {
        let subscription = CKQuerySubscription(recordType: type, predicate: predicate, options: .firesOnRecordCreation)
        
        // Step 3 - Set the notification properties
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "CHOO CHOO"
        notificationInfo.alertBody = "Can't Stop the Hype Train!!"
        notificationInfo.shouldBadge = true
        notificationInfo.soundName = "default"
        subscription.notificationInfo = notificationInfo
        // Step 4 - Save the subscription to the database
        publicDB.save(subscription) { (_, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
    
    // Read
    static func fetchRecordsOf(type: String, with predicate: NSPredicate, completion: @escaping ([CKRecord]?) -> Void) {
        let query = CKQuery(recordType: type, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            completion(records)
        }
    }
    
    static func fetchAppleUserReference(completion: @escaping (CKRecord.Reference?) -> Void) {

        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
            }
            
            if let recordID = recordID {
                let reference = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
               completion(reference)
            }
        }
    }
    
    // Upadte
    static func update(_ record: CKRecord, completion: @escaping (CKRecord?) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(nil)
                return
            }
            
            guard let record = records?.first else { completion(nil) ; return }
            completion(record)
        }
        publicDB.add(operation)
    }
    
    // Delete
    static func delete(_ record: CKRecord, completion: @escaping (Bool) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { _, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            completion(true)
        }
        publicDB.add(operation)
    }
}
