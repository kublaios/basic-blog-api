import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    // TODO: Validation
    @Field(key: "name")
    var name: String

    // TODO: Validation
    @Field(key: "email")
    var email: String

    // TODO: Implement proper auth
    @Field(key: "password_hash")
    var passwordHash: String

    @Children(for: \.$user)
    var posts: [Post]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}

    init(name: String, email: String, passwordHash: String) {
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }
}