//
//  TodoRow.swift
//  TodoAppExample
//
//  Created by 한상욱 on 11/11/25.
//



import SwiftUI
import Foundation

extension Todo {
    var createAtLabel: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return createdAt != nil ? dateFormatter.string(from: createdAt!) : ""
        }
    }
}

struct TodoRow : View {
    let todo : Todo
    var body : some View {
        
        HStack {
            Image("checkmark")
                .foregroundColor(Color.green)
                .font(.title)
                
            
            VStack(alignment: .leading) {
                
                
                
                Text(todo.title ?? "Untitled")
                    .font(.headline)
                Text(todo.content ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(todo.createAtLabel)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        

    }
}

#Preview {
    
    let persistenceController = PersistenceController(inMemory: true)
    let context = persistenceController.container.viewContext
    
    let tTodo = Todo(context: context)
    tTodo.id = UUID()
    tTodo.title = "hello"
    tTodo.content = "This is Test"
    tTodo.createdAt = Date()
    
    return TodoRow(todo: tTodo).environment(\.managedObjectContext, context)
    
}
