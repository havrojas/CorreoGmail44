//
//  ContentView.swift
//  corres
//
//  Created by Havit Obispo on 26/07/23.
//

import Foundation
import SwiftUI

struct Email: Identifiable {
    let id = UUID()
    let emisor: String
    let correoEmisor: String
    let asunto: String
    let mensaje: String
    let hora: String
    var leido: Bool
    var destacado: Bool
    var spam: Bool
    var horaEnvio: String
}

struct ContentView: View {

    var body: some View {
        TabView {
            EmailListView(category: .inbox)
                .tabItem {
                    Image(systemName: "tray.fill")
                    Text("Bandeja de entrada")
                }
            EmailListView(category: .destacados)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Destacados")
                }
            EmailListView(category: .spam)
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Spam")
                }
            EmailListView(category: .papelera)
                .tabItem {
                    Image(systemName: "trash.fill")
                    Text("Papelera")
                }
            EmailListView(category: .enviados)
                .tabItem {
                    Image(systemName: "paperplane.fill")
                    Text("Enviados")
                }
        }
    }
}

enum EmailCategory {
    case inbox, destacados, spam, papelera, enviados
}

struct EmailListView: View {

    @State private var searchText = ""
    @State private var showingSpamAlert = false
    @State private var showingDeleteAlert = false
    @State private var showingStarAlert = false

    @ObservedObject var dummy = Dummy.shared
    var category: EmailCategory

    private var filteredEmails: [Email] {
        if searchText.isEmpty {
            return getEmails(for: category)
        } else {
            return getEmails(for: category).filter {
                $0.emisor.lowercased().contains(searchText.lowercased()) || $0.asunto.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func getEmails(for category: EmailCategory) -> [Email] {
        switch category {
        case .inbox:
            return dummy.getInboxEmails()
        case .destacados:
            return dummy.getDestacadosEmails()
        case .spam:
            return dummy.getSpamEmails()
        case .papelera:
            return dummy.getPapeleraEmails()
        case .enviados:
            return dummy.getEnviadosEmails()
        }
    }

    func toggleDestacado(for email: Email) {
        dummy.toggleDestacado(for: email)
        showingStarAlert = email.destacado
    }

    func toggleSpam(for email: Email) {
        dummy.toggleSpam(for: email)
        showingSpamAlert = email.spam
    }

    func moveEmailToPapelera(for email: Email) {
        dummy.moveEmailToPapelera(for: email)
        showingDeleteAlert = true
    }

    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)

                ForEach(filteredEmails) { email in
                    VStack(alignment: .leading) {
                        Text(email.emisor)
                            .font(.headline)
                        Text(email.asunto)
                            .font(.subheadline)
                            .foregroundColor(email.leido ? .secondary : .primary)

                        HStack {
                            Image(systemName: email.destacado ? "star.fill" : "star")
                                .onTapGesture {
                                    toggleDestacado(for: email)
                                }
                            Image(systemName: email.spam ? "exclamationmark.triangle.fill" : "exclamationmark.triangle")
                                .onTapGesture {
                                    toggleSpam(for: email)
                                }
                            Image(systemName: "trash")
                                .onTapGesture {
                                    moveEmailToPapelera(for: email)
                                }
                            Spacer()
                            Text(email.horaEnvio)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(categoryTitle(for: category))
        }
        .alert(isPresented: $showingSpamAlert) {
            Alert(title: Text("Mensaje marcado como spam"), message: nil, dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingStarAlert) {
            Alert(title: Text("Mensaje destacado"), message: nil, dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Mensaje enviado a la papelera"),
                message: nil,
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func categoryTitle(for category: EmailCategory) -> String {
        switch category {
        case .inbox:
            return "Bandeja de entrada"
        case .destacados:
            return "Destacados"
        case .spam:
            return "Spam"
        case .papelera:
            return "Papelera"
        case .enviados:
            return "Enviados"
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Buscar", text: $text)
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 15)
        }
    }
}

class Dummy: ObservableObject {
    static let shared = Dummy()

    @Published var emails: [Email] = [
        Email(emisor: "Juan Perez", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "9:30 am"),
        // Agrega más correos aquí

        Email(emisor: "Juan Perez", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "10:30 AM"),


        Email(emisor: "grecia ", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "14:00 PM"),


        Email(emisor: "Lewis hamilton ", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "15:44 PM"),
        Email(emisor: "Havit obispo rojas ", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "16:44 PM"),


        Email(emisor: "Juan Perez", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "15:44 PM"),



        Email(emisor: "Juan Perez23", correoEmisor: "jperez@gmail.com", asunto: "Tarea primer parcial", mensaje: "Lorem ipsum dolor sit amet, consectetur adipisicing.", hora: "10:00am", leido: true, destacado: true, spam: false, horaEnvio: "15:44 PM"),
    ]

    func getInboxEmails() -> [Email] {
        return emails.filter { !$0.destacado && !$0.spam }
    }

    func getDestacadosEmails() -> [Email] {
        return emails.filter { $0.destacado && !$0.spam }
    }

    func getSpamEmails() -> [Email] {
        return emails.filter { $0.spam }
    }

    func getPapeleraEmails() -> [Email] {
        return emails.filter { $0.destacado && $0.spam }
    }

    func getEnviadosEmails() -> [Email] {
        return emails // Implementa la lógica para obtener los mensajes enviados
    }

    func toggleDestacado(for email: Email) {
        if let index = emails.firstIndex(where: { $0.id == email.id }) {
            var updatedEmails = emails
            updatedEmails[index].destacado.toggle()
            if updatedEmails[index].destacado {
                updatedEmails[index].spam = false
            }
            emails = updatedEmails
        }
    }

    func toggleSpam(for email: Email) {
        if let index = emails.firstIndex(where: { $0.id == email.id }) {
            var updatedEmails = emails
            updatedEmails[index].spam.toggle()

            if updatedEmails[index].spam {
                updatedEmails[index].destacado = false
            }

            emails = updatedEmails
            showingSpamAlert = email.spam
        }
    }

    func moveEmailToPapelera(for email: Email) {
        if let index = emails.firstIndex(where: { $0.id == email.id }) {
            var updatedEmails = emails
            updatedEmails[index].destacado = true
            updatedEmails[index].spam = true
            emails = updatedEmails
            showingDeleteAlert = true
        }
    }

    @Published var showingSpamAlert = false
    @Published var showingDeleteAlert = false
}

