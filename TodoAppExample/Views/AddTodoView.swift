import SwiftUI

struct AddTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: TodoViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title here", text: $title)
                }
                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
            }
            .navigationTitle("New Todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.addTodo(title: title, content: content)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview

fileprivate class MockTodoRepositoryForAdd: TodoRepository {
    func getTodos() async throws -> [Todo] { [] }
    func addTodo(title: String, content: String) async throws { print("Mock: Added new todo with title '\(title)'") }
    func updateTodo(_ todo: Todo) async throws {}
    func deleteTodo(id: UUID) async throws {}
}

#Preview {
    AddTodoView(viewModel: TodoViewModel(todoRepository: MockTodoRepositoryForAdd()))
}