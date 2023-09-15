import Vapor

func routes(_ app: Application) throws {
    app.get { (req: Request) throws -> HTTPStatus in
        throw Abort(.notFound)
    }

    try app.register(collection: UserController())
    try app.register(collection: PostController())
}
