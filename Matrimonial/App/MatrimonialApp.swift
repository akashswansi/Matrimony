//
//  MatrimonialApp.swift
//  Matrimonial
//
//  Created by Akash Kumar on 29/09/25.
//

import SwiftUI

@main
struct MatrimonialApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      MatrimonyProfilesListView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
  }
}
