import Fluent
import FluentMySQLDriver
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    app.databases.use(
        DatabaseConfigurationFactory.mysql(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:))
                ?? MySQLConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tlsConfiguration: {
                var configuraton = TLSConfiguration.makeClientConfiguration()
                configuraton.certificateVerification = .none
                return configuraton
            }()
        ), as: .mysql)

    app.migrations.add(CreateUsersTableMigration())
    app.migrations.add(CreatePostsTableMigration())

    // Set custom coders for snake_case support
    // https://abhidsm.com/vapor/2020/08/17/JSON-encoding-decoding-for-vapor-models/
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    encoder.dateEncodingStrategy = .iso8601
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    // register routes
    try routes(app)
}
