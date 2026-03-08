import SwiftUI

struct ContentView: View {
    @State private var viewModel = BibleViewModel()
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Início", systemImage: "house.fill")
                }
                .tag(0)

            BibleBooksView(viewModel: viewModel)
                .tabItem {
                    Label("Bíblia", systemImage: "book.fill")
                }
                .tag(1)

            PlansView()
                .tabItem {
                    Label("Planos", systemImage: "checkmark.square.fill")
                }
                .tag(2)

            DiscoverView(viewModel: viewModel)
                .tabItem {
                    Label("Descubra", systemImage: "magnifyingglass")
                }
                .tag(3)

            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("Você", systemImage: "person.circle.fill")
                }
                .tag(4)
        }
        .tint(Color(red: 0.95, green: 0.3, blue: 0.35))
    }
}
