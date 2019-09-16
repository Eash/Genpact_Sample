//
//  PersistanceManager.swift
//  AppTest
//
//  Created by Ganesh Kumar on 15/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager{
    
    private init(){}
    static let shared = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Meals")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func save() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved Successfully")
//                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                let path = urls[urls.count-1] as URL
//                print("DBPath --------> \(path)")
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


//MARK: - CoreData
extension PersistenceManager{
    func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T]{
        
        let entityname = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        do{
            let fetchobj = try context.fetch(fetchRequest) as? [T]
            return fetchobj ?? [T]()
        }
        catch{
            print(error)
            return [T]()
        }
        
    }
    
    func fetch<T: NSManagedObject>(_ objectType: T.Type, mealId: String) -> [T]{
        
        let entityname = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        let predicate = NSPredicate(format: "mealId==%@", mealId)
        fetchRequest.predicate = predicate
        do{
            let fetchobj = try context.fetch(fetchRequest) as? [T]
            return fetchobj ?? [T]()
        }
        catch{
            print(error)
            return [T]()
        }
    }
    
    func delete<T: NSManagedObject>(_ objectType: T.Type, mealId: String) {
        let entityname = String(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityname)
        let predicate = NSPredicate(format: "mealId == %@", mealId)
        fetchRequest.predicate = predicate
        do{
            if let fetchobj = try context.fetch(fetchRequest) as? [NSManagedObject], fetchobj.count > 0{
                for obj in fetchobj{
                    context.delete(obj)
                }
            }
        }
        catch{
            print(error)
        }
    }
}
