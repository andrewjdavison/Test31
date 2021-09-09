//
//  Test31App.swift
//  Test31
//
//  Created by Andrew Davison on 9/9/21.
//

import SwiftUI

@main
struct Test31App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
