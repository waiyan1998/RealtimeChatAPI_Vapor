
import Foundation
import Vapor
import Fluent
import WebSocketKit

struct ChatController : RouteCollection {
    
    
    func boot(routes: RoutesBuilder) throws {
        let chat = routes.grouped("chat")
        let tokenProtected = chat.grouped(UserToken.authenticator())
        tokenProtected.post("add", use: createChat)
        tokenProtected.get("getlists", use: chatlists)
        
        chat.webSocket("message") { req , ws  in
            ws.onText { ws, text in
            
                // String received by this WebSocket.
                guard let message = text.decode(as: MessageDTO.self)?.model else {
                    return
                }
                print(message)
                do {
                    try await  message.save(on: req.db)
                }catch{
                    print(error.localizedDescription)
                }
            
                
            }

        }
        
    }
    
    @Sendable func createChat(req : Request) async throws -> MyResponse<ChatDTO>
    {
        let create = try req.content.decode(Chat.Create.self)
        
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid User Token!!" , data: nil)
        }
        guard let  user_token = try await UserToken.query(on: req.db)
           .filter(\.$value == token).first()  else{
            return MyResponse(statusCode: 0 , message: "User Not Found", data: nil)
        }
        
        guard let type = ChatType(rawValue: create.type ?? "" ) else {
            return MyResponse(statusCode: 0 , message: "Invalid Chat Type!", data: nil)
        }
        guard let members = create.members?.map({ $0.model }) else {
            return MyResponse(statusCode: 0 , message: "Plz Add Chat Member!", data: nil)
        }
        
        
        if type == .direct , let member_id  = members.first?.id , let chat_member = try await ChatMember.query(on: req.db).filter(\.$user.$id == member_id).first() {
            
            guard members.count == 1  else {
                return MyResponse(statusCode: 0 , message: "Invalid Input!!" , data: nil)
            }
            
            
            guard var chatDTO = try await Chat.query(on: req.db).filter(\.$id == chat_member.$chat.id ).first()?.DTO else {
                return MyResponse(statusCode: 0  , message: "No User Found!!" , data: nil )
            }
            
            chatDTO.members = members.map({$0.DTO})
            
            
            return MyResponse(statusCode: 1  , message: "Chat Created" , data: [chatDTO])
           
        }
        let chat =  Chat(type: type , userID: user_token.$user.id)
        
        try await chat.save(on: req.db)
        var dto = chat.DTO
        
        for m in members {
            if let user = try await User.find(m.requireID(), on: req.db) {
                dto.members?.append(user.DTO)
                let chat_member =  try ChatMember(ChatID:  chat.requireID() , UserID:  user.requireID() )
                try await  chat_member.save(on: req.db)
            }
        }
        return MyResponse(statusCode: 0 , message: "Chat Created !!" , data: [dto])
    }
    
    
    @Sendable func chatlists(req : Request) async throws -> MyResponse<ChatDTO>
    {
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid User Token!!" , data: nil)
        }
        guard let  user_token = try await UserToken.query(on: req.db)
           .filter(\.$value == token).first()  else{
            return MyResponse(statusCode: 0 , message: "User Not Found", data: nil)
        }
       
        let chats = try await Chat.query(on: req.db).filter(\.$createdByuser_id.$id  ==  user_token.$user.id ).all()
        var dtos : [ChatDTO] = []
                                                                                                                         
        for chat in chats {
            var dto = chat.DTO
            dto.members = try await chat.$members.get(on: req.db).map({ $0.DTO })
            dtos.append(dto)
        }
        
       
        return MyResponse(statusCode: 1 , message: "Chat lists" , data : dtos )
    
    }
    
    
    
}
