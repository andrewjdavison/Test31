//
//  Persistence.swift
//  Test31
//
//  Created by Andrew Davison on 9/9/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let newRegister = Register(context: viewContext)
        newRegister.id = UUID()
        
        for i in 0..<10 {
            let newLicence = Licence(context: viewContext)
            newLicence.id = UUID()
            newLicence.leasee = "Leasee \(i)"
            
            let newElement = Element(context: viewContext)
            newElement.id = UUID()
            newElement.desc = "Switch \(i)"
            newLicence.licenced = newElement
            
            newRegister.addToLicencedUsers(newLicence)
        }
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    func deleteAllObjectsInCoreData() {
   
        let entities = self.container.managedObjectModel.entities
        
        for entity in entities
        {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let managedObjects:[NSManagedObject] = try! self.container.viewContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for managedObject in managedObjects {
                self.container.viewContext.delete(managedObject)
            }
        }
        try! self.container.viewContext.save()
    }

    func initData() {
        
        deleteAllObjectsInCoreData()
        
        let viewContext = container.viewContext
        
        let newRegister = Register(context: viewContext)
        newRegister.id = UUID()
        
        for i in 0..<10 {
            let newLicence = Licence(context: viewContext)
            newLicence.id = UUID()
            newLicence.leasee = "Leasee \(i)"
            
            let newElement = Element(context: viewContext)
            newElement.id = UUID()
            newElement.desc = "Switch \(i)"
            newLicence.licenced = newElement
            
            newRegister.addToLicencedUsers(newLicence)
        }
    }
    

    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Test31")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
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
        })
    }
}
