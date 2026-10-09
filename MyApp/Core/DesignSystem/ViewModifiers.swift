import SwiftUI

extension View {
    func erpField() -> some View {
        padding(.horizontal, 14)
            .frame(height: 50)
            .background(ERPTheme.background, in: .rect(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(red: 219 / 255, green: 222 / 255, blue: 229 / 255))
            }
    }

    @ViewBuilder
    func emailInputConfiguration() -> some View {
        #if os(iOS)
        textInputAutocapitalization(.never).keyboardType(.emailAddress)
        #else
        self
        #endif
    }

    @ViewBuilder
    func numericInputConfiguration() -> some View {
        #if os(iOS)
        keyboardType(.numberPad)
        #else
        self
        #endif
    }

    @ViewBuilder
    func largeNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.large)
        #else
        self
        #endif
    }

    @ViewBuilder
    func inlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}
