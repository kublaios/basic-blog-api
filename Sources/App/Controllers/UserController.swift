import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("users") { users in
            users.post(use: create)
            users.get(use: list)
            users.group(":user_id") { user in
                user.get(use: get)
                user.delete(use: delete)
            }
        }
    }

    private func create(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.create(on: req.db)
        return user
    }

    private func list(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

    private func get(req: Request) async throws -> User {
        let user = try await getUser(req: req)
        // TODO: Try to parameterize this
        _ = try await user.$posts.get(on: req.db)
        return user
    }

    private func delete(req: Request) async throws -> HTTPStatus {
        let user = try await getUser(req: req)
        let posts = try await user.$posts.get(on: req.db)
        if posts.count > 0 {
            throw Abort(.preconditionFailed)
        } else {
            try await user.delete(on: req.db)
            return .noContent
        }
    }

    private func getUser(req: Request) async throws -> User {
        guard let userId = req.parameters.get("user_id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        if let user = try await User.find(userId, on: req.db) {
            return user
        } else {
            throw Abort(.notFound)
        }
    }
}
