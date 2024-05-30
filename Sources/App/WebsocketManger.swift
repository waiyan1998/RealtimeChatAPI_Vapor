
import Foundation
import Vapor


final class WebSocketManager :  @unchecked Sendable {
    private var connections: [UUID: WebSocket] = [:]
    private let lock = NSLock()

    func addConnection(_ userID: UUID, _ ws: WebSocket) {
        lock.lock()
        connections[userID] = ws
        lock.unlock()

        ws.onClose.whenComplete { [weak self] _ in
            self?.removeConnection(userID)
        }
    }

    func removeConnection(_ userID: UUID) {
        lock.lock()
        connections.removeValue(forKey: userID)
        lock.unlock()
    }

    func sendMessage(to userID: UUID, message: String) {
        lock.lock()
        if let ws = connections[userID] {
            ws.send(message)
        }
        lock.unlock()
    }
}
