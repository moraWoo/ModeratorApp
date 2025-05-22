//
//  Coordinator.swift
//  AppsHeroModPanel
//
//  Created by Ildar Khabibullin on 22.05.2025.
//

import SwiftUI

protocol Coordinator: ObservableObject {
    var currentView: AnyView { get }
}
