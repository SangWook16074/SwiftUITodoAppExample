import SwiftUI

struct TodoListView : View {
    @ObservedObject var todoViewModel: TodoViewModel
    
    var body : some View {
        List {
            ForEach(todoViewModel.todos) { todo in
                VStack(alignment: .leading) {
                    Text(todo.title)
                        .font(.headline)
                    
                    Text(todo.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .task {
            await todoViewModel.getTodos()
        }
        .navigationTitle("Todo List")
    }
}

#Preview {
    TodoListView(todoViewModel: .init(todoRepository: TodoRepositoryImpl()))
}