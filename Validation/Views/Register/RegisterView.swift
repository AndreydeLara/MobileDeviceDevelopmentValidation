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
    @State private var photo: UIImage = UIImage()
    
    @State private var isShowPicker: Bool = false
    
    @ObservedObject private var viewModel = RegisterViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                TextField("Name".localized(), text: $name)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                TextField("Email".localized(), text: $email)
                    .autocapitalization(.none)
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
                    isShowPicker.toggle()
                } label: {
                    Group {
                        Image(systemName: "photo")
                        Text("ChoosePhoto".localized())
                    }
                    .font(.headline)
                }
                .foregroundColor(.black)
                
                Image(uiImage: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipped()
                
                Button {
                    viewModel.createPerson(
                        name: name,
                        email: email,
                        birthday: birthday,
                        photo: photo
                    )
                } label: {
                    Text("ToRegister".localized())
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Register".localized())
        .onChange(of: viewModel.shouldDismiss) { newValue in
            guard newValue else { return }
            dismiss()
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(uiImage: $photo)
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
