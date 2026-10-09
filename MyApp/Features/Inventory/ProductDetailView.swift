import SwiftUI

struct ProductDetailView: View {
    let name: String
    let sku: String
    let quantity: String
    let state: String

    var body: some View {
        Form {
            Section("Stock") {
                LabeledContent("Available", value: "\(quantity) pcs")
                LabeledContent("Status", value: state)
                LabeledContent("SKU", value: sku)
            }
            Section {
                NavigationLink("Adjust stock") {
                    Text("Stock adjustments are ready to be connected to your backend.")
                }
            }
        }
        .navigationTitle(name)
        .inlineNavigationTitle()
    }
}
