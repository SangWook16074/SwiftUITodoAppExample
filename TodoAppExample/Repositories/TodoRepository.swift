import Foundation

protocol TodoRepository {
    func getTodos() async throws -> [Todo]
    func addTodo(title: String, content: String) async throws
    func updateTodo(_ todo: Todo) async throws
    func deleteTodo(id: UUID) async throws
}

final class TodoRepositoryImpl: TodoRepository {
    private let service: LocalTodoService
    init(service: LocalTodoService) { self.service = service }
}

extension TodoRepositoryImpl {
    func getTodos() async throws -> [Todo] {
        return try await service.getTodoItems()
    }

    func addTodo(title: String, content: String) async throws {
        let newId = UUID()
        try await service.addTodoItem(id: newId, title: title, content: content)
    }
    
    func updateTodo(_ todo: Todo) async throws {
        guard let id = todo.id else { return } 
        try await service.updateTodoItem(id: id, newTitle: todo.title ?? "", newContent: todo.content ?? "")
    }
    
    func deleteTodo(id: UUID) async throws {
        try await service.deleteTodoItem(id: id)
    }
}
