import CryptoKit
import Foundation
import SwiftData

@Model
final class AppUser {
    @Attribute(.unique) var email: String
    @Attribute(.unique) var appleUserIdentifier: String?
    var fullName: String
    var role: String
    var passwordHash: String?
    var passwordSalt: String?
    var createdAt: Date

    init(appleUserIdentifier: String, fullName: String, email: String, role: String = "Administrator") {
        self.appleUserIdentifier = appleUserIdentifier
        self.fullName = fullName
        self.email = email
        self.role = role
        self.passwordSalt = nil
        self.passwordHash = nil
        self.createdAt = .now
    }

    init(fullName: String, email: String, password: String, role: String = "Administrator") {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let salt = UUID().uuidString

        self.appleUserIdentifier = nil
        self.fullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = normalizedEmail
        self.role = role
        self.passwordSalt = salt
        self.passwordHash = Self.hash(password: password, salt: salt)
        self.createdAt = .now
    }

    func validates(password: String) -> Bool {
        guard let passwordSalt, let passwordHash else { return false }
        return Self.hash(password: password, salt: passwordSalt) == passwordHash
    }

    private static func hash(password: String, salt: String) -> String {
        let digest = SHA256.hash(data: Data("\(salt):\(password)".utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
