//
//  NetworkManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation
import Combine

class NetworkManager {
    let server = "http://localhost:3000"
    
    var cancellable = Set<AnyCancellable>()
    
    func getNotes() -> AnyPublisher<[Note], Never> {
        guard let url = URL(string: "\(server)/api/notes") else {
            return Just([]).eraseToAnyPublisher()
        }
        
        let request = URLRequest(
            url: url,
            httpMethod: .get
        )
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Note].self, decoder: JSONDecoder())
            .replaceError(with: [])
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
            .map(\.data)
            .decode(type: NoteResponse.self, decoder: JSONDecoder())
            .replaceError(with: .failed())
            .eraseToAnyPublisher()
    }
}
