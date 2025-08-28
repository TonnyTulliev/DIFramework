//
// DependencyKey.swift
// DIFramework
//
// Created by TonnyTulliev on 28.08.2025.
// Copyright © 2025 PPR. All rights reserved.
//

import Foundation

/// Структура для хранения ключа зависиости, по которому ее возможно найти в реестре контейнера зависимостей
internal struct DependencyKey {
    
    // Properties
    let dependencyType: DIType
    let argumentsType: Any.Type
    let tag: DependencyTag?
    
    let file: String
    let line: Int
    
    var fileName: String {
        let pathElements = file.split(separator: "/")
        return String(pathElements.last ?? "")
    }
    
    // MARK: - Initialization
    
    init(dependencyType: DIType,
         argumentsType: Any.Type,
         tag: DependencyTag?,
         file: String,
         line: Int) {
        self.dependencyType = dependencyType
        self.argumentsType = argumentsType
        self.tag = tag
        self.file = file
        self.line = line
    }
    
    init(dependencyType: DIType,
         argumentsType: Any.Type,
         tag: DependencyTag?) {
        self.dependencyType = dependencyType
        self.argumentsType = argumentsType
        self.tag = tag
        self.file = ""
        self.line = -1
    }
    
}

// MARK: - Hashable

extension DependencyKey: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(dependencyType))
        hasher.combine(ObjectIdentifier(argumentsType))
        hasher.combine(tag)
    }
    
    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        lhs.dependencyType == rhs.dependencyType &&
        lhs.argumentsType == rhs.argumentsType &&
        lhs.tag == rhs.tag
    }
    
}

// MARK: - Helper

extension Dictionary where Key == DependencyKey {
    
    func foundKey<DependencyType, Arguments>(dependencyType: DependencyType,
                                             argumentsType: Arguments.Type,
                                             tag: DependencyTag?) -> DependencyKey? {
        let key = DependencyKey(dependencyType: dependencyType as! DIType, argumentsType: argumentsType, tag: tag)
        let foundKey = keys.first(where: { $0 == key })
        return foundKey
    }
    
    func foundKeysByType<DependencyType>(dependencyType: DependencyType) -> [DependencyKey] {
        keys.filter { $0.dependencyType is DependencyType }
    }
}

