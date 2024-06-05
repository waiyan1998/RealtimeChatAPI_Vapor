
import Foundation
import Vapor
import Fluent
import WebSocketKit


struct ChatController : RouteCollection {
    
    let webSocketManager = WebSocketManager()
    
    func boot(routes: RoutesBuilder) throws {
        let chat = routes.grouped("chat")
        let tokenProtected = chat.grouped(UserToken.authenticator())
        tokenProtected.post("add", use: createChat)
        tokenProtected.post("send", use: sendMessage)
        tokenProtected.post("messages", use: messagelists)
        tokenProtected.get("getlists", use: chatlists)
        chat.webSocket("connect", onUpgrade: handleWebSocket)
      
    }
    
    @Sendable private func handleWebSocket(req: Request, ws: WebSocket) {
         guard let id  = req.query[UUID.self, at: "id"] else {
             ws.close(promise: nil)
             return
         }
        guard let redirect_id  = req.query[UUID.self, at: "redirect_id"] else {
            ws.close(promise: nil)
            return
        }
        print(id)
        print(redirect_id)

         webSocketManager.addConnection(id, ws)
       

         ws.onText {  ws, text in
             
             guard  let data = text.data(using: .utf8) else { return }
             
             do{
                 let message = try JSONDecoder().decode(MessageDTO.self, from: data)
                 print(message)
                 self.handleMessage(message, app: req.application , redirect_id )
            }catch{
                print(error.localizedDescription)
            }
                                                        
        
             
         }
     }
    
    
    private func handleMessage(_ message: MessageDTO, app: Application , _ redirect_id : UUID ) {
        let newMessage = message.model
        
           newMessage.save(on: app.db).whenComplete { result in
               switch result {
               case .success:
                   do {
                       let messageData = try JSONEncoder().encode(message)
                       if let messageString = String(data: messageData, encoding: .utf8) {
                           
                           
                           webSocketManager.sendMessage(to: redirect_id , message: messageString)
                           
                       }
                   } catch {
                       print("Failed to encode message: \(error)")
                   }
               case .failure(let error):
                   print("Failed to save message: \(error)")
               }
           }
       }
    
  
    @Sendable func createChat ( req : Request ) async throws -> MyResponse<ChatDTO>
    {
        let create = try req.content.decode(Chat.Create.self)
        
       
//        guard let token = req.headers.bearerAuthorization?.token else {
//                   return MyResponse(statusCode: 0 , message: "Invalid User Token!!" , data: nil)
//        }

        guard let members = create.members else {
                   return MyResponse(statusCode: 0 , message: "Plz Add Chat Member!", data: nil)
        }
        
        let chats = try await Chat.query(on: req.db).all()
        
        for chat in chats{
            
            let  chat_members = try await chat.$members.get(on: req.db).map({ $0.DTO })
           
            
            let sorted_chat_members = chat_members.sorted(by: { $0.user_id!.uuidString < $1.user_id!.uuidString })
            let sorted_members = members.sorted(by: { $0.user_id!.uuidString < $1.user_id!.uuidString })
            
            print(sorted_members == sorted_chat_members )
            
            if  sorted_members == sorted_chat_members {
                var ChatDTO = chat.DTO
                    ChatDTO.members = sorted_chat_members
                
                return MyResponse(statusCode: 1 , message: "Chat Created !!" , data: [ChatDTO])
            }
        }
        
        
        
        
        let chat = Chat()
        try await chat.save(on: req.db)
        
        let _members = members.map( { return $0.member(chat.id!)} )
        for m in _members { try await m.save(on: req.db) }
        var chatDTO = chat.DTO
            chatDTO.members   = try await chat.$members.get(on: req.db).map({ $0.DTO })
        
        return MyResponse(statusCode: 1 , message: "Chat Created !!" , data: [chatDTO])
    }
    
    @Sendable func sendMessage( req : Request ) async throws -> MyResponse<MessageDTO>
    {
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0, message: "Invalid Token!!", data: nil)
        }
        let create = try req.content.decode(MessageDTO.self)
        let message = create.model
        try await message.save(on: req.db)
        return MyResponse(statusCode: 1, message: "Sent", data: [message.DTO])
    }
    
    @Sendable func messagelists ( req : Request ) async throws -> MyResponse<MessageDTO>
    {
        guard let chat_id   = req.query[UUID.self, at: "id"] else {
          
            return MyResponse(statusCode: 0, message: "Not Availiable Chat!!", data: nil)
        }
        let messages = try await Message.query(on: req.db).filter(\.$chat.$id == chat_id).sort(.created_at).all().map({ $0.DTO })
        
        return MyResponse(statusCode: 1, message: "Success", data: messages)
    }
    
    @Sendable func chatlists(req : Request) async throws -> MyResponse<ChatDTO>
    {
        guard let token = req.headers.bearerAuthorization?.token else {
            return MyResponse(statusCode: 0 , message: "Invalid User Token!!" , data: nil)
        }
//        guard let  user_token = try await UserToken.query(on: req.db)
//           .filter(\.$value == token).first()  else{
//            return MyResponse(statusCode: 0 , message: "User Not Found", data: nil)
//        }
//       
        let chats = try await Chat.query(on: req.db).all()
        var dtos : [ChatDTO] = []
                                                                                                                         
        for chat in chats {
            let dto = chat.DTO
           
            dtos.append(dto)
        }
        
        
       
        return MyResponse(statusCode: 1 , message: "Chat lists" , data : dtos )
    
    }
    
    
    
}
