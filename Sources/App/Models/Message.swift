

import Foundation
import Fluent


final class Message : Model, @unchecked Sendable {
  
    static let schema = "messages"
    
       @ID(key: .id)
       var id: UUID?
    
       @Field(key: .content)
        var content : String

       @Parent(key: .sender_id)
       var sender : User

        
        @Parent(key: .chat_id)
        var chat  : Chat
    
       @Timestamp(key: .created_at, on: .create)
        var created_at : Date?
       
        init() {}

        init(id: UUID? = nil, content : String ,  senderID : User.IDValue , ChatID : Chat.IDValue , created_at : Date = Date()) {
               self.id = id
               self.content = content
               self.$sender.id = senderID
               self.$chat.id = ChatID
               self.created_at = created_at
        }
    
    var DTO : MessageDTO {
        return MessageDTO(message_id: self.id , content : self.content, sender_id: self.$sender.id , chat_id: self.$chat.id , createDate: self.created_at?.toString())
    }
    
    
    
}
