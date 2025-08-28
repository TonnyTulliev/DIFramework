//
// DependencyScope.swift
// DIFramework
//
// Created by TonnyTulliev on 28.08.2025.
// Copyright © 2025 PPR. All rights reserved.
//

import Foundation

/// Тип контекста, в котором будет храниться зависимость
public enum DependencyScope {
    
    /// Контекст, который сохраняет единственный экземпляр зарегистрированной зависимости, и отдает ее при запросе экземпляра
    case single
    
    /// Контекст, который сохраняет способ получения экземпляра, и отдает всегда новый экземпляр при каждом запросе экземпляра зависимости
    case transient
    
    var raw: String {
        switch self {
        case .single:       return "Single scope"
        case .transient:    return "Transient scope"
        }
    }
}
