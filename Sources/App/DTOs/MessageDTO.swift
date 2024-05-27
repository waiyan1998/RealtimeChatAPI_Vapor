import Foundation
import Vapor

struct MessageDTO  : Content  {
    
    var content  : String?
    var sender_id : UUID?
    var recipient_id : UUID?
    var createdDate : String?
    
    var model : Message {
        
        let model = Message()
        if let content  = self.content {
            model.content = content
        }
        
        if let sender_id = self.sender_id{
            model.$sender_id.id = sender_id
        }
        if let recipient_id = self.recipient_id{
            model.$recipient_id.id = recipient_id
        }
        if let createdDate = self.createdDate{
            model.created_at = createdDate.date()
        }
       
        return model
    }
  
}
