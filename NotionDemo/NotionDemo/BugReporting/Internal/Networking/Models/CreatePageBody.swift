struct CreatePageBody: Encodable {

    let parent: Parent
    let properties: Properties
}

extension CreatePageBody {

    struct Parent: Encodable {

        let databaseID: String

        enum CodingKeys: String, CodingKey {
            case databaseID = "database_id"
        }
    }

    struct Properties: Encodable {

        let description: RichTextProperty?
        let priority: SelectProperty
        let taskType: SelectProperty
        let team: SelectProperty
        let project: SelectProperty
        let assign: PeopleProperty
        let status: StatusProperty
        let name: TitleProperty

        enum CodingKeys: String, CodingKey {
            case description = "Description"
            case priority = "Priority"
            case taskType = "Task Type"
            case team = "Team"
            case project = "Project"
            case assign = "Assign"
            case status = "Status"
            case name = "Name"
        }
    }
}

extension CreatePageBody.Properties {

    struct Select: Encodable {
        let id: String
        let name: String
        let color: String
    }

    struct SelectProperty: Encodable {
        let id: String
        let type = "select"
        let select: Select
    }

    struct StatusProperty: Encodable {
        let id: String
        let type = "status"
        let status: Select
    }

    struct PeopleProperty: Encodable {
        let id: String
        let type = "people"
        let people: [Person]
    }

    struct TitleProperty: Encodable {
        let id = "title"
        let type = "title"
        let title: [RichTextObject]
    }

    struct RichTextProperty: Encodable {
        let id: String
        let type = "rich_text"
        let richText: [RichTextObject]

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case richText = "rich_text"
        }
    }
}

extension CreatePageBody.Properties.PeopleProperty {

    struct Person: Encodable {
        let object: String = "user"
        let id: String
    }
}

extension CreatePageBody {

    init(
        name: String,
        description: [RichTextObject],
        priority: Priority
    ) {
        self.parent = Parent(databaseID: "18041f07ef9f80e19ee3fb0e7ddbd28b")
        self.properties = Properties(
            description: description.nilIfEmpty
                .map { Properties.RichTextProperty(id: "%3CD%3D%3C", richText: $0) },
            priority: Properties.SelectProperty(
                id: "HQgX",
                select: Properties.Select(
                    id: priority.id,
                    name: priority.name,
                    color: priority.color
                )
            ),
            taskType: Properties.SelectProperty(
                id: "%5C%3Crq",
                select: Properties.Select(
                    id: "cRVq",
                    name: "Bug",
                    color: "red"
                )
            ),
            team: Properties.SelectProperty(
                id: "ayWU",
                select: Properties.Select(
                    id: "Or<g",
                    name: "iOS",
                    color: "purple"
                )
            ),
            project: Properties.SelectProperty(
                id: "vq%3Bs",
                select: Properties.Select(
                    id: "e:R]",
                    name: "HabitTracker",
                    color: "green"
                )
            ),
            assign: Properties.PeopleProperty(
                id: "x~pV",
                people: [
                    Properties.PeopleProperty.Person(
                        id: "f75d611b-434a-413a-8452-fa8c9908ccc6"
                    )
                ]
            ),
            status: Properties.StatusProperty(
                id: "%7BrEm",
                status: Properties.Select(
                    id: "12d15f23-37f7-4ece-8289-8fcab10a6a80",
                    name: "Not started",
                    color: "default"
                )
            ),
            name: Properties.TitleProperty(
                title: [
                    RichTextObject(
                        text: name
                    )
                ]
            )
        )
    }
}

private extension Collection {

    var nilIfEmpty: Self? {
        isEmpty ? nil : self
    }
}
