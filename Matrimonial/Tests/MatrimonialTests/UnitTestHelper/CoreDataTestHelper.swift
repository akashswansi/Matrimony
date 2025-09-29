//
//  CoreDataTestHelper.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//
import CoreData

enum CoreDataTestHelper {
  static func makeInMemoryContext(modelName: String = "MatrimonyCoreDataModel") -> NSManagedObjectContext {
    let container = NSPersistentContainer(name: modelName)
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    container.persistentStoreDescriptions = [description]

    var loadError: Error?
    container.loadPersistentStores { _, error in
      loadError = error
    }

    if let error = loadError {
      print("Failed to load in-memory persistent store: \(error)")
    }

    return container.viewContext
  }
}
