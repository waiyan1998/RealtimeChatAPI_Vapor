//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor 
import Fluent

struct AuthController: RouteCollection {
    
    
    func boot(routes: RoutesBuilder) throws {
        
        
        
        let users = routes.grouped("users")
        let auth = users.grouped(User.authenticator())
        let tokenProtected = users.grouped(UserToken.authenticator())
        
        users.post("register" , use: register )
        auth.get("login", use: login)
        tokenProtected.get("logout", use: logout)
        tokenProtected.get("me", use: me)
        tokenProtected.get("lists", use: lists)
     
        
    }
    
    @Sendable func login(req: Request) async throws -> MyResponse<UserTokenDTO> {
        let user = try req.auth.require(User.self)
        
        guard let id = user.id , let _ = try await UserToken.query(on: req.db).filter(\.$user.$id == id).first() else {
            let token =  try  user.generateToken()
            try await token.save(on: req.db)
          return  MyResponse(statusCode: 1, message: "Login Success", data: [token.DTO])
            
        }
        return  MyResponse(statusCode: 0 , message: "User already Login", data: nil)
    }
    
    
    
    
    @Sendable func lists(req: Request) async throws -> MyResponse<UserDTO> {
        
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid Token!!", data: nil)
           }
         if let user_token =  try await UserToken.query(on: req.db).filter(\.$value == token).first()  {
             
             let users = try await User.query(on: req.db).filter(\.$id  != user_token.$user.id).all().map({$0.DTO})
             return  MyResponse(statusCode: 1 , message: "", data: users)
          }
        
        return  MyResponse(statusCode: 0 , message: "No Users!!", data: nil)
    }
    
    @Sendable func me(req: Request) async throws -> MyResponse<UserDTO> {

        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid Token!!", data: nil)
           }
        guard let user_token =  try await UserToken.query(on: req.db).filter(\.$value == token).first() else {
            return  MyResponse(statusCode: 0 , message: "Invalid Token!!", data: nil)
          }
        guard let user = try await User.find(user_token.$user.id, on: req.db) else{
            return  MyResponse(statusCode: 0 , message: "No Users!!", data: nil)
        }
        return  MyResponse(statusCode: 1 , message: nil , data: [user.DTO])
    }
    
    @Sendable func register(req: Request) async throws -> MyResponse<UserTokenDTO> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard let pw = create.password , let con_pw = create.comfrim_password , pw == con_pw else {
            return  MyResponse(statusCode:  0 , message: "Password Did'nt match!!!", data: nil)
        }
        guard let username = create.username , let email = create.email else {
            return  MyResponse(statusCode:  0 , message: " No Data!!!", data: nil)
        }
       
        let pw_hash = try Bcrypt.hash(pw)
        let user =  User(username : username  , email: email , passwordHash: pw_hash)
            try await user.save(on: req.db)
        let user_token = try user.generateToken()
            try await user_token.save(on: req.db)
        
       return  MyResponse(statusCode: 1, message: "Register success!!!", data: [user_token.DTO])

     }
    
    @Sendable func logout(req  : Request) async throws -> MyResponse<UserTokenDTO> {
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid Token!!", data: nil)
            }
        if let user_token =  try await UserToken.query(on: req.db).filter(\.$value == token).first()  {
                try await  user_token.delete(on: req.db)
                return MyResponse(statusCode: 1 , message: "Logout Sucess !!", data: nil)
            }
        
        return MyResponse(statusCode: 0 , message: "Logout Fail", data: nil)
    }

}
