
import Foundation
import Fluent
import Vapor

struct ChatDTO  : Content  {
    
    var access_token : String?
    var user_id : UUID?
    
    var Model : UserToken {
        
        let model = UserToken()
        
        if let value  = access_token{
            model.value = value
        }
           
        if let UserID  = user_id  {
            model.$user.id = UserID
        }
      
        return model
    }
}
