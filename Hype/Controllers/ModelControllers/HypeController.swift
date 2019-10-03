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
    /// Shared instance of HypeController class
    static let shared = HypeController()
    /// Source of Truth array of Hype objects
    var hypes: [Hype] = [] {
        didSet{
            self.hypes.sort(by: { $0.timestamp > $1.timestamp })
        }
    }
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
        // Call the cloudKitManager to save the record
        CloudKitManager.save(hypeRecord) { (record) in
            guard let record = record,
                let savedHype = Hype(ckRecord: record)
                else { completion(false) ; return }
            self.hypes.append(savedHype)
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
        CloudKitManager.fetchRecordsOf(type: HypeStrings.recordTypeKey, with: predicate) { (records) in
            guard let records = records else { completion(false) ; return }
            let foundHypes = records.compactMap { Hype(ckRecord: $0) }
            self.hypes = foundHypes
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
        CloudKitManager.update(record) { (record) in
            guard record != nil else { completion(false) ; return }
            completion(true)
        }
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
        let record = CKRecord(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        CloudKitManager.delete(record) { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
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
        CloudKitManager.addSubscription(of: HypeStrings.recordTypeKey, with: predicate) { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(error)
            }
            completion(nil)
        }
    }
}

