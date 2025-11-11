import Foundation
import Combine

class TodoViewModel : ObservableObject {
    private let todoRepository : TodoRepository
    
    @Published var todos : [Todo] = []
    
    init(todoRepository : TodoRepository) { self.todoRepository = todoRepository }
    
}

extension TodoViewModel {
    
    @MainActor
    public func getTodos() async {
        do {
            self.todos = try await todoRepository.getTodos()
        } catch {
            print("Error fetching todos: \(error)")
        }
    }
    
    @MainActor
    func addTodo(title: String, content: String) async {
        do {
            try await todoRepository.addTodo(title: title, content: content)
            await getTodos()
        } catch {
            print("Error adding todo: \(error)")
        }
    }
    
    @MainActor
    func deleteTodo(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { self.todos[$0] }
        
        Task {
            for item in itemsToDelete {
                guard let id = item.id else { continue }
                do {
                    try await todoRepository.deleteTodo(id: id)
                } catch {
                    print("Error deleting todo with id \(id): \(error)")
                }
            }
            await getTodos()
        }
    }

    @MainActor
    func updateTodo(_ todo: Todo) async {
        do {
            try await todoRepository.updateTodo(todo)
        } catch {
            print("Error updating todo: \(error)")
        }
    }
}
