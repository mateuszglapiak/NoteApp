//
//  ListNoteCell.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct ListNoteCell: View {
    @State var hasAccess: Bool
    @Binding var note: Note
    
    var body: some View {
        HStack {
            Image(systemName: hasAccess ? "lock.open" : "lock")
            Text(note.title)
            Spacer()
            Text(note.content)
                .opacity(0.5)
                .frame(maxWidth: 100)
        }.lineLimit(1)
    }
}

struct ListNoteCell_Previews: PreviewProvider {
    static var previews: some View {
        ListNoteCell(hasAccess: true, note: Binding.constant(Note(title: "Note 1", content: "Note content.....")))
    }
}
