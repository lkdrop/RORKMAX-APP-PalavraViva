import SwiftUI

struct ContentView: View {
    @State private var viewModel = BibleViewModel()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                HomeView(viewModel: viewModel)
            } label: {
                Label("Início", systemImage: selectedTab == 0 ? "house.fill" : "house")
            }

            Tab(value: 1) {
                BibleBooksView(viewModel: viewModel)
            } label: {
                Label("Bíblia", systemImage: selectedTab == 1 ? "book.fill" : "book")
            }

            Tab(value: 2) {
                PlansView()
            } label: {
                Label("Planos", systemImage: selectedTab == 2 ? "checkmark.square.fill" : "checkmark.square")
            }

            Tab(value: 3) {
                DiscoverView(viewModel: viewModel)
            } label: {
                Label("Descubra", systemImage: "magnifyingglass")
            }

            Tab(value: 4) {
                ProfileView(viewModel: viewModel)
            } label: {
                Label("Você", systemImage: selectedTab == 4 ? "person.circle.fill" : "person.circle")
            }
        }
        .tint(Color(red: 0.95, green: 0.3, blue: 0.35))
    }
}

