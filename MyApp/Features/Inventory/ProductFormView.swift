import SwiftUI
import SwiftData

struct ProductFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var sku = ""
    @State private var barcode = ""
    @State private var category = "General"
    @State private var quantity = "0"
    @State private var saveError: String?

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
                    saveProduct()
                } label: {
                    Image(systemName: "checkmark")
                }
                .disabled(name.isEmpty || sku.isEmpty)
            }
        }
        .alert("Product could not be saved", isPresented: Binding(
            get: { saveError != nil },
            set: { if !$0 { saveError = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveError ?? "Please try again.")
        }
    }

    private func saveProduct() {
        let product = InventoryProduct(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            sku: sku.trimmingCharacters(in: .whitespacesAndNewlines),
            barcode: barcode.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            quantity: Int(quantity) ?? 0
        )

        modelContext.insert(product)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.delete(product)
            saveError = error.localizedDescription
        }
    }
}
