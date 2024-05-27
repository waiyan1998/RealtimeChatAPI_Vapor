
import Foundation
import Fluent
import Vapor

struct ChatDTO  : Content  {
    
    var chat_id  : UUID?
    var chat_type : String?
    var members  : [UserDTO]?
    
    var Model : Chat {
        
        let model = Chat()
        
        if let id   = chat_id {
            model.id = id
        }
           
        if let type  = chat_type  {
            model.type = ChatType(rawValue: type)!
        }
        
        return model
    }
}
