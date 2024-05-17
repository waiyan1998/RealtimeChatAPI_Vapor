import Foundation
import Vapor

struct MessageDTO  : Content  {
    
    var message_id  : UUID?
    var sender_id : String?
    var createdDate : UUID?
    var members : [UserDTO]?
    
    
    
    var Model : Chat {
        
        let model = Chat()
        model.id = self.chat_id
        if let createdBy_user_id = createdBy_user_id {
            model.$createdBy_user_id.id = createdBy_user_id
        }
      
      
        return model
    }
}
