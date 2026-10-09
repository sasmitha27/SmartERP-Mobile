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
}
