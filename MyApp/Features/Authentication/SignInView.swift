import AuthenticationServices
import SwiftData
import SwiftUI

struct SignInView: View {
    @Query private var users: [AppUser]
    @Binding var isSignedIn: Bool
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(height: 64)
            header
            benefitCard
            Spacer()

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
            }

            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = []
            } onCompletion: { result in
                signIn(from: result)
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)

            Text("Uses the Apple Account signed in on this device.")
                .font(.caption)
                .foregroundStyle(ERPTheme.muted)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .background(ERPTheme.background)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("SmartERP")
                .font(.largeTitle.bold())
                .foregroundStyle(ERPTheme.navy)
            Text("Mobile warehouse operations")
                .font(.subheadline)
                .foregroundStyle(ERPTheme.muted)
        }
    }

    private var benefitCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Receive stock faster.")
                .font(.title3.bold())
                .foregroundStyle(ERPTheme.navy)
            Text("Scan products, verify purchase orders and create accurate GRNs directly from your iPhone.")
                .font(.subheadline)
                .foregroundStyle(ERPTheme.muted)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ERPTheme.paleBlue, in: .rect(cornerRadius: 22))
        .padding(.top, 38)
    }

    private func signIn(from result: Result<ASAuthorization, Error>) {
        do {
            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Apple Account authorization did not return a valid credential."
                return
            }

            guard users.contains(where: { $0.appleUserIdentifier == credential.user }) else {
                errorMessage = "This Apple Account is not registered with SmartERP."
                return
            }

            errorMessage = nil
            isSignedIn = true
        } catch let error as ASAuthorizationError where error.code == .canceled {
            errorMessage = nil
        } catch {
            errorMessage = "Sign in with Apple could not be completed. Please try again."
        }
    }
}
