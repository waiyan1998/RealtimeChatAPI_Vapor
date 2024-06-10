import Foundation
import Fluent
import Vapor

struct MyResponse< T : Codable>: Content {
  let statusCode: Int
  let message: String?
  let data: [T]?
}
