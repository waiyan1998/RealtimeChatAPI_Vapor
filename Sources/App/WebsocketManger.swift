
import Foundation
import Vapor


final class WebSocketManager :  @unchecked Sendable {
    private var connections: [UUID: WebSocket] = [:]
    private let lock = NSLock()

    func addConnection(_ chatID: UUID, _ ws: WebSocket) {
        lock.lock()
        connections[chatID] = ws
        lock.unlock()

        ws.onClose.whenComplete { [weak self] _ in
            self?.removeConnection(chatID)
        }
    }

    func removeConnection(_ chatID: UUID) {
        lock.lock()
        connections.removeValue(forKey: chatID)
        lock.unlock()
    }

    func sendMessage(to chatID : UUID, message: String) {
        lock.lock()
        if let ws = connections[chatID] {
            ws.send(message)
        }
        lock.unlock()
    }
}
