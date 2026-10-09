import SwiftUI

struct MainTabView: View {
    @Binding var isSignedIn: Bool

    var body: some View {
        TabView {
            NavigationStack {
                PurchaseOrdersView()
                    .signOutToolbar(isSignedIn: $isSignedIn)
            }
            .tabItem { Label("Orders", systemImage: "list.bullet.rectangle") }

            NavigationStack {
                ReceivingDashboardView()
                    .signOutToolbar(isSignedIn: $isSignedIn)
            }
            .tabItem { Label("Receive", systemImage: "plus.circle.fill") }

            NavigationStack {
                InventoryView()
                    .signOutToolbar(isSignedIn: $isSignedIn)
            }
            .tabItem { Label("Inventory", systemImage: "magnifyingglass") }

            NavigationStack {
                HistoryView()
                    .signOutToolbar(isSignedIn: $isSignedIn)
            }
            .tabItem { Label("History", systemImage: "clock.arrow.circlepath") }

            NavigationStack {
                VisitsView()
                    .signOutToolbar(isSignedIn: $isSignedIn)
            }
            .tabItem { Label("Visits", systemImage: "mappin.and.ellipse") }
        }
    }
}

private struct SignOutToolbarModifier: ViewModifier {
    @Binding var isSignedIn: Bool

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sign Out", systemImage: "rectangle.portrait.and.arrow.right") {
                        isSignedIn = false
                    }
                }
            }
    }
}

private extension View {
    func signOutToolbar(isSignedIn: Binding<Bool>) -> some View {
        modifier(SignOutToolbarModifier(isSignedIn: isSignedIn))
    }
}
