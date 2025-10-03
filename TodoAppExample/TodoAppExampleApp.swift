import SwiftUI

@main
struct TodoAppExampleApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var viewModel: TodoViewModel

    init() {
        let context = persistenceController.container.viewContext
        let service = LocalTodoServiceImpl(context: context)
        let repository = TodoRepositoryImpl(service: service)
        _viewModel = StateObject(wrappedValue: TodoViewModel(todoRepository: repository))
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TodoListView(todoViewModel: viewModel)
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
