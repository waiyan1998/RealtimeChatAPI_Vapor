
import Foundation
import Fluent
import Vapor

struct ChatDTO  : Content  {
    
    var chat_id  : UUID?
    var members  : [UserDTO]?
    
    var Model : Chat {
        
        let model = Chat()
        
        if let id   = chat_id {
            model.id = id
        }
         
        return model
    }
}
