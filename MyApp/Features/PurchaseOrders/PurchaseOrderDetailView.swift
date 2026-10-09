import SwiftUI

struct PurchaseOrderDetailView: View {
    let order: PurchaseOrder

    var body: some View {
        ContentUnavailableView(
            "No order details",
            systemImage: "doc.text.magnifyingglass",
            description: Text("Order details will appear when they are available.")
        )
        .navigationTitle(order.number)
        .largeNavigationTitle()
    }
}
