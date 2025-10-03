//
//  ContentView.swift
//  TodoAppExample
//
//  Created by 한상욱 on 10/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TodoViewModel(todoRepository: TodoRepositoryImpl())
    
    var body: some View {
        NavigationView {
            TodoListView(todoViewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
