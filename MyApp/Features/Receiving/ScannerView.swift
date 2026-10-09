import SwiftUI

struct ScannerView: View {
    var body: some View {
        ContentUnavailableView(
            "No order selected",
            systemImage: "barcode.viewfinder",
            description: Text("Select a purchase order before scanning products.")
        )
        .navigationTitle("Scan Products")
        .largeNavigationTitle()
    }
}
