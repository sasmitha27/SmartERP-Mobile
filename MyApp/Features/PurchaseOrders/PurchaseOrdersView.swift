import SwiftUI

struct PurchaseOrdersView: View {
    @State private var search = ""

    var body: some View {
        ContentUnavailableView(
            "No purchase orders",
            systemImage: "doc.text",
            description: Text("Purchase orders will appear here when data is available.")
        )
        .navigationTitle("Purchase Orders")
        .searchable(text: $search, prompt: "Search purchase orders")
    }
}
