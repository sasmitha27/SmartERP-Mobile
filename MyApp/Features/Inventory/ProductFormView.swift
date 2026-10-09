import SwiftUI

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var sku = ""
    @State private var barcode = ""
    @State private var category = "General"
    @State private var quantity = "0"

    var body: some View {
        Form {
            Section("Product details") {
                TextField("Product name", text: $name)
                TextField("SKU / Product Code", text: $sku)
                TextField("Barcode", text: $barcode)
                Picker("Category", selection: $category) {
                    Text("General").tag("General")
                    Text("Electronics").tag("Electronics")
                }
            }
            Section("Opening stock") {
                TextField("Quantity", text: $quantity)
                    .numericInputConfiguration()
            }
        }
        .navigationTitle("New Inventory Product")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(name.isEmpty || sku.isEmpty)
            }
        }
    }
}
