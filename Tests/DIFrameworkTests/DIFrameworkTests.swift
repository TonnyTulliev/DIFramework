import XCTest
@testable import DIFramework

final class DIFrameworkTests: XCTestCase {
    
    var container: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        container = DependencyContainer() // Чистый контейнер перед каждым тестом
    }
    
    override func tearDown() {
        container = nil                   // Очистка памяти
        super.tearDown()
    }
    
    // Проверяет, что singleton возвращает один экземпляр
    func testSingletonScope() {
        // Given
        container.register(TestService.self, scope: .single) {
            TestServiceImpl()
        }
        
        // When
        let instance1: TestService = container.resolve()
        let instance2: TestService = container.resolve()
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Singleton scope should return the same instance")
    }
    
    // Проверяет, что transient создает новые экземпляры
    func testTransientScope() {
        // Given
        container.register(TestService.self, scope: .transient) {
            TestServiceImpl()
        }
        
        // When
        let instance1: TestService = container.resolve()
        let instance2: TestService = container.resolve()
        
        // Then
        XCTAssertFalse(instance1 === instance2, "Transient scope should return different instances")
    }
    
    // Проверяет работу тэгов для разных реализаций
    func testTaggedDependencies() {
        // Given
        container.register(TestService.self, tag: "first") {
            TestServiceImpl(name: "First")
        }
        
        container.register(TestService.self, tag: "second") {
            TestServiceImpl(name: "Second")
        }
        
        // When
        let firstService: TestService = container.resolve(tag: "first")
        let secondService: TestService = container.resolve(tag: "second")
        
        // Then
        XCTAssertEqual(firstService.getName(), "First")
        XCTAssertEqual(secondService.getName(), "Second")
    }
    
    // Проверяет внедрение зависимостей с аргументами
    func testDependencyWithArguments() {
        // Given
        container.register(TestService.self) { (name: String) in
            TestServiceImpl(name: name)
        }
        
        // When
        let service: TestService = container.resolve(arg: "TestName")
        
        // Then
        XCTAssertEqual(service.getName(), "TestName")
    }
    
    // Проверяет глобальный контейнер (важно очищать в tearDown!)
    func testGlobalContainer() {
        // Given
        DependencyContainer.global.register(TestService.self) {
            TestServiceImpl(name: "Global")
        }
        
        // When
        let service: TestService = DependencyContainer.global.resolve()
        
        // Then
        XCTAssertEqual(service.getName(), "Global")
    }
    
    // Проверяет глубокое копирование контейнера
    func testContainerCopy() {
        // Given
        container.register(TestService.self) {
            TestServiceImpl(name: "Original")
        }
        
        // When
        let copiedContainer = container.copy()
        let service: TestService = copiedContainer.resolve()
        
        // Then
        XCTAssertEqual(service.getName(), "Original")
    }
}

// MARK: - Test Helpers

protocol TestService: AnyObject {
    func getName() -> String
}

class TestServiceImpl: TestService {
    private let name: String
    
    init(name: String = "Default") {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
}
