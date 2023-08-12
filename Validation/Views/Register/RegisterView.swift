//
//  ContentView.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var birthday: Date = Date()
    
    @ObservedObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Name".localized(), text: $name)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            TextField("Email".localized(), text: $email)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            DatePicker("Birthday".localized(), selection: $birthday, displayedComponents: .date)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            Button {
                viewModel.createPerson(name: name, email: email, birthday: birthday)
            } label: {
                Text("ToRegister".localized())
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Register".localized())
        .onChange(of: viewModel.shouldDismiss) { newValue in
            guard newValue else { return }
            dismiss()
        }
        .alert(
            viewModel.registerError?.description ?? "ValidationError_Unknown".localized(),
            isPresented: .constant(viewModel.registerError != nil)) {
            Button("OK", role: .cancel) {
                viewModel.registerError = nil
            }
        }
    }
}
