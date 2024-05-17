
import Fluent
import Vapor



final class User : Model , @unchecked Sendable {

    static let schema = "users"

    @ID(key: .id)
    var id: UUID?
    
    

    @Field(key: .name)
    var name: String

    @Field(key: .email)
    var email: String

  

    @Field(key: .passwordHash)
    var passwordHash : String

    init() { }



    init( _ id : UUID?  = nil , name : String , email : String , passwordHash : String  )  {

        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
       

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
        var name: String?
        var email: String?
        var password: String?
        var confirmPassword: String?
    }

  

    var DTO :  UserDTO {
        return UserDTO( user_id : self.id, username: self.name , email : self.email )
    }

}
//
extension User.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
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


