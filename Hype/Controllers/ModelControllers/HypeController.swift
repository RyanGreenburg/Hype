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
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let shared = HypeController()
    
    var hypes: [Hype] = []
    
    func saveHype(with text: String, completion: @escaping (Bool) -> Void) {
        let newHype = Hype(body: text)
        let hypeRecord = CKRecord(hype: newHype)
        publicDB.save(hypeRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                let savedHype = Hype(ckRecord: record)
                else { completion(false) ; return }
            print("Saved Hype successfully")
            self.hypes.insert(savedHype, at: 0)
            completion(true)
        }
    }
    
    func fetchAllHypes(completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            guard let records = records else { completion(false) ; return }
            print("Fetched Hypes successfully")
            let hypes = records.compactMap({ Hype(ckRecord: $0) })
            self.hypes = hypes
            completion(true)
        }
    }
}
