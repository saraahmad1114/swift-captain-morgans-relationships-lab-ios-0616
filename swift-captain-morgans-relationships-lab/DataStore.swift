//
//  DataStore.swift
//  swift-captain-morgans-relationships-lab
//
//  Created by Flatiron School on 10/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore{
    
    var pirates: [Pirate] = []
    var ships: [Ship] = []
    var engines: [Engine] = []
    
    static let sharedDataStore = DataStore()
    private init() {}

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.first.test" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("swift_captain_morgans_relationships_lab", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    //The managedObjectContext was created, so you don't have to worry about that
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func fetchData () {
    
        var error:NSError? = nil
        
        let pirateRequest = NSFetchRequest(entityName: "Pirate")
        let shipRequest = NSFetchRequest(entityName: "Ship")
        let engineRequest = NSFetchRequest(entityName: "Engine")
        
        let pirateNameSorted = NSSortDescriptor(key: "name", ascending: true)
            pirateRequest.sortDescriptors = [pirateNameSorted]
        
        do{
            
            pirates = try managedObjectContext.executeFetchRequest(pirateRequest) as! [Pirate]
            ships = try managedObjectContext.executeFetchRequest(shipRequest) as! [Ship]
            engines = try managedObjectContext.executeFetchRequest(engineRequest) as! [Engine]
        
        }
        catch let nserror as NSError{
            error = nserror
            print("error: \(error)")
            pirates = []
            ships = []
            engines = []
        }
        if pirates.count == 0 {
            if ships.count == 0 || engines.count == 0 {
                generateTestData()
            }
        }
    }
    
    func generateTestData () {
    
        let pirateOne: Pirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: managedObjectContext) as! Pirate
        pirateOne.name = "pirateOne"
        
        let shipOne: Ship = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: managedObjectContext) as! Ship
        shipOne.name = "shipOne"
        
        let engineOne: Engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: managedObjectContext) as! Engine
        engineOne.propulsionType = "Solar Energy"
        
        pirateOne.ships?.insert(shipOne)
        shipOne.pirate = pirateOne
        shipOne.engine = engineOne
        
        let pirateTwo: Pirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: managedObjectContext) as! Pirate
        pirateTwo.name = "PirateTwo"
        
        let shipTwo: Ship = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: managedObjectContext) as! Ship
        shipTwo.name = "shipTwo"
        
        let engineTwo: Engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: managedObjectContext) as! Engine
        engineTwo.propulsionType = "Solar Energy"

        pirateTwo.ships?.insert(shipTwo)
        shipTwo.pirate = pirateTwo
        shipTwo.engine = engineTwo
        
        let pirateThree: Pirate = NSEntityDescription.insertNewObjectForEntityForName("Pirate", inManagedObjectContext: managedObjectContext) as! Pirate
        pirateThree.name = "PirateThree"
        
        let shipThree: Ship = NSEntityDescription.insertNewObjectForEntityForName("Ship", inManagedObjectContext: managedObjectContext) as! Ship
        shipThree.name = "shipThree"
        
        let engineThree: Engine = NSEntityDescription.insertNewObjectForEntityForName("Engine", inManagedObjectContext: managedObjectContext) as! Engine
        engineThree.propulsionType = "Solar Energy"
        
        pirateThree.ships?.insert(shipThree)
        shipThree.pirate = pirateThree
        shipThree.engine = engineThree
        
        saveContext()
        fetchData()
    
    }

}