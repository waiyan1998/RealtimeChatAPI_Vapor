import Foundation
import Vapor

struct MessageDTO  : Content  {
    
    var message_id : UUID?
    var content  : String?
    var sender_id : UUID?
    var chat_id : UUID?
    var createDate : String?
    
    var model : Message{
        
        let model = Message()
        model.id = message_id
        
        if let content = content
        {
            model.content = content
        }
        if let sender_id = sender_id
        {
            model.$sender.id  = sender_id
        }
        if let chat_id = chat_id
        {
            model.$chat.id    = chat_id
        }
        if let createDate = createDate
        {
            model.created_at    = createDate.date()
        }
    
        return model
    }
  
  
}


enum WSStatus : String , Codable  {
    case sent
}
