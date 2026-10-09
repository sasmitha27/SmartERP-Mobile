import SwiftUI
import SwiftData

struct InventoryView: View {
    @State private var search = ""
    @Query(sort: \InventoryProduct.name) private var products: [InventoryProduct]

    private var filteredProducts: [InventoryProduct] {
        guard !search.isEmpty else { return products }
        return products.filter {
            $0.name.localizedCaseInsensitiveContains(search)
                || $0.sku.localizedCaseInsensitiveContains(search)
                || $0.barcode.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        Group {
            if products.isEmpty {
                ContentUnavailableView(
                    "No inventory",
                    systemImage: "shippingbox",
                    description: Text("Tap + to create your first inventory product.")
                )
            } else if filteredProducts.isEmpty {
                ContentUnavailableView.search(text: search)
            } else {
                List(filteredProducts) { product in
                    NavigationLink {
                        ProductDetailView(
                            name: product.name,
                            sku: product.sku,
                            quantity: String(product.quantity),
                            state: product.quantity > 0 ? "In Stock" : "Out of Stock"
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.headline)
                            Text("\(product.sku) · \(product.quantity) pcs")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
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
