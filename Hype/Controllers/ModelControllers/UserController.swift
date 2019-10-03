//
//  UserController.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/26/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
import CloudKit
// MARK: - Day 3 Changes
// MARK: - Day 4 Changes
// Edit createUser to accomodate images
class UserController {
    
    static let shared = UserController()
    
    var currentUser: User?
    
    func createUserWith(_ username: String, profilePhoto: UIImage?, completion: @escaping (_ success: Bool) -> Void) {
        CloudKitManager.fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false) ; return }
            
            let newUser = User(username: username, appleUserReference: reference, profilePhoto: profilePhoto)
            
            let record = CKRecord(user: newUser)
            
            CloudKitManager.save(record) { (record) in
                
                guard let record = record,
                    let savedUser = User(ckRecord: record)
                    else { completion(false) ; return }
                
                self.currentUser = savedUser
                print("Saved User successfully")
                completion(true)
            }
        }
    }
    
    func fetchUser(completion: @escaping (_ success: Bool) -> Void) {
        CloudKitManager.fetchAppleUserReference { (reference) in
            guard let reference = reference else { completion(false) ; return }
            
            let predicate = NSPredicate(format: "%K == %@", argumentArray: [UserStrings.appleUserRefKey, reference])
            
            CloudKitManager.fetchRecordsOf(type: UserStrings.recordTypeKey, with: predicate) { (records) in
                
                guard let record = records?.first,
                    let foundUser = User(ckRecord: record)
                    else { completion(false) ; return }
                
                self.currentUser = foundUser
                print("Fetched User successfully")
                completion(true)
            }
        }
    }
    
    func fetchUserFor(_ hype: Hype, completion: @escaping (User?) -> Void) {
        guard let userID = hype.userReference?.recordID else { completion(nil) ; return }
        
        let predicate = NSPredicate(format: "%K == %@", argumentArray: ["recordID", userID])
        CloudKitManager.fetchRecordsOf(type: UserStrings.recordTypeKey, with: predicate) { (records) in
            guard let record = records?.first,
                let foundUser = User(ckRecord: record)
                else { completion(nil) ; return }
            print("User found for hype")
            completion(foundUser)
        }
    }
    
    func update(_ user: User, completion: @escaping (_ success: Bool) -> Void) {
        
    }
    
    func delete(_ user: User, completion: @escaping (_ success: Bool) -> Void) {
        
    }
}
