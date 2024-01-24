import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        guard let token = ProcessInfo.processInfo.environment["TOKEN"] else { throw Abort(.badRequest) }
        let events = try await Notion2ICS(token: token).fetchEvents()
        let ics = icsFromEventList(events)
        return ics.asString()
    }
}
