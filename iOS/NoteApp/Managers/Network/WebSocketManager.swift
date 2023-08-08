//
//  WebSocketManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

protocol WebSocketManagerDelegate: AnyObject {
    func didReceiveMessage(_ message: String)
    func didDisconnect()
}

class WebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    weak var delegate: WebSocketManagerDelegate?
    
    func connect(url: URL) {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
    
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message, completionHandler: { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        })
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.didReceiveMessage(text)
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    break
                }
                self?.receiveMessages()
                
            case .failure(let error):
                print("WebSocket receive error: \(error)")
                self?.delegate?.didDisconnect()
            }
        }
    }
}
