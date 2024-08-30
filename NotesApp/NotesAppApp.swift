//
//  NotesAppApp.swift
//  NotesApp
//
//  Created by Juan Antonio Carrasco del Cid on 28/8/24.
//

import SwiftUI
import SwiftData

@main
struct NotesAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Note.self)
        }
    }
}
