//
// DependencyTag.swift
// DIFramework
//
// Created by TonnyTulliev on 28.08.2025.
// Copyright © 2025 PPR. All rights reserved.
//

import Foundation

public protocol DependencyTagLiteralType: Hashable {
    
    var toDependencyTag: DependencyTag { get }
}

/// Тег, с которым регистрируется зависимость, позволяющий различать разные зависимости с одинаковым типом
public enum DependencyTag: DependencyTagLiteralType {
    case integer(IntegerLiteralType)
    case string(StringLiteralType)
    
    public var toDependencyTag: DependencyTag { self }
}

/// Расширение для целочислового литерала, позволяющее использовать его в качестве тега для регистрации зависимости
extension IntegerLiteralType: DependencyTagLiteralType {
    
    public var toDependencyTag: DependencyTag { .integer(self) }
}

/// Расширение для строкового литерала, позволяющее использовать его в качестве тега для регистрации зависимости
extension StringLiteralType: DependencyTagLiteralType {
    
    public var toDependencyTag: DependencyTag { .string(self) }
}
