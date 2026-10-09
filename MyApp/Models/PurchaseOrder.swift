import Foundation

struct PurchaseOrder: Identifiable {
    let number: String
    let supplier: String
    let lines: Int
    let status: String

    var id: String { number }
}
