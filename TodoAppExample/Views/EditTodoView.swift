import SwiftUI

// Binding<String?>을 Binding<String>으로 변환해주는 Extension
extension Binding where Value == String? {
    func nonOptional() -> Binding<String> {
        return Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}

struct EditTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var todo: Todo
    var viewModel: TodoViewModel

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter title here", text: $todo.title.nonOptional())
            }
            Section(header: Text("Content")) {
                TextEditor(text: $todo.content.nonOptional())
                    .frame(height: 200)
            }
        }
        .navigationTitle("Edit Todo")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    Task {
                        await viewModel.updateTodo(todo)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview

#Preview {
    // 1. Create an in-memory persistence controller for the preview
    let persistenceController = PersistenceController(inMemory: true)
    let context = persistenceController.container.viewContext

    // 2. Create a sample Todo object in the in-memory context
    let sampleTodo = Todo(context: context)
    sampleTodo.id = UUID()
    sampleTodo.title = "Preview Todo Title"
    sampleTodo.content = "This is some content for the preview."
    sampleTodo.createdAt = Date()

    // 3. Create a mock repository and view model
    class MockRepo: TodoRepository {
        func getTodos() async throws -> [Todo] { [] }
        func addTodo(title: String, content: String) async throws {}
        func updateTodo(_ todo: Todo) async throws { print("Preview: Save Tapped") }
        func deleteTodo(id: UUID) async throws {}
    }
    let viewModel = TodoViewModel(todoRepository: MockRepo())

    // 4. Return the view, wrapped in a NavigationView
    return NavigationView {
        EditTodoView(todo: sampleTodo, viewModel: viewModel)
            .environment(\.managedObjectContext, context)
    }
}