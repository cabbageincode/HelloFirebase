//
//  HFFirebaseDataManager.swift
//  HelloFirebase
//
//  Created by cabbage on 04/08/2017.
//  Copyright © 2017 cabbage. All rights reserved.
//

import UIKit
import Firebase


class HFFirebaseDataManager: NSObject {
    
    struct HFError: Error {
        
        enum HFDataErrorType {
            case HFDataError_NotExist
            case HFDataError_FetchError
        }
        
        let errorCode: HFDataErrorType
        
        init(code: HFDataErrorType) {
            
            self.errorCode = code
        }
    }

    private static var kShareInstance: HFFirebaseDataManager!
    
    private static let kDataKeyUser = "Users"
    
    private var ref: DatabaseReference = Database.database().reference()
    
    // MARK: public
    static func sharedInstance() -> HFFirebaseDataManager {
        
        guard kShareInstance == nil else {
            return kShareInstance!
        }
        
        kShareInstance = HFFirebaseDataManager()
        return kShareInstance
    }
    
    func saveUser(newUser: HFUser) -> Void {
        
        let newUserPath = HFFirebaseDataManager.kDataKeyUser + "/" + newUser.token
        self.ref.child(newUserPath).setValue(newUser.toDictionary()) { (error, databaseRef) in
            
            guard error == nil else {
                print("save user error: \(error.debugDescription)")
                return
            }
        }
    }
    
    func getUser(token: String!, completion completionblock: @escaping((HFUser?, HFError?) -> Void)) {
        
        self.ref.child(HFFirebaseDataManager.kDataKeyUser).child(token).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("not dict? >> \(snapshot.value.debugDescription)")
                let error =  HFError(code: .HFDataError_NotExist)
                completionblock(nil, error)
                return
            }
            
            let user = HFUser(token: token, dict: value)
            completionblock(user, nil)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
