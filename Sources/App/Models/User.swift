
import Fluent
import Vapor



final class User : Model , @unchecked Sendable {
    static let  schema  = "users"
    
    @ID( key: .id )
    var id : UUID?
    @Field(key: .username)
    var username : String
    @Field(key: .email)
    var email: String
    @Field(key: .passwordHash)
    var passwordHash : String
    @Timestamp(key: .created_at, on: .create)
    var createdAt: Date?
    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    init() { 
    
    }
    
    init( id : UUID? = nil , username : String , email : String , passwordHash : String , createAt : Date  = Date(), updatedAt : Date = Date())
    {
        self.id = id
        self.username = username
        self.email  = email
        self.passwordHash = passwordHash
        self.createdAt = createAt
        self.updatedAt = updatedAt
    }



 
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {

    struct Create: Content {
        var username : String?
        var email: String?
        var password: String?
        var comfrim_password: String?
    }

  

    var DTO :  UserDTO {
        return UserDTO( user_id : self.id, username: self.username , email : self.email )
    }

}
//
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension User {
    func generateToken( )  throws -> UserToken {
        
        try .init(
            value: [UInt8].random(count: 16).base64,
             userID: self.requireID())
        
    }
}


