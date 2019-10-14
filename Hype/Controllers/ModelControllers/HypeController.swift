//
//  HypeController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
import CloudKit
// MARK: - Day 4 Changes
// Edit saveHype to accomodate adding hypes with images
class HypeController {
    /// The publicCloudDatabase of the default container
    let publicDB = CKContainer.default().publicCloudDatabase
    /// Shared instance of HypeController class
    static let shared = HypeController()
    /// Source of Truth array of Hype objects
    var hypes: [Hype] = []
    /**
     Saves a Hype object to CloudKit
     
     - Parameters:
        - text: String value for the Hype objects body
        - completion: Escaping completion block for the method
        - success: Boolean value returned in the completion block indicating a success or failure on saving the CKRecord to CloudKit
     */
    func saveHype(with text: String, photo: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        guard let currentUser = UserController.shared.currentUser else { completion(false) ; return }
        let reference = CKRecord.Reference(recordID: currentUser.recordID, action: .deleteSelf)
        // Inititialize a Hype object with the text value passed in as a parameter
        let newHype = Hype(body: text, userReference: reference, hypePhoto: photo)
        // Initialize a CKRecord from the Hype object to be saved in CloudKit
        let hypeRecord = CKRecord(hype: newHype)
        // Call the CKContainer's save method on the database
        publicDB.save(hypeRecord) { (record, error) in
            // Handle the optional error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            // Unwrap the CKRecord that was saved
            guard let record = record,
                // Re-create the same Hype object from that record that we know was saved
                let savedHype = Hype(ckRecord: record)
                else { completion(false) ; return }
            print("Saved Hype: \(record.recordID.recordName) successfully")
            // Insert the successfully saved Hype object at the first index of our Source of Truth array
            self.hypes.insert(savedHype, at: 0)
            // Complete with success
            completion(true)
        }
    }
    
    /**
     Fetches all Hypes stored in the CKContainer's publicDataBase
     
     - Parameters:
        - completion: Escaping completion block for the method
        - success: Boolean value returned in the completion block indicating a success or failure on fetching the CKRecords from the database
     */
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        // Step 3 - Create the Predicate needed for the query parameters
        let predicate = NSPredicate(value: true)
        // Step 2 - Create the query needed for the perform(query) method
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        // Step 1 - Access the perform(query) method on the database
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            // Handle the optional error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            // Unwrap the found CKRecord objects
            guard let records = records else { completion(false) ; return }
            print("Fetched Hypes successfully")
            // Map through the found records, appling the Hype(ckRecord:) convenience init method as the transform
            var hypes = records.compactMap({ Hype(ckRecord: $0) })
            // Set the Source of Truth array
            hypes.sort(by: { $0.timestamp > $1.timestamp })
            self.hypes = hypes
            // Complete with success
            completion(true)
        }
    }
    
    // MARK: - Day 2 Changes
    // Need to add in CKRecord.ID onto the model for the modification operations
    
    /**
    Updates a Hype with changed keys.
     
     - Parameters:
        - hype: The Hype object that will be passed into the update operation
        - completion: Escaping completion block for the method
        - success: Boolean value indicating success or falure of the CKModifyRecordsOperation
     */
    func update(_ hype: Hype, completion: @escaping (_ success: Bool) -> Void) {
        // Step 2.a Create the record to save (update)
        let record = CKRecord(hype: hype)
        // Step 2 - Create the operation
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        // Step 3 - Adjust the properties for the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = records?.first else { completion(false) ; return }
            print("Updated \(record.recordID.recordName) successfully in CloudKit")
            completion(true)
        }
        // Step 1 - Add the operation to the database
        publicDB.add(operation)
    }
    
    /**
    Deletes a Hype with from the database
     
     - Parameters:
        - hype: The Hype object that will be passed into the delete operation
        - completion: Escaping completion block for the method
        - success: Boolean value indicating success or falure of the CKModifyRecordsOperation
     */
    func delete(_ hype: Hype, completion: @escaping (_ success: Bool) -> Void) {
        // Step 2 - Declare the operation
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [hype.recordID])
        // Step 3 - Set the properties on the operation
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = {records, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
            }
            
            if records?.count == 0 {
                print("Deleted record from CloudKit")
                completion(true)
            } else {
                print("Unaccounted records were returned when trying to delete")
                completion(false)
            }
        }
        // Step 1 - Add the operation to the database
        publicDB.add(operation)
    }
    
    /**
     Subscribes the device to receive remote notifications from changes made to the database
     
     - Parameters:
        - completion: Escaping completion block for the method
        - error: Optional error returned when saving the CKQuerySubscription to the database
     */
    func subscribeForRemoteNotifications(completion: @escaping (_ error: Error?) -> Void) {
        // Step 2 - Create the needed query to pass into the subscription
        let predicate = NSPredicate(value: true)
        // Step 1 - Create the CKQuerySubscription object
        let subscription = CKQuerySubscription(recordType: HypeStrings.recordTypeKey, predicate: predicate, options: .firesOnRecordCreation)
        
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
}

