//
// DependencyEntity.swift
// DIFramework
//
// Created by TonnyTulliev on 28.08.2025.
// Copyright © 2025 PPR. All rights reserved.
//

import Foundation

// Type alias to expect a closure.
internal typealias FunctionType = Any

/// Класс для хранения информации о зависимости
internal class DependencyEntity {
    
    // Properties
    let factory: FunctionType
    let scope: DependencyScope
    
    var instance: DIInstance?
    
    // MARK: - Initialization
    
    init(factory: FunctionType, scope: DependencyScope) {
        self.factory = factory
        self.scope = scope
    }
}
