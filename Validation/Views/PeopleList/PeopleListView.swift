//
//  PeopleListView.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import SwiftUI

struct PeopleListView: View {
    
    @StateObject private var viewModel = PeopleListViewModel()
    
    var body: some View {
        List(viewModel.people) { person in
            NavigationLink {
                DetailsView(viewModel: .init(person: person))
            } label: {
                Text(person.name)
                    .font(.system(size: 20))
            }
        }
        .navigationTitle("People".localized())
        .navigationBarItems(trailing: registerButton)
        .onAppear { viewModel.fetchPeople() }
        .alert("Erro ao pegar dados do banco de dados", isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private var registerButton: some View {
        NavigationLink {
            RegisterView()
        } label: {
            Text("Register".localized())
        }
    }
}
