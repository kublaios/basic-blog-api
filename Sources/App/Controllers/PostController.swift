import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("posts") { posts in
            posts.post(use: create)
            posts.get(use: list)
            posts.group(":post_id") { post in
                post.get(use: get)
                post.delete(use: delete)
            }
        }
    }

    private func create(req: Request) async throws -> Post {
        let post = try req.content.decode(Post.self)
        try await post.save(on: req.db)
        return post
    }

    private func list(req: Request) async throws -> [Post] {
        try await Post.query(on: req.db).all()
    }

    private func get(req: Request) async throws -> Post {
        guard let postId = req.parameters.get("post_id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        if let post = try await Post.find(postId, on: req.db) {
            return post
        } else {
            throw Abort(.notFound)
        }
    }

    private func delete(req: Request) async throws -> HTTPStatus {
        try await get(req: req).delete(on: req.db)
        return .noContent
    }
}
