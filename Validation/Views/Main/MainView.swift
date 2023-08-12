//
//  MainView.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        self.viewModel.setUpCoreData()
    }
    
    var body: some View {
        NavigationView {
            PeopleListView()
        }
        .alert("Erro ao tentar inicializar o banco de dados", isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) { }
        }
    }
}
