//
//  LocationAnnotation+CoreDataProperties.swift
//  PlayLocationService
//
//  Created by Wismin Effendi on 8/21/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import Foundation
import CoreData


extension LocationAnnotation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationAnnotation> {
        return NSFetchRequest<LocationAnnotation>(entityName: "LocationAnnotation")
    }

    @NSManaged public var annotation: NSObject?
    @NSManaged public var identifier: String?
    @NSManaged public var localUpdate: NSDate?
    @NSManaged public var title: String?

}
