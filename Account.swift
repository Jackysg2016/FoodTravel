//
//  Account.swift
//  FoodTravel
//
//  Created by angelorlover on 16/3/23.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import Foundation
import AVOSCloud

class Account {
    
    var username : String
    var password : String
    var image : AVFile?
    var accountId : String
    
    init(username: String, password: String, accountId: String, image: AVFile!) {
        self.username = username
        self.password = password
        self.accountId = accountId
        self.image = image
    }
    
    init(avObject: AVObject) {
        self.accountId = avObject.objectId
        self.username = avObject["username"] as! String
        self.password = avObject["password"] as! String
        self.image = avObject["image"] as? AVFile
    }
    
    func toAVObeject() -> AVObject {
        let avObject = AVObject(className: "Account")
        avObject.objectId = accountId
        avObject["username"] = username
        avObject["password"] = password
        avObject["image"] = image
        return avObject
    }

    
}
