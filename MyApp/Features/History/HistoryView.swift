import SwiftUI

struct HistoryView: View {
    var body: some View {
        ContentUnavailableView(
            "No history",
            systemImage: "clock.arrow.circlepath",
            description: Text("Completed receiving activity will appear here.")
        )
        .navigationTitle("History")
    }
}
