
import Foundation
import Fluent
import Vapor

struct  UserTokenDTO : Content , @unchecked  Sendable {
    
    var access_token : String?
    var user_id : String?
    
    
    
}
