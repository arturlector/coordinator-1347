//
//  CoreDataService.swift
//  swiftui-1347
//
//  Created by Artur Igberdin on 02.11.2021.
//

import Foundation
import CoreData

class CoreDataService {
    
    private let modelName: String
    var context: NSManagedObjectContext { storeContainer.viewContext }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    func saveContext() throws {
        guard context.hasChanges else { return }
        try context.save()
    }
}
