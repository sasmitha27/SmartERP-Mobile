import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("smartERP.isSignedIn") private var isSignedIn = false
    @Query private var users: [AppUser]

    var body: some View {
        Group {
            if users.isEmpty {
                CreateFirstUserView(isSignedIn: $isSignedIn)
            } else if isSignedIn {
                MainTabView(isSignedIn: $isSignedIn)
            } else {
                SignInView(isSignedIn: $isSignedIn)
            }
        }
        .tint(ERPTheme.blue)
    }
}

#Preview {
    ContentView()
}
