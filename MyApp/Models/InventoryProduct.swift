import Foundation
import SwiftData

@Model
final class InventoryProduct {
    @Attribute(.unique) var sku: String
    var name: String
    var barcode: String
    var category: String
    var quantity: Int
    var createdAt: Date

    init(name: String, sku: String, barcode: String, category: String, quantity: Int) {
        self.name = name
        self.sku = sku
        self.barcode = barcode
        self.category = category
        self.quantity = quantity
        self.createdAt = .now
    }
}
