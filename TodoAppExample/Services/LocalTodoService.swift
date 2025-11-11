import Foundation
import CoreData

protocol LocalTodoService {
    func getTodoItems() async throws -> [Todo]
    func addTodoItem(id: UUID, title: String, content: String) async throws
    func deleteTodoItem(id: UUID) async throws
    func updateTodoItem(id: UUID, newTitle: String, newContent: String) async throws
}

class LocalTodoServiceImpl: LocalTodoService {
    private let context: NSManagedObjectContext
    init(context: NSManagedObjectContext) { self.context = context }
    
    private func saveContext() throws {
        if context.hasChanges { try context.save() }
    }
    
}

extension LocalTodoServiceImpl {
    func getTodoItems() async throws -> [Todo] {
        try await context.perform {
            let fetchRequest = Todo.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            return try self.context.fetch(fetchRequest)
        }
    }
    
    func addTodoItem(id: UUID, title: String, content: String) async throws {
        try await context.perform {
            let newItem = Todo(context: self.context)
            newItem.id = id
            newItem.title = title
            newItem.content = content
            newItem.createdAt = Date()
            try self.saveContext()
        }
    }
    
    func deleteTodoItem(id: UUID) async throws {
        try await context.perform {
            let fetchRequest = Todo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            fetchRequest.fetchLimit = 1
            if let itemToDelete = try self.context.fetch(fetchRequest).first {
                self.context.delete(itemToDelete)
                try self.saveContext()
            }
        }
    }
    
    func updateTodoItem(id: UUID, newTitle: String, newContent: String) async throws {
        try await context.perform {
            let fetchRequest = Todo.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            fetchRequest.fetchLimit = 1
            if let itemToUpdate = try self.context.fetch(fetchRequest).first {
                itemToUpdate.title = newTitle
                itemToUpdate.content = newContent
                try self.saveContext()
            }
        }
    }
}
