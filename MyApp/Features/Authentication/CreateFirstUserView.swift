import AuthenticationServices
import SwiftData
import SwiftUI

struct CreateFirstUserView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isSignedIn: Bool
    @State private var errorMessage: String?
    @State private var isShowingEmailSignUp = false

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

            HStack {
                Divider()
                Text("or")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Divider()
            }

            Button("Create account with email", systemImage: "envelope") {
                isShowingEmailSignUp = true
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .frame(maxWidth: .infinity)

            Text("Use email if an Apple Account is unavailable.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .background(ERPTheme.background)
        .sheet(isPresented: $isShowingEmailSignUp) {
            EmailAdministratorView { fullName, email, password in
                createAdministrator(fullName: fullName, email: email, password: password)
            }
        }
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
            let fullName = providedName.flatMap { $0.isEmpty ? nil : $0 } ?? "Administrator"
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

    private func createAdministrator(fullName: String, email: String, password: String) -> Bool {
        let user = AppUser(fullName: fullName, email: email, password: password)
        modelContext.insert(user)

        do {
            try modelContext.save()
            errorMessage = nil
            isShowingEmailSignUp = false
            isSignedIn = true
            return true
        } catch {
            modelContext.rollback()
            errorMessage = "The administrator account could not be created. Please try again."
            return false
        }
    }
}

private struct EmailAdministratorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var errorMessage: String?

    let createAdministrator: (String, String, String) -> Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Administrator details") {
                    TextField("Full name", text: $fullName)
                        .textContentType(.name)
                    TextField("Email", text: $email)
                        .emailInputConfiguration()
                        .textContentType(.emailAddress)
                }

                Section("Password") {
                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)
                    SecureField("Confirm password", text: $passwordConfirmation)
                        .textContentType(.newPassword)
                    Text("Use at least 8 characters.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Create with Email")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        if !createAdministrator(fullName, email, password) {
                            errorMessage = "The account could not be created. Please try again."
                        }
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && email.contains("@")
            && password.count >= 8
            && password == passwordConfirmation
    }
}
