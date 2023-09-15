import Vapor
import FluentKit

final class Post: Model, Content {
    static var schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "body")
    var body: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Parent(key: "user_id")
    var user: User

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() {}

    init(title: String, userID: User.IDValue) {
        self.title = title
        self.$user.id = userID
    }
}
