import SwiftUI

struct ReceivingDashboardView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                SectionTitle("Quick actions")
                quickActions
                SectionTitle("Recent activity")
                ContentUnavailableView(
                    "No recent activity",
                    systemImage: "clock.arrow.circlepath",
                    description: Text("Receiving activity will appear here when data is available.")
                )
            }
            .padding(24)
        }
        .navigationTitle("Receiving")
        .largeNavigationTitle()
    }

    private var quickActions: some View {
        HStack(spacing: 14) {
            NavigationLink {
                PurchaseOrdersView()
            } label: {
                ActionCard(title: "Purchase Orders", subtitle: "View orders", icon: "doc.text")
            }
            NavigationLink {
                InventoryView()
            } label: {
                ActionCard(title: "Inventory Search", subtitle: "Find products", icon: "magnifyingglass")
            }
        }
    }

}
