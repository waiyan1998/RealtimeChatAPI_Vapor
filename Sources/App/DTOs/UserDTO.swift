//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Vapor
import Fluent 

struct  UserDTO : Content , @unchecked  Sendable {
    
    var user_id : UUID?
    var username : String?
    var email : String?
    
}
