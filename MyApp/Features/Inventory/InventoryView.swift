import SwiftUI

struct InventoryView: View {
    @State private var search = ""

    var body: some View {
        ContentUnavailableView(
            "No inventory",
            systemImage: "shippingbox",
            description: Text("Products will appear here when inventory data is available.")
        )
        .navigationTitle("Inventory")
        .searchable(text: $search, prompt: "Search inventory")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    ProductFormView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
