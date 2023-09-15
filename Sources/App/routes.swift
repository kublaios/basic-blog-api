import Vapor

func routes(_ app: Application) throws {
    app.get { (req: Request) throws -> HTTPStatus in
        throw Abort(.notFound)
    }

    // TODO: Register new routes below
    // try app.register()
}
