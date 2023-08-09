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
    private var network: NetworkManager?
    private let deviceId = getDeviceID()
    
    init() {
        current = Context()
    }
    
    func connect(host: String) -> Bool {
        guard let manager = NetworkManager(host: host) else { return false }
        network = manager
        network?.delegate = self
        getNotes()
        
        return true
    }
}

extension ContextManager {
    func getNotes() {
        network?
            .getNotes()
            .receive(on: RunLoop.main)
            .sink { [weak self] notes in
                self?.current.notes = notes
            }
            .store(in: &cancellable)
    }
    
    func getNote(id: String) {
        network?
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
        var note = Note(title: title, content: content, access: [deviceId], owner: deviceId)
        
        network?
            .createNote(note: note)
            .receive(on:  RunLoop.main)
            .sink { [weak self] response in
                note.id = response.insertedId
                self?.current.notes += [note]
            }.store(in: &cancellable)
    }
    
    func editNote(note: Note) {
        network?
            .updateNote(note: note)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in })
            .store(in: &cancellable)
    }
    
    func removeNote(offset: IndexSet) {
        for i in offset {
            guard i < current.notes.count else { continue }
            network?
                .deleteNote(note: current.notes[i])
                .receive(on: RunLoop.main)
                .sink(receiveValue: { _ in })
                .store(in: &cancellable)
        }
        current.notes.remove(atOffsets: offset)
    }
}
 
extension ContextManager {
    func sendAccessRequest(note: Note) {
        network?
            .sendAccessRequest(deviceId: deviceId, note: note)
    }
}

extension ContextManager {
    func checkAccess(note: Note) -> Bool {
        return note.access.contains(deviceId)
    }
    
    private func removeNote(id: String) {
        current.notes = current.notes.filter { $0.id != id }
    }
    
    private func giveAccess(id: String, deviceId: String) {
        if var note = current.notes.first(where: { $0.id == id }) {
            note.access = Array(Set(note.access).union(Set([deviceId])))
            editNote(note: note)
        }
    }
}

extension ContextManager: NetworkManagerDeleagate {
    func didReceiveWSObject(_ object: WSObject) {
        switch WSObject.WSObjectMethod(rawValue:object.method) {
        case .insertOne, .update:
            getNote(id: object.id)
        case .delete:
            removeNote(id: object.id)
        case .accessRequest:
            guard object.deviceId != deviceId else { return }
            current.alertModel = AlertModel(
                title: "Access Request",
                message: "Do you want to give access to this note?",
                primaryButton: "Allow",
                primaryButtonAction: { [weak self] in
                    self?.giveAccess(id: object.id, deviceId: object.deviceId)
                })
        case .none:
            break
        }
    }
}

private func getDeviceID() -> String {
    guard let deviceId = UserDefaults.standard.string(forKey: "DeviceId") else {
        let deviceId = UUID().uuidString
        UserDefaults.standard.set(deviceId, forKey: "DeviceId")
        return deviceId
    }
    return deviceId
}
