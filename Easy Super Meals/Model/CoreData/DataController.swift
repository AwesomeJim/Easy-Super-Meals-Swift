//
//  DataController.swift
//  Easy Super Meals
//
//  Created by James Mbugua on 22/02/2021.
//

import Foundation
import CoreData

//MARK:-Core data - Controller
class DataController {
    
    // MARK: Shared Instance
    static let shared = DataController(modelName: "SuperMealsRecipe")
    
    // MARK: Properties
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    let backgroundContext:NSManagedObjectContext!
    
    
    
    // MARK: DataController  Initializers
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    //MARK:-set configurations and mergging policy
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    
    //MARK:-Load the Core data
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    
    //MARK:-Fetch Recipe
    func fetchRecipe(_ predicate: NSPredicate, entityName: String, sorting: NSSortDescriptor? = nil) throws -> Recipe? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let recipe = (try DataController.shared.viewContext.fetch(fr) as! [Recipe]).first else {
            return nil
        }
        return recipe
    }
    
    
    
    /// save current context
    func save() {
        if DataController.shared.viewContext.hasChanges {
            do {
                try DataController.shared.viewContext.save()
            }catch {
                print("Error saving Context")
            }
        }
    }
    
}
