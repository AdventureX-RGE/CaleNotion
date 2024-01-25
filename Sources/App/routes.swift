import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
        guard let token = Environment.get("TOKEN") else { throw Abort(.badRequest) }
        let events = try await Notion2ICS(token: token).fetchEvents()
        let ics = icsFromEventList(events)
        return ics.asString()
    }
}
