import Foundation
import Vapor

struct MessageDTO  : Content  {
    
    var content  : String
    var chat_id : UUID
    var sender_id : UUID
    var recipient_id : UUID
    var createdDate : String
    
    var model : Message {
        
        let model = Message()
            model.content = content
            model.$sender_id.id = sender_id
            model.$recipient_id.id = recipient_id
            model.created_at = createdDate.date()
        return model
    }
  
}
