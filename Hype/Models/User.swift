//
//  User.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/26/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit
import CloudKit
// MARK: - Day 3 Changes

struct UserStrings {
    static let recordTypeKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let bioKey = "bio"
    static let appleUserRefKey = "appleUserRef"
    fileprivate static let photoAssetKey = "photoAsset"
}

class User {
    var username: String
    var bio: String
    var recordID: CKRecord.ID
    var appleUserRef: CKRecord.Reference
    var profilePhoto: UIImage? {
        get {
            guard let photoData = self.photoData else { return nil }
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    
    var photoData: Data?
    
    var photoAsset: CKAsset {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    
    init(username: String, bio: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserReference: CKRecord.Reference, profilePhoto: UIImage? = nil) {
        self.username = username
        self.bio = bio
        self.recordID = recordID
        self.appleUserRef = appleUserReference
        self.profilePhoto = profilePhoto
    }
}

extension User {
    convenience init?(ckRecord: CKRecord) {
        guard let username = ckRecord[UserStrings.usernameKey] as? String,
            let appleUserRef = ckRecord[UserStrings.appleUserRefKey] as? CKRecord.Reference
            else { return nil }
        
        var foundPhoto: UIImage?
        if let photoAsset = ckRecord[UserStrings.photoAssetKey] as? CKAsset {
            do {
                let data = try Data(contentsOf: photoAsset.fileURL!)
                foundPhoto = UIImage(data: data)
            } catch {
                print("Could not transform asset to data")
            }
        }
        
        
        self.init(username: username, bio: "", recordID: ckRecord.recordID, appleUserReference: appleUserRef, profilePhoto: foundPhoto)
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
            UserStrings.appleUserRefKey : user.appleUserRef,
            UserStrings.photoAssetKey : user.photoAsset
        ])
    }
}
