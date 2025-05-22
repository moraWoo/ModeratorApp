//
//  ModeratorApp.swift
//  ModeratorApp
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import SwiftData

@main
struct ModeratorApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Address.self,
            Geo.self,
            Company.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

struct MainView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        coordinator.currentView
    }
}
