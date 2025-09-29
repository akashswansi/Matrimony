//
//  MatrimonyLocalDataSource.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import Foundation
import CoreData

final class MatrimonyLocalDataSource: MatrimonyLocalDataSourceProtocol {
  private let context: NSManagedObjectContext

  init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
    self.context = context
  }

  func fetchAll() -> [MatrimonyProfileData] {
    let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]

    do {
      let entities = try context.fetch(request)
      return entities.map {
        MatrimonyProfileData(
          id: $0.id ?? UUID().uuidString,
          name: $0.fullName ?? "",
          age: Int($0.age),
          location: $0.location ?? "",
          imageUrl: $0.imageUrl ?? "",
          status: $0.status.flatMap(MatrimonyProfileStatus.init)
        )
      }
    } catch {
      // we can log error's
      print("Core Data fetch error:", error.localizedDescription)
      return []
    }
  }

  func save(profiles: [MatrimonyProfileData]) {
    for profile in profiles {
      let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
      request.predicate = NSPredicate(format: "id == %@", profile.id)
      request.fetchLimit = 1

      let existing = try? context.fetch(request).first

      let entity = existing ?? ProfileEntity(context: context)
      entity.id = profile.id
      entity.fullName = profile.name
      entity.age = Int16(profile.age)
      entity.location = profile.location
      entity.imageUrl = profile.imageUrl
      entity.status = profile.status?.rawValue
    }

    do {
      try context.save()
    } catch {
      // we can log error's
      print("Core Data save error:", error.localizedDescription)
    }
  }

  func updateStatus(profileID: String, status: MatrimonyProfileStatus) {
    let request: NSFetchRequest<ProfileEntity> = ProfileEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", profileID)
    request.fetchLimit = 1

    do {
      if let entity = try context.fetch(request).first {
        entity.status = status.rawValue
        try context.save()
      }
    } catch {
      // we can log error's
      print("Core Data status update error:", error.localizedDescription)
    }
  }
}
