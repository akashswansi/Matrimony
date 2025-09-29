//
//  Persistence.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import CoreData
import Combine

final class PersistenceController: ObservableObject {
  enum StoreType {
    case persistent
    case inMemory
  }
  
  // MARK: - Shared Singleton
  static let shared = PersistenceController(storeType: .persistent)
  
  // MARK: - Properties
  let container: NSPersistentContainer
  @Published var initializationError: Error?
  
  // Use lazy to avoid init ordering issues
  lazy var contextDidSavePublisher: AnyPublisher<Notification, Never> = {
    NotificationCenter.default
      .publisher(for: .NSManagedObjectContextDidSave, object: container.viewContext)
      .eraseToAnyPublisher()
  }()
  
  // MARK: - Private Initializer
  private init(storeType: StoreType) {
    container = NSPersistentContainer(name: "MatrimonyCoreDataModel")
    
    switch storeType {
    case .inMemory:
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      container.persistentStoreDescriptions = [description]
      
    case .persistent:
      guard let description = container.persistentStoreDescriptions.first else {
        print("No persistent store descriptions found")
        return
      }
      description.shouldMigrateStoreAutomatically = true
      description.shouldInferMappingModelAutomatically = true
    }
    
    container.loadPersistentStores { _, error in
      if let error = error {
        DispatchQueue.main.async {
          self.initializationError = error
        }
      } else {
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      }
    }
  }
  
  // MARK: - Save Helper
  func saveContext() {
    let context = container.viewContext
    guard context.hasChanges else { return }
    do {
      try context.save()
    } catch {
      print("Core Data save error:", error.localizedDescription)
    }
  }
}
