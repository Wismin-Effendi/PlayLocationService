//
//  TaskLocation.swift
//  PlayLocationService
//
//  Created by Wismin Effendi on 8/20/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import Foundation
import MapKit

class TaskLocation: NSObject, NSCoding, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    var subtitle: String? {
        return locationName
    }
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
    }
    
    // MARK: - NSCoding protocol
    // So that we could save this object as transformable in Core Data
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        locationName = aDecoder.decodeObject(forKey: "locationName") as! String
        coordinate = aDecoder.decodeObject(forKey: "coordinate") as! CLLocationCoordinate2D
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(locationName, forKey: "locationName")
        aCoder.encode(coordinate, forKey: "coordinate")
    }
    
    
}
