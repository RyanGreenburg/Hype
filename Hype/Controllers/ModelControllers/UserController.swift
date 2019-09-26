//
//  UserController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/26/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit
// MARK: - Day 3 Changes

class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
    let publicDB = CKContainer.default().publicCloudDatabase
    
    /**
     Creates a User and saves it to CloudKit
     
     - Parameters:
        - username: String value to pass into the User initializer
        - completion: Escaping completion block for the method
        - success: Boolean value indicating success or failure to save CKRecord to CloudKit
     */
    func createUserWith(_ username: String, completion: @escaping (_ success: Bool) -> Void) {
        fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false) ; return }
            
            let newUser = User(username: username, appleUserReference: reference)
            let record = CKRecord(user: newUser)
            self.publicDB.save(record) { (record, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                }
                
                guard let record = record else { completion(false) ; return }
                let savedUser = User(ckRecord: record)
                self.currentUser = savedUser
                print("Created User: \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    /**
     Fetches a User object from the publicDatabase
     
     - Parameters:
        - completion: Escaping completion block for the method
        - success: Boolean value indicating success or falure to fetch the object from CloudKit
     */
    func fetchUser(completion: @escaping (_ success: Bool) -> Void) {
        fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false) ; return }
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserRefKey, reference])
            let query = CKQuery(recordType: UserStrings.recordTypeKey, predicate: predicate)
            self.publicDB.perform(query, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    completion(false)
                }
                
                guard let record = records?.first else { completion(false) ; return }
                let foundUser = User(ckRecord: record)
                self.currentUser = foundUser
                print("Fetchec User: \(record.recordID.recordName) successfully")
                completion(true)
            }
        }
    }
    
    /**
     Fetches the recordID of the currently logged in AppleID User
     
     - Parameters:
        - completion: Escaping completion block for the method
        - reference: Optional reference for the found AppleID User
     */
    private func fetchAppleUserReference(completion: @escaping (_ reference: CKRecord.Reference?) -> Void) {

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
    
    func update(_ user: User, completion: @escaping (_ success: Bool) -> Void) {
        
    }
    
    func delete(_ user: User, completion: @escaping (_ success: Bool) -> Void) {
        
    }
}
