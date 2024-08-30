//
//  ContentView.swift
//  NotesApp
//
//  Created by Alberto Carrasco del Cid on 28/8/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) var moc

    @Query(sort: \Note.date) var note: [Note]

    @State private var title: String = ""
    var body: some View {
        NavigationStack {

            VStack {

                HStack {
                    TextField("Enter note title", text: self.$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            addNote()
                        }

                    Button(action: {
                        addNote()
                    }) {
                        Text("Add")
                    }
                }.padding()
                Form {
                    Section("Notes") {
                        ForEach(note) { note in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(note.title)

                                    HStack {
                                        Text(note.date, style: .date)
                                        Text(note.date, style: .time)
                                    }.font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                                .swipeActions {
                                    Button("Delete", role: .destructive,
                                           action: {
                                        self.moc.delete(note)
                                    })
                                }
                                .swipeActions {
                                    Button(action: {
                                        note.isLiked.toggle()
                                        try! self.moc.save()
                                    }) {
                                        Label("Liked", systemImage: "heart")
                                    }.tint(.yellow)
                                }
                                Spacer()
                                if note.isLiked {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }.navigationTitle("Notes")
                }
            }
        }
    }

    private func addNote() {
        guard !self.title.isEmpty else { return }
        let newNote = Note(title: self.title, isLiked: false, date: Date())
        self.moc.insert(newNote)
        self.title = ""
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self)
}

@Model

final class Note {
    var title: String
    var isLiked: Bool
    var date: Date

    init(title: String, isLiked: Bool, date: Date) {
        self.title = title
        self.isLiked = isLiked
        self.date = date
    }
}
