//
//  Contact+CoreDataClass.swift
//  Messaging
//
//  Created by Grant Maloney on 10/15/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Contact)
public class Contact: NSManagedObject {
    var modifiedDate: Date? {
        get {
            return time as Date?
        }
        set {
            time = newValue as NSDate?
        }
    }
    
    convenience init?(name: String?, message: String?, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Contact.entity(), insertInto: managedContext)
        self.name = name
        self.message = message
        
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.image = image.pngData() as NSData?
    }
    
    func update(name: String, message: String?, image: UIImage) {
        self.name = name
        self.message = message
        
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.image = image.pngData() as NSData?
    }
}
