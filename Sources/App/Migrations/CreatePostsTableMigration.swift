import Vapor
import FluentKit

struct CreatePostsTableMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("posts")
            .id()
            .field("title", .string, .required)
            .field("body", .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .field("deleted_at", .datetime)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("posts").delete()
    }
}