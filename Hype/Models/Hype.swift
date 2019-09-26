//
//  Hype.swift
//  Hype
//
//  Created by RYAN GREENBURG on 9/25/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CloudKit
// MARK: - Magic Strings
/**
 HypeStrings contains the String values for keys when setting values for CKRecords.
 */
struct HypeStrings {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
}

// MARK: - Class Declaration
class Hype {
    /// String value of the Hype text
    var body: String
    /// Date value of when the hype was created
    var timestamp: Date
    // MARK: - Day 2 Changes
    // Add CKRecord property and incorporate it into Designated Init, Failable Init, and CKRecord Extension
    /// The ID of the Hype object's CKRecord
    var recordID: CKRecord.ID
    
    /**
    Initializes a Hype object
     
     - Parameters:
        - body: String value for the Hype's body property
        - timestamp: Date value for the Hype's timestamp property, set with a default value of Date()
     */
    init(body: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.body = body
        self.timestamp = timestamp
        self.recordID = recordID
    }
}

// MARK: - Extension for Convenience Init
extension Hype {
    /**
     Convenience Failable Initializer to initialize Hypes stored in CloudKit
     
     - Parameters:
        - ckRecord: The CKRecord object containing the Key/Value pairs of the Hype object stored in CloudKit
     */
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
            let timestamp = ckRecord[HypeStrings.timestampKey] as? Date
            else { return nil }
        self.init(body: body, timestamp: timestamp, recordID: ckRecord.recordID)
    }
}

// MARK: - CKRecord Extension
extension CKRecord {
    /**
     Convenience Initializer to create a CKRecord from a Hype object
     
     - Parameters:
        - hype: The Hype object to set Key/Value pairs for inside the CKRecord object
     */
    convenience init(hype: Hype) {
        self.init(recordType: HypeStrings.recordTypeKey, recordID: hype.recordID)
        
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
        ])
        
//        self.setValue(hype.body, forKey: HypeStrings.bodyKey)
//        self.setValue(hype.timestamp, forKey: HypeStrings.timestampKey)
    }
}

// MARK: - Day 2 Changes
// MARK: - Equatable
extension Hype: Equatable {
    static func == (lhs: Hype, rhs: Hype) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}
