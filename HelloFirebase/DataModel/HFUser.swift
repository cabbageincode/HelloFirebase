//
//  HFUser.swift
//  HelloFirebase
//
//  Created by cabbage on 03/08/2017.
//  Copyright © 2017 cabbage. All rights reserved.
//

import UIKit

class HFUser: HFBaseModel {

    var token: String
    var name: String?
    var desc: String?
    
    init(token: String) {
        
        self.token = token;
        
        super.init()
    }
    
    convenience init(token:String, dict: NSDictionary) {
        
        self.init(token: token)
        
        self.name = dict.object(forKey: "name") as? String
        self.desc = dict.object(forKey: "desc") as? String
    }
    
    // MARK: - public
    override func toDictionary() -> [String : AnyObject] {
        
        var userDict = super.toDictionary()
        
        if name != nil {
            userDict["name"] = name! as AnyObject
        } else {
            userDict["name"] = "" as AnyObject
        }
        
        if desc != nil {
            userDict["desc"] = desc! as AnyObject
        } else {
            userDict["desc"] = "" as AnyObject
        }
        
        return userDict
    }
}
