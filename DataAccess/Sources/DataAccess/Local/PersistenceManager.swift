//
//  PersistenceManager.swift
//
//
//  Created by Arturo Gamarra on 3/28/21.
//

import CoreData

public struct PersistenceManager {
    
    // MARK: - Singleton
    public static var shared: PersistenceManager?
    
    // MARK: - Properties
    private let container: NSPersistentContainer
    public let context: NSManagedObjectContext
    public var backgroundContext: NSManagedObjectContext {
        container.newBackgroundContext()
    }

    // MARK: - Constructors
    init(model: NSManagedObjectModel, inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        context = container.viewContext
    }
    
    // MARK: - Public
    public static func instance(inMemory: Bool = false) {
        guard let modelURL = Bundle.module.url(forResource:"Model", withExtension: "momd") else { return }
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return }
        
        shared = PersistenceManager(model: model, inMemory: inMemory)
    }
}
