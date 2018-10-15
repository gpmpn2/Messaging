//
//  Contact+CoreDataProperties.swift
//  Messaging
//
//  Created by Grant Maloney on 10/15/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var message: String?
    @NSManaged public var image: NSData?
    @NSManaged public var time: NSDate?

}
