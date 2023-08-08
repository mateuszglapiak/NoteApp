//
//  ListNoteCell.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct ListNoteCell: View {
    var note: Note
    
    var body: some View {
        HStack {
            Text(note.title)
            Spacer()
            Text(note.content)
        }.lineLimit(1)
    }
}

struct ListNoteCell_Previews: PreviewProvider {
    static var previews: some View {
        ListNoteCell(note: Note(title: "Note 1", content: "Note content....."))
    }
}
