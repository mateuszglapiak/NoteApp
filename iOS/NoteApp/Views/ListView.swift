//
//  ListView.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct ListView: View {
    private enum PickerOption: Int {
        case all, locked, unlocked
    }
    
    @Environment(\.editMode) var editMode
    @EnvironmentObject var manager: ContextManager
    @State private var listPickerOption = PickerOption.all
    
    var body: some View {
        ZStack {
            List {
                Picker("", selection: $listPickerOption) {
                    Text("All").tag(PickerOption.all)
                    Image(systemName: "lock.open").tag(PickerOption.unlocked)
                    Image(systemName: "lock").tag(PickerOption.locked)
                }
                .pickerStyle(.segmented)
                ForEach($manager.current.notes.filter { note in
                    switch listPickerOption {
                    case .all:
                        return true
                    case .locked:
                        return !manager.checkAccess(note: note.wrappedValue)
                    case .unlocked:
                        return manager.checkAccess(note: note.wrappedValue)
                    }
                }) { note in
                    let access = manager.checkAccess(note: note.wrappedValue)
                    VStack {
                        if access {
                            NavigationLink {
                                NoteDetailView(note: note)
                            } label: {
                                ListNoteCell(
                                    hasAccess: access,
                                    note: note
                                )
                            }
                        } else {
                            ListNoteCell(
                                hasAccess: access,
                                note: note
                            )
                            .onLongPressGesture {
                                manager.sendAccessRequest(note: note.wrappedValue)
                            }
                        }
                    }.deleteDisabled(access)
                }
                .onDelete {
                    manager.removeNote(offset: $0)
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                EditButton()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        manager.addNote()
                    } label: {
                        HStack() {
                            Image(systemName: "plus.circle.fill")
                            Text("Add note")
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context: ContextManager = {
            let context = ContextManager()
            context.current.notes = [
                Note(title: "Note 1", content: "Note content....."),
                Note(title: "Note 2", content: "Note content....."),
                Note(title: "Note 3", content: "Note content....."),
                Note(title: "Note 4", content: "Note content.....")
            ]
            return context
        }()
        ListView()
            .environmentObject(context)
    }
}
