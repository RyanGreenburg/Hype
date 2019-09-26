//
//  HypeController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit

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
    func saveHype(with text: String, completion: @escaping (_ success: Bool) -> Void) {
        // Inititialize a Hype object with the text value passed in as a parameter
        let newHype = Hype(body: text)
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
            print("Saved Hype successfully")
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
            let hypes = records.compactMap({ Hype(ckRecord: $0) })
            // Set the Source of Truth array
            self.hypes = hypes
            // Complete with success
            completion(true)
        }
    }
}
