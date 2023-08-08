//
//  NetworkManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation
import Combine

protocol NetworkManagerDeleagate {
    func didReceiveWSObject(_ object: WSObject)
}

class NetworkManager {
    let server = "http://localhost:3000"
    let websocket = "ws://localhost:3001"
    
    let webSocketManager: WebSocketManager!
    var delegate: NetworkManagerDeleagate?
    
    var cancellable = Set<AnyCancellable>()
    private static let sessionProcessingQueue = DispatchQueue(label: "session.network.noteapp")
    
    init() {
        let url = URL(string: websocket)!
        webSocketManager = WebSocketManager()
        webSocketManager.delegate = self
        webSocketManager.connect(url: url)
    }
    
    deinit {
        webSocketManager.disconnect()
    }
    
    func getNotes() -> AnyPublisher<[Note], Never> {
        guard let url = URL(string: "\(server)/api/notes") else {
            return Just([]).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .get
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: Self.sessionProcessingQueue)
            .map(\.data)
            .decode(type: [Note].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func getNote(id: String) -> AnyPublisher<Note?, Never> {
        guard let url = URL(string: "\(server)/api/notes/\(id)") else {
            return Just(nil).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .get
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: Self.sessionProcessingQueue)
            .map(\.data)
            .decode(type: Note?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    func createNote(note: Note) -> AnyPublisher<NoteResponse, Never> {
        guard let url = URL(string: "\(server)/api/notes") else {
            return Just(.failed()).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .post,
            encodableBody: note
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: Self.sessionProcessingQueue)
            .map(\.data)
            .decode(type: NoteResponse.self, decoder: JSONDecoder())
            .replaceError(with: .failed())
            .eraseToAnyPublisher()
    }
    
    func updateNote(note: Note) -> AnyPublisher<NoteResponse, Never> {
        guard let url = URL(string: "\(server)/api/notes/\(note.id)") else {
            return Just(.failed()).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .put,
            encodableBody: note
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: Self.sessionProcessingQueue)
            .map(\.data)
            .decode(type: NoteResponse.self, decoder: JSONDecoder())
            .replaceError(with: .failed())
            .eraseToAnyPublisher()
    }
    
    func deleteNote(note: Note) -> AnyPublisher<NoteResponse, Never> {
        guard let url = URL(string: "\(server)/api/notes/\(note.id)") else {
            return Just(.failed()).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .delete,
            encodableBody: note
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: Self.sessionProcessingQueue)
            .map(\.data)
            .decode(type: NoteResponse.self, decoder: JSONDecoder())
            .replaceError(with: .failed())
            .eraseToAnyPublisher()
    }
}

struct AccessRequestMessage: Codable {
    var method: String
    var deviceId: String
    var id: String
}

extension NetworkManager {
    func sendAccessRequest(deviceId: String, note: Note) {
        let jsonData = try! JSONEncoder().encode(AccessRequestMessage(method: "accessRequest", deviceId: deviceId, id: note.id))
        let jsonString = String(data: jsonData, encoding: .ascii)!
        print(jsonString)
        webSocketManager.send(message: jsonString)
    }
}

extension NetworkManager: WebSocketManagerDelegate {
    func didReceiveMessage(_ message: String) {
        print("Received message: \(message)")

        let object: WSObject = try! JSONDecoder().decode(WSObject.self, from: message.data(using: .utf8)!)
        delegate?.didReceiveWSObject(object)
    }
    
    func didDisconnect() {
        print("WebSocket is disconnected")
    }
}
