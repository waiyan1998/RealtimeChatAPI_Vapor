//
//  File.swift
//  
//
//  Created by  Brycen Myanmar  on 13/05/2024.
//

import Foundation
import Fluent
import Vapor

struct  UserTokenDTO : Content , @unchecked  Sendable {
    
    var access_token : String?
    var user_id : UUID?
    
}
