//
//  CoreDataStack.swift
//  To-Do App
//
//  Created by Wismin Effendi on 6/27/17.
//  Copyright © 2017 iShinobi. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    private let modelName: String
    
    private static var sharedInstance: CoreDataStack!
    
    private init(modelName: String) {
        self.modelName = modelName
        CoreDataStack.sharedInstance = self
    }
    
    // Note: model name can't be change, only the first time initialize the model, other times will be ignored. 
    public static func shared(modelName: String) -> CoreDataStack {
        switch (sharedInstance, modelName) {
        case let (nil, modelName):
            sharedInstance = CoreDataStack(modelName: modelName)
            return sharedInstance
        default:
            return sharedInstance
        }
    }
    
    
    lazy var storeContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PlayLocationService")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            print(NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).last! as String)

        })
        return container
    }()
    
    
    public lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    public func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}


