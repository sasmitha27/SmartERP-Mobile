import SwiftUI
import SwiftData

@main struct SmartERPMobileApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [AppUser.self, InventoryProduct.self])
    }
}
