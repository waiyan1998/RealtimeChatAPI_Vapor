
import Foundation
import Fluent
import Vapor

final class UserToken : Model , @unchecked Sendable {
  
    static let schema = "user_tokens"
    
        @ID(key: .id)
        var id: UUID?

        @Field(key: .value )
        var value: String

        @Parent(key: .user_id)
         var user : User
       
         init() {}

         init(id: UUID? = nil, value : String , userID : User.IDValue) {
               self.id = id
               self.value = value
               self.$user.id = userID
               
           }
    
    var DTO : UserTokenDTO {
        .init(access_token: self.value, user_id: self.$user.id.uuidString)
    }
    
}

extension UserToken: ModelTokenAuthenticatable {

    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        true
    }
}
