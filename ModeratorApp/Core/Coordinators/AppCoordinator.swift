//
//  AppCoordinator.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI
import Swinject

class AppCoordinator: Coordinator {
    @Published var currentView: AnyView
    
    private let container: Resolver
    private var userListCoordinator: UserListCoordinator?
    
    init() {
        self.container = DIContainer.shared.container
        self.currentView = AnyView(EmptyView())
        start()
    }
    
    private func start() {
        showUserList()
    }
    
    private func showUserList() {
        userListCoordinator = UserListCoordinator(appCoordinator: self)
        currentView = AnyView(userListCoordinator!.currentView)
    }
}
