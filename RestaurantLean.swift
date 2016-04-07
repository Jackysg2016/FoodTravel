//
//  RestaurantLean.swift
//  FoodTravel
//
//  Created by angelorlover on 16/3/20.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloud


class RestaurantLean {
    
    var restaurantId : String
    var name : String
    var type : String?
    var location : String
    var isLike : Bool
    var image : AVFile?
    var phoneNumber : Int?
    var isVisited : Bool?
    var rating : String?
    var season : String?
    
    init(restaurantId: String, name: String, type: String, location: String, isLike: Bool, image: AVFile!, phoneNumber: Int!, isVisited: Bool!, rating: String!, season: String!) {
        self.restaurantId = restaurantId
        self.name = name
        self.type = type
        self.location = location
        self.isLike = isLike
        self.image = image
        self.phoneNumber = phoneNumber
        self.isVisited = isVisited
        self.rating = rating
        self.season = season
    }
    
    init(avObject: AVObject) {
        self.restaurantId = avObject.objectId
        self.name = avObject["name"] as! String
        self.type = avObject["type"] as? String
        self.location = avObject["location"] as! String
        self.isLike = avObject["isLike"] as! Bool
        self.image = avObject["image"] as? AVFile
        self.phoneNumber = avObject["phoneNumber"] as? Int
        self.isVisited = avObject["isVisited"] as? Bool
        self.season = avObject["season"] as? String
    }
    
    func toAVObeject() -> AVObject {
        let avObject = AVObject(className: "Restaurant")
        avObject.objectId = restaurantId
        avObject["name"] = name
        avObject["type"] = type
        avObject["location"] = location
        avObject["isLike"] = isLike
        avObject["image"] = image
        avObject["phoneNumber"] = phoneNumber
        avObject["isVisited"] = isVisited
        avObject["rating"] = rating
        avObject["season"] = season
        return avObject
    }
    
}
