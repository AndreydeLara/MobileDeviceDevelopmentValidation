//
//  EditionView.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import SwiftUI

struct EditionView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @ObservedObject private var viewModel: EditionViewModel
    
    init(viewModel: EditionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Name".localized(), text: $viewModel.person.name)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            TextField("Email".localized(), text: $viewModel.person.email)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            DatePicker("Birthday".localized(), selection: $viewModel.person.birthday, displayedComponents: .date)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button {
                viewModel.editPerson()
            } label: {
                Text("Register".localized())
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Edition".localized())
        .onChange(of: viewModel.shouldDismiss) { newValue in
            guard newValue else { return }
            dismiss()
        }
        .alert(
            viewModel.registerError?.description ?? "Ocorreu um problema",
            isPresented: .constant(viewModel.registerError != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.registerError = nil
                }
            }
    }
}
