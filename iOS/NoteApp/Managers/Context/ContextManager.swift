//
//  ContextManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation
import Combine

@MainActor class ContextManager: ObservableObject {
    @Published var current: Context
    private var cancellable = Set<AnyCancellable>()
    private let network: NetworkManager
    
    init() {
        current = Context()
        network = NetworkManager()
        network.delegate = self
        getNotes()
    }
}

extension ContextManager {
    func getNotes() {
        network
            .getNotes()
            .receive(on: RunLoop.main)
            .sink { [weak self] notes in
                self?.current.notes = notes
            }
            .store(in: &cancellable)
    }
    
    func getNote(id: String) {
        network
            .getNote(id: id)
            .receive(on:  RunLoop.main)
            .sink { [weak self] note in
                guard let note = note else { return }
                if let foundNote = self?.current.notes.first(where: { $0.id == id }),
                   let index = self?.current.notes.firstIndex(of: foundNote) {
                    self?.current.notes[index].update(note)
                } else {
                    self?.current.notes += [note]
                }
            }
            .store(in: &cancellable)
    }
    
    func addNote(title: String = "", content: String = "") {
        var note = Note(title: title, content: content)
        
        network
            .createNote(note: note)
            .receive(on:  RunLoop.main)
            .sink { [weak self] response in
                note.id = response.insertedId
                self?.current.notes += [note]
            }.store(in: &cancellable)
    }
    
    func editNote(note: Note) {
        network
            .updateNote(note: note)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in })
            .store(in: &cancellable)
    }
    
    func removeNote(offset: IndexSet) {
        for i in offset {
            guard i < current.notes.count else { continue }
            network
                .deleteNote(note: current.notes[i])
                .receive(on: RunLoop.main)
                .sink(receiveValue: { _ in })
                .store(in: &cancellable)
        }
        current.notes.remove(atOffsets: offset)
    }
}

extension ContextManager: NetworkManagerDeleagate {
    func didReceiveWSObject(_ object: WSObject) {
        switch WSObject.WSObjectMethod(rawValue:object.method) {
        case .insertOne:
            
            break
        case .update:
            getNote(id: object.id)
            break
        case .delete:
            
            break
        case .none:
            break
        }
    }
}
