import SwiftUI

struct TodoListView : View {
    @ObservedObject var todoViewModel: TodoViewModel
    @State private var showingAddTodoView = false

    var body : some View {
        List {
            ForEach(todoViewModel.todos) { todo in
                NavigationLink(destination: EditTodoView(todo: todo, viewModel: todoViewModel)) {
                    VStack(alignment: .leading) {
                        Text(todo.title ?? "Untitled")
                            .font(.headline)
                        
                        Text(todo.content ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: todoViewModel.deleteTodo)
        }
        .task {
            await todoViewModel.getTodos()
        }
        .navigationTitle("Todo List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTodoView = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTodoView) {
            AddTodoView(viewModel: todoViewModel)
        }
    }
}

// MARK: - Preview

#Preview {
    // 1. Create an in-memory persistence controller for the preview
    let persistenceController = PersistenceController(inMemory: true)
    let context = persistenceController.container.viewContext

    // 2. Create a few sample Todo objects
    let todo1 = Todo(context: context)
    todo1.title = "Buy groceries"
    todo1.content = "Milk, Bread, Cheese"
    todo1.createdAt = Date()

    let todo2 = Todo(context: context)
    todo2.title = "Walk the dog"
    todo2.content = "30 minutes in the park"
    todo2.createdAt = Date().addingTimeInterval(-3600)

    let todo3 = Todo(context: context)
    todo3.title = "Finish SwiftUI project"
    todo3.content = "Implement the preview feature"
    todo3.createdAt = Date().addingTimeInterval(-7200)

    // 3. Create a mock repository that returns these items
    class MockRepoWithData: TodoRepository {
        let todos: [Todo]
        init(todos: [Todo]) { self.todos = todos }
        func getTodos() async throws -> [Todo] { return todos }
        func addTodo(title: String, content: String) async throws {}
        func updateTodo(_ todo: Todo) async throws {}
        func deleteTodo(id: UUID) async throws {}
    }
    
    let viewModel = TodoViewModel(todoRepository: MockRepoWithData(todos: [todo1, todo2, todo3]))

    // 4. Return the view
    return NavigationView {
        TodoListView(todoViewModel: viewModel)
            .environment(\.managedObjectContext, context)
    }
}
