# DIFramework

Простой и мощный IoC (Inversion of Control) контейнер для Swift, который позволяет легко управлять зависимостями в проектах.

## Возможности

- ✅ Потокобезопасность
- ✅ Поддержка различных областей видимости (Single, Transient)
- ✅ Теги для различения зависимостей одного типа
- ✅ Детальные сообщения об ошибках
- ✅ Поддержка iOS 15+ и macOS 12+
- ✅ Swift Package Manager

## Установка

### Swift Package Manager

Добавьте в ваш `Package.swift`:

```swift
dependencies: [
    .package(url: "", from: "1.0.0")
]
```

Или добавьте через Xcode:
1. File → Add Package Dependencies
2. Введите URL репозитория
3. Выберите версию

## Использование

### Базовое использование

```swift
import DIFramework

// Создание контейнера
let container = DependencyContainer()

// Регистрация зависимости
container.register(ServiceProtocol.self, scope: .single) {
    ServiceImplementation()
}

// Получение зависимости
let service: ServiceProtocol = container.resolve()
```

### Глобальный контейнер

```swift
// Использование глобального экземпляра
DependencyContainer.global.register(NetworkService.self) {
    NetworkServiceImpl()
}

let networkService: NetworkService = DependencyContainer.global.resolve()
```

### Области видимости

```swift
// Singleton - один экземпляр на весь жизненный цикл
container.register(DatabaseService.self, scope: .single) {
    DatabaseServiceImpl()
}

// Transient - новый экземпляр при каждом запросе
container.register(TemporaryService.self, scope: .transient) {
    TemporaryServiceImpl()
}
```

### Использование тегов

```swift
// Регистрация с тегами
container.register(APIClient.self, tag: "production") {
    ProductionAPIClient()
}

container.register(APIClient.self, tag: "development") {
    DevelopmentAPIClient()
}

// Получение по тегу
let prodClient: APIClient = container.resolve(tag: "production")
let devClient: APIClient = container.resolve(tag: "development")
```

### Зависимости с параметрами

```swift
// Регистрация с параметром
container.register(UserService.self) { (userId: String) in
    UserServiceImpl(userId: userId)
}

// Получение с параметром
let userService: UserService = container.resolve(arg: "user123")
```

## Архитектура

Фреймворк состоит из следующих компонентов:

- `DependencyContainer` - основной контейнер для управления зависимостями
- `DependencyScope` - области видимости зависимостей
- `DependencyTag` - теги для различения зависимостей
- `DependencyKey` - внутренний ключ для хранения зависимостей
- `DependencyEntity` - внутреннее представление зависимости

## Требования

- iOS 15.0+
- macOS 12.0+
- Swift 5.9+
