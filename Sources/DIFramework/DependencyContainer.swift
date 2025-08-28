//
// DependencyContainer.swift
// DIFramework
//
// Created by TonnyTulliev on 28.08.2025.
// Copyright © 2025 PPR. All rights reserved.
//

import Foundation

/// IoC контейнер для регистрации и получения зависимостей
///
/// # Описание
/// Данный контейнер позволяет добиться соответствия принципам DIP и IoC
/// Сохраняет зарегистрированные зависимости в определенной области и позволяет получить экземпляр зависимости там, где это необходимо.
///
/// > Important:
/// > Все методы класса **Потокобезопасные**, и могут без проблем использоваться в асинхронных задачах
///
/// ## Создание контейнера
/// Есть несколько способов создать контейнер
///
/// ### Создать новый экземпляр контейнера с помощью инициализатора
/// Вы можете создать новый экземпляр контейнера используя стандартный инициализатор
///
/// ```swift
///    let container = DependencyContainer()
/// ```
/// Вы получите новый контейнер с чистым регистром
///
/// ### Глобальный экземпляр
/// Вы можете получить глобальный экземпляр контейнера через статическое свойство класса
///
/// ```swift
///    let container = DependencyContainer.global
/// ```
///  Этот экземпляр является **Синглтоном**
///
/// ### Скопировать существующий контейнер
///  Вы можете получить новый экземпляр с помощью копирования существующего экземпляра
///
/// ```swift
///    let newContainer = existingContainer.copy()
/// ```
/// Скопированный экземпляр содержит тот же регистр, что и исходный контейнер
///
///  ## Регистрация новой зависимости
/// Для регистрации зависимости вы должный использовать метод ``register(_:scope:tag:factory:)``
///
/// ```swift
///    let container = DependencyContainer()
///
///    container.register(Service.self, scope: .transient) {
///         ServiceImplementation()
///    }
/// ```
///
///  Это позволит сохранить зависимость в указаной области видимости
///  Для более подробной инфрмации по регистрации зависимостей обратитесь к документации по данному методу
///
///  ## Получение зависимости
///  Для получения зависимости вы должный использовать метод ``resolve(tag:)``
///
/// ```swift
///    let instance: Interface = container.resolve()
/// ```
///
///  Это позволяет получить зависимость из области видимости, которую указали при регистрации зависимости
///
///  > Warning:
///  > Данный метод возвращает неопциональный тип, в случае, если произошла попытка получения зависимости, которая не была ренее зарегистрирована, произойдет краш приложения
///
///  Для более подробной инфрмации по получению зависимостей обратитесь к документации по данному методу
///
final public class DependencyContainer {
    
    // Properties
    private lazy var registry: [DependencyKey: DependencyEntity] = [:]

    private let logPrefix = "DI"
    
    private let queue = DispatchQueue(label: "DI.queue", qos: .default, attributes: .concurrent)
    
    // MARK: - Initialization
    
    public init() {}
    
}

// MARK: - Register Methods

extension DependencyContainer {
    
    /// Регистрация новой зависимости с тегом (опционально)
    ///
    ///  # Пример использования
    ///
    ///    ```swift
    ///    let container = DependencyContainer()
    ///
    ///    container.register(Service.self, scope: .transient) {
    ///         ServiceImplementation()
    ///    }
    ///    ```
    ///  > Important:
    ///  > Данный метод **Потокобезопасный**, и может без проблем использоваться в асинхронных задачах
    ///
    ///
    /// - Parameters:
    ///   - serivce: Тип зависимости для регистрации
    ///   - scope: Область видимости, в которой будет сохранена зависимость
    ///   - tag: Уникальный идентификатор зависимости, который позволяет отличать ее от других с таким же типом
    ///   - factory: Клоужер, фиксирующий способ создания экземпляра зависимости
    ///

    public func register<DependencyType>(_ service: DependencyType.Type,
                                  scope: DependencyScope = .single,
                                  tag: (any DependencyTagLiteralType)? = nil,
                                  file: String = #file,
                                  line: Int = #line,
                                  factory: @escaping () -> DependencyType) {
        _register(service, scope: scope, tag: tag, file: file, line: line, factory: factory)
    }
    
    /// Регистрация новой зависимости с параметром
    public func register<DependencyType, Arg1>(_ service: DependencyType.Type,
                                  scope: DependencyScope = .single,
                                  tag: (any DependencyTagLiteralType)? = nil,
                                  file: String = #file,
                                  line: Int = #line,
                                  factory: @escaping (Arg1) -> DependencyType) {
        _register(service, scope: scope, tag: tag, file: file, line: line, factory: factory)
    }
    
    /// Регистрация новой зависимости
    private func _register<DependencyType, Arguments>(
        _ service: DependencyType.Type,
        scope: DependencyScope = .single,
        tag: (any DependencyTagLiteralType)? = nil,
        file: String = #file,
        line: Int = #line,
        factory: @escaping (Arguments) -> DependencyType
    ) {
        let key = DependencyKey(dependencyType: service as DIType,
                                argumentsType: Arguments.self,
                                tag: tag?.toDependencyTag,
                                file: file,
                                line: line)
        let entity = DependencyEntity(factory: factory, scope: scope)
        
        queue.sync {
            if registry[key] != nil {
                print("\(logPrefix) ⚠️ | The specified dependency was already registered earlier")
            } else {
                registry[key] = entity
                print("\(logPrefix) ℹ️ | Dependency \(service) has been registered successfully in \(scope.raw)")
            }
        }
    }
    
}

// MARK: - Resolve Methods

extension DependencyContainer {
    
    /// Получение экземпляра зависимости по тегу (опционально)
    ///
    ///  # Пример использования
    ///
    ///    ```swift
    ///    let instance: Interface = container.resolve()
    ///    ```
    ///  > Important:
    ///  > Данный метод **Потокобезопасный**, и может без проблем использоваться в асинхронных задачах
    ///
    ///  > Warning:
    ///  > Данный метод возвращает неопциональный тип, в случае, если произошла попытка получения зависимости, которая не была ренее зарегистрирована, произойдет краш приложения
    ///
    /// - Parameters:
    ///   - tag: Уникальный идентификатор зависимости, который позволяет отличать ее от других с таким же типом
    ///
    /// - Returns: Экземпляр зависимости указанного типа из зарегистрированной области видимости
    ///
    public func resolve<DependencyType>(tag: (any DependencyTagLiteralType)? = nil) -> DependencyType {
        queue.sync {
            _resolve(argument: ().self, tag: tag)
        }
    }
    
    public func resolve<DependencyType, Arg1>(arg: Arg1, tag: (any DependencyTagLiteralType)? = nil) -> DependencyType {
        queue.sync {
            _resolve(argument: arg, tag: tag)
        }
    }
    
    private func _resolve<DependencyType, Arg1>(argument: Arg1, tag: (any DependencyTagLiteralType)? = nil) -> DependencyType {
        queue.sync {
            typealias Factory = ((Arg1) -> DependencyType)
            let key = registry.foundKey(dependencyType: DependencyType.self,
                                        argumentsType: Arg1.self,
                                        tag: tag?.toDependencyTag)
            
            guard let key, let entity = registry[key] else {
                var errorMessage = "No registration for type: \"\(DependencyType.self)\""
                if let tag { errorMessage.append(" with tag: \"\(tag)\".") }
                
                let similarKeys = registry.foundKeysByType(dependencyType: DependencyType.self)
                
                if !similarKeys.isEmpty {
                    var additionalMessage = " But other entities of the same type were found"
                    
                    for similarKey in similarKeys {
                        additionalMessage.append("\nRegistration in file: \"\(similarKey.fileName)\" on line: <\(similarKey.line)>")
                        if let _tag = similarKey.tag { additionalMessage.append(" with tag: \"\(_tag)\"") }
                    }
                    
                    errorMessage.append(additionalMessage)
                }
                
                print("\(logPrefix) 🛑 | \(errorMessage)")
                fatalError("See log message above ⬆️")
            }
            
            switch entity.scope {
            case .single:
                if entity.instance == nil {
                    entity.instance = (entity.factory as! Factory)(argument)
                }
                
                guard let castedInstance = entity.instance as? DependencyType else {
                    print("\(logPrefix) 🛑 | Failed cast to \(DependencyType.self), check file: \(key.file), on line: \(key.line)")
                    fatalError("See log message above ⬆️")
                }
                
                return castedInstance
            case .transient:
                let object = (entity.factory as! Factory)(argument)
                return object
            }
        }
    }
    
}

// MARK: - Helpers

extension DependencyContainer {
    
    /// Получить копию контейнера со всеми сохраненными зависимостями
    public func copy() -> DependencyContainer {
        let newContainer = DependencyContainer()
        newContainer.registry = self.registry
        return newContainer
    }
    
    /// Глобальный экземпляр контейнера в оперативной памяти
    public static let global = DependencyContainer()
}
