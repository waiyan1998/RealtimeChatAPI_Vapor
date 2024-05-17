//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent


final class Message : Model, @unchecked Sendable {
  
    static let schema = "messages"
    
       @ID(key: .id)
       var id: UUID?
    
       @Field(key: .content)
        var content : String

       @Parent(key: .sender_id)
       var sender_id : User

       @Parent(key: .recipient_id)
       var recipient_id  : User
    
       @Timestamp(key: .created_at, on: .create)
        var created_at : Date?
       
      init() {}

    init(id: UUID? = nil, content : String ,  senderID : User.IDValue , recipientID  : User.IDValue  , created_at : Date = Date()) {
           self.id = id
           self.content = content
           self.$sender_id.id = senderID
           self.$recipient_id.id = recipientID
           self.created_at = created_at
       }
    
    
    
}
