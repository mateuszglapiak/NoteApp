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
        getNotes(context: &current)
    }
}

extension ContextManager {
    func getNotes(context: inout Context) {
        network
            .getNotes()
            .receive(on: RunLoop.main)
            .sink { [weak context] notes in
                context?.notes = notes
            }
            .store(in: &cancellable)
    }
    
    func getNote(context: inout Context, id: String) {
        network
            .getNote(id: id)
            .receive(on: RunLoop.main)
            .sink { [weak context] note in
                guard let note = note else { return }
                if let foundNote = context?.notes.first(where: { $0.id == id }),
                   let index = context?.notes.firstIndex(of: foundNote) {
                    context?.notes[index].update(note)
                    print(note.content)
                } else {
                    context?.notes += [note]
                }
            }
            .store(in: &cancellable)
    }
    
    func addNote(context: inout Context, title: String = "", content: String = "") {
        var note = Note(title: title, content: content)
        
        network
            .createNote(note: note)
            .receive(on: RunLoop.main)
            .sink { [weak context] response in
                note.id = response.insertedId
                context?.notes += [note]
            }.store(in: &cancellable)
    }
    
    func editNote(note: Note) {
        network
            .updateNote(note: note)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in })
            .store(in: &cancellable)
    }
    
    func removeNote(context: inout Context, offset: IndexSet) {
        for i in offset {
            guard i < context.notes.count else { continue }
            network
                .deleteNote(note: context.notes[i])
                .receive(on: RunLoop.main)
                .sink(receiveValue: { _ in })
                .store(in: &cancellable)
        }
        context.notes.remove(atOffsets: offset)
    }
}

extension ContextManager: NetworkManagerDeleagate {
    func didReceiveWSObject(_ object: WSObject) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch WSObject.WSObjectMethod(rawValue:object.method) {
            case .insertOne:
                
                break
            case .update:
                getNote(context: &self.current, id: object.id)
                break
            case .delete:
                
                break
            case .none:
                break
            }
        }
    }
}
