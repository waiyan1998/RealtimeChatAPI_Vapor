
import Foundation
import Vapor


final class WebSocketManager :  @unchecked Sendable {
    private var connections: [UUID: WebSocket] = [:]
    private let lock = NSLock()

    func addConnection(_ ID: UUID, _ ws: WebSocket) {
        lock.lock()
        
        connections[ID] = ws
        lock.unlock()

        ws.onClose.whenComplete { [weak self] _ in
            self?.removeConnection(ID)
        }
    }

    func removeConnection(_ ID: UUID) {
        lock.lock()
        connections.removeValue(forKey: ID)
        lock.unlock()
    }

    func sendMessage(to ID : UUID, message: String) {
        
        lock.lock()
        if let ws = connections[ID] {
            print("sendMessage")
            ws.send(message)
        }
        lock.unlock()
    }
}
