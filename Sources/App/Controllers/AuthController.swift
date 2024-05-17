//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor

struct AuthController: RouteCollection {
    
    
    func boot(routes: RoutesBuilder) throws {
        
        
        
        let users = routes.grouped("users")
        let auth = users.grouped(User.authenticator())
        let tokenProtected = users.grouped(UserToken.authenticator())
        
        users.post("register" , use: register )
     
        //auth.get("login", use: index)
       // tokenProtected.get("me", use: detail)
        //tokenProtected.get("logout" , use: logout)

        
     
        
    }
    
    

   @Sendable func register(req: Request) async throws -> MyResponse<UserTokenDTO> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard let pw = create.password , let con_pw = create.confirmPassword , pw == con_pw else {
            return  MyResponse(statusCode:  0 , message: "Password Did'nt match!!!", data: nil)
        }
        guard let name = create.name , let email = create.email else {
            return  MyResponse(statusCode:  0 , message: " No Data  !!!", data: nil)
        }
       
        let pw_hash = try Bcrypt.hash(pw)
        let user =  User(name: name , email: email , passwordHash: pw_hash)
        try await user.save(on: req.db)
        
        return  MyResponse(statusCode: 1, message: "Register success!!!", data: nil)

     }
    
//    func logout(req  : Request) async throws -> MyResponse<UserToken.Public> {
//        guard let token = req.headers.bearerAuthorization?.token else {
//            throw MyError.invalidInput("invalid bearer token")
//           }
//         if  let  user_token = try await UserToken.query(on: req.db)
//            .filter(\.$value == token).first()  {
//             
//             try await user_token.delete(on: req.db)
//             return MyResponse(statusCode: 0 , message: "Logout Success", data: nil)
//         }
//        
//        return MyResponse(statusCode: 0 , message: "Logout Fail", data: nil)
//    }

    
}
