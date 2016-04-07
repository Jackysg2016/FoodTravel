//
//  Restaurant.swift
//  FoodTravel
//
//  Created by angelorlover on 16/3/10.
//  Copyright © 2016年 angelorlover. All rights reserved.
//

import Foundation
import CoreData

class Restaurant:NSManagedObject {
    @NSManaged var name : String
    @NSManaged var type : String
    @NSManaged var location : String
    @NSManaged var image : NSData?
    @NSManaged var phoneNumber : String?
    @NSManaged var isVisited : NSNumber?
    @NSManaged var rating : String?
    @NSManaged var animation : NSNumber?
}

