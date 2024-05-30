import Foundation
import Fluent
import Vapor

final class Presence : Model , @unchecked Sendable {
   
    static let schema: String = "presence"
    
    @ID(key: .id)
    var id  : UUID?
    
    @Parent(key: .user_id)
    var user : User
    
    @Enum(key: .status)
    var status  : Status
    
    @Timestamp(key: .last_seen , on: .update)
    var last_seen : Date?
    
    init() {}
    
    init(id: UUID? = nil, user: User, status: Status, last_seen: Date? = Date()) {
        self.id = id
        self.user = user
        self.status = status
        self.last_seen = last_seen
    }
    
}


enum Status : String , Content  {
    case offline
    case online
    case away
}
