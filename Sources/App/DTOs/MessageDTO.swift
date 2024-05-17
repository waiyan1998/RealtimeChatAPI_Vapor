import Foundation
import Vapor

struct MessageDTO  : Content  {
    
    var message_id  : UUID?
    var sender_id : String?
    var createdDate : Date?
    var members : [UserDTO]?
  
}
