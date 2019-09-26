//
//  User.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/26/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit
// MARK: - Day 3 Changes
/**
 UserStrings contains the String values for keys when setting values for CKRecords.
 */
struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let bioKey = "bio"
    static let appleUserRefKey = "appleUserRef"
}

class User {
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    
    /**
     Initializes a User object
     
     - Parameters:
        - username: String value for the User's username property
        - bio: String value for the User's bio property, set by default to an empty string
        - recordID: CKRecord.ID value for the User's recordID property, set by default to a uuidString
        - appleUserReference: CKRecord.Reference value for the User's appleUserRef property
     */
    init(username: String, bio: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserRef = appleUserReference
    }
}

extension User {
    /**
     Failable Convenience initilaizer to initialize Users from CKRecords
     
     - Parameters:
        - ckRecord: CKRecord containing Key/Value pairs to initailize a User object
     */
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference
            else { return nil }
        
        self.init(username: username, appleUserReference: appleUserRef)
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

extension CKRecord {
    convenience init(user: User) {
        self.init(recordType: UserStrings.recordTypeKey, recordID: user.recordID)
        setValuesForKeys([
            UserStrings.usernameKey : user.username,
            UserStrings.bioKey : user.bio,
            UserStrings.appleUserRefKey : user.appleUserRef
        ])
    }
}
