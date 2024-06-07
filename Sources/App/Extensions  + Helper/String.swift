
import Foundation


extension String {
    
    func decode<T : Codable> ( as type : T.Type ) -> T?{
        let decoder = JSONDecoder()
        let data = self.data(using: .utf8)
        
        return try? decoder.decode(T.self, from: data!)
    }
    
    func date(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func dateAndTime(format: String = "yyyy-MM-dd HH:mm") -> Date?{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
   
    func timeIn24Hour() -> Date?{
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: self)
    }
    
    var uuid : UUID?  {
        UUID(uuidString: self) ?? nil
    }
    
}
