//
//  Task+CoreDataProperties.swift
//  PlayLocationService
//
//  Created by Wismin Effendi on 8/21/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var completed: Bool
    @NSManaged public var rangking: Int32
    @NSManaged public var note: String?
    @NSManaged public var locationAnnotation: NSObject?
    @NSManaged public var identifier: String?

}
