import SwiftUI

enum ERPTheme {
    static let navy = Color(red: 14 / 255, green: 46 / 255, blue: 89 / 255)
    static let blue = Color(red: 10 / 255, green: 133 / 255, blue: 1)
    static let paleBlue = Color(red: 227 / 255, green: 242 / 255, blue: 1)
    static let ink = Color(red: 18 / 255, green: 23 / 255, blue: 38 / 255)
    static let muted = Color(red: 107 / 255, green: 115 / 255, blue: 130 / 255)

    #if os(iOS)
    static let background = Color(uiColor: .systemBackground)
    static let secondaryBackground = Color(uiColor: .secondarySystemBackground)
    #else
    static let background = Color(nsColor: .windowBackgroundColor)
    static let secondaryBackground = Color(nsColor: .controlBackgroundColor)
    #endif
}
