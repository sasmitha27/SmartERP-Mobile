import AuthenticationServices
import SwiftData
import SwiftUI

struct SignInView: View {
    @Query private var users: [AppUser]
    @Binding var isSignedIn: Bool
    @State private var errorMessage: String?
    @State private var isShowingEmailSignIn = false

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

            HStack {
                Divider()
                Text("or")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Divider()
            }
            .padding(.vertical, 12)

            Button("Sign in with email", systemImage: "envelope") {
                isShowingEmailSignIn = true
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .frame(maxWidth: .infinity)

            Text("Choose the method used when your account was created.")
                .font(.caption)
                .foregroundStyle(ERPTheme.muted)
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .background(ERPTheme.background)
        .sheet(isPresented: $isShowingEmailSignIn) {
            EmailSignInView { email, password in
                signIn(email: email, password: password)
            }
        }
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

    private func signIn(email: String, password: String) -> Bool {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let user = users.first(where: { $0.email == normalizedEmail }),
              user.validates(password: password) else {
            errorMessage = "The email or password is incorrect."
            return false
        }

        errorMessage = nil
        isShowingEmailSignIn = false
        isSignedIn = true
        return true
    }
}

private struct EmailSignInView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    let signIn: (String, String) -> Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .emailInputConfiguration()
                        .textContentType(.username)
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Sign In with Email")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sign In") {
                        if !signIn(email, password) {
                            errorMessage = "The email or password is incorrect."
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty)
                }
            }
        }
    }
}
