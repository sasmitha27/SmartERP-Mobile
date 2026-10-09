import AuthenticationServices
import SwiftData
import SwiftUI

struct CreateFirstUserView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isSignedIn: Bool
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(ERPTheme.blue)

            VStack(spacing: 8) {
                Text("Create Administrator")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                Text("Use the Apple Account signed in on this device to create the first SmartERP administrator.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }

            SignInWithAppleButton(.signUp) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                createAdministrator(from: result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)

            Text("Apple may let you share or hide your email address.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(ERPTheme.background)
    }

    private func createAdministrator(from result: Result<ASAuthorization, Error>) {
        do {
            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Apple Account authorization did not return a valid credential."
                return
            }

            let providedName = credential.fullName.map {
                PersonNameComponentsFormatter.localizedString(from: $0, style: .default)
            }
            let fullName = providedName?.isEmpty == false ? providedName! : "Administrator"
            let email = credential.email ?? ""
            let user = AppUser(
                appleUserIdentifier: credential.user,
                fullName: fullName,
                email: email
            )

            modelContext.insert(user)
            try modelContext.save()
            errorMessage = nil
            isSignedIn = true
        } catch let error as ASAuthorizationError where error.code == .canceled {
            errorMessage = nil
        } catch {
            modelContext.rollback()
            errorMessage = "The administrator account could not be created. Please try again."
        }
    }
}
