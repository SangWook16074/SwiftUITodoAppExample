import Foundation
import Combine


class TodoViewModel : ObservableObject {
    private let todoRepository : TodoRepository
    
    @Published var todos : [Todo] = []
    
    init(todoRepository : TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    @MainActor
    public func getTodos() async {
        do {
            self.todos = try await todoRepository.getTodos()
        } catch {
            print("Error fetching todos: \(error)")
        }
    }
}
