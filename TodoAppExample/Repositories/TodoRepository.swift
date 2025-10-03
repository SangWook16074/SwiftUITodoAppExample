import Foundation

protocol TodoRepository {
    func getTodos() async throws -> [Todo]
}

final class TodoRepositoryImpl : TodoRepository {
    func getTodos() async throws -> [Todo] {
        try await Task.sleep(for: .seconds(3))
        return [
            Todo(id: UUID(), title: "Todo 1", content: "Todo 1입니다."),
            Todo(id: UUID(), title: "Todo 2", content: "Todo 2입니다."),
            Todo(id: UUID(), title: "Todo 3", content: "Todo 3입니다."),
        ]
    }
}
