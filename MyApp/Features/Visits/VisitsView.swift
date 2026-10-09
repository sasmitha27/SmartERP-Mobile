import SwiftUI

struct VisitsView: View {
    var body: some View {
        ContentUnavailableView(
            "No visits scheduled",
            systemImage: "mappin.and.ellipse",
            description: Text("Supplier delivery visits will appear here.")
        )
        .navigationTitle("Visits")
    }
}
