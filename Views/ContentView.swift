import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var servicesTab: Int = 0
    @State private var productsTab: Int = 0
    
    var body: some View {
        ZStack {
            // Services Tab View
            if appState.mode == .services {
                ServicesTabView(selectedTab: $servicesTab)
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            
            // Products Tab View
            if appState.mode == .products {
                ProductsTabView(selectedTab: $productsTab)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: appState.mode)
    }
}

// MARK: - Services TabView

struct ServicesTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ServicesHomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)
            
            ServicesSearchView()
                .tabItem {
                    Label("Поиск", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            NotificationsView()
                .tabItem {
                    Label("Уведомления", systemImage: "bell.fill")
                }
                .badge(appState.notificationCount)
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(AppColor.primary)
    }
}

// MARK: - Products TabView

struct ProductsTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProductsHomeView()
                .tabItem {
                    Label("Главная", systemImage: "house.fill")
                }
                .tag(0)
            
            ProductsSearchView()
                .tabItem {
                    Label("Поиск", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            CartView()
                .tabItem {
                    Label("Корзина", systemImage: "cart.fill")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(3)
        }
        .tint(AppColor.primaryGreen)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
