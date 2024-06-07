
import Foundation
import Vapor
import Fluent

final class Chat: Model , @unchecked Sendable  {
    
    static let schema = "chats"

    @ID(key: .id)
    var id: UUID?
    

    @Siblings(through: ChatMember.self , from: \.$chat , to: \.$user)
    var members : [User]
    
    init() {}
    init(id: UUID? = nil) {
        self.id = id
       
        
    }
    
    var DTO : ChatDTO {
        .init(chat_id : self.id , members: [])
    }
    
    
    
}
extension Chat {
    struct Create  : Content {
        var members : [UserDTO]?
    }
}



