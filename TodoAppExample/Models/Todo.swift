import Foundation

struct Todo: Identifiable, Codable {
    let id : UUID
    let title : String
    let content : String
    
    init(id : UUID, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
