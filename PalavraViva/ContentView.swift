import SwiftUI

struct ContentView: View {
    @State private var viewModel = BibleViewModel()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Início", systemImage: "house.fill", value: 0) {
                HomeView(viewModel: viewModel)
            }

            Tab("Bíblia", systemImage: "book.fill", value: 1) {
                BibleBooksView(viewModel: viewModel)
            }

            Tab("Planos", systemImage: "checkmark.square.fill", value: 2) {
                PlansView()
            }

            Tab("Descubra", systemImage: "magnifyingglass", value: 3) {
                DiscoverView(viewModel: viewModel)
            }

            Tab("Você", systemImage: "person.circle.fill", value: 4) {
                ProfileView(viewModel: viewModel)
            }
        }
        .tint(Color(red: 0.95, green: 0.3, blue: 0.35))
    }
}

