//
//  EditionView.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import SwiftUI

struct EditionView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @State private var isShowPicker: Bool = false
    
    @ObservedObject private var viewModel: EditionViewModel
    
    
    init(viewModel: EditionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
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
                
                Image(uiImage: viewModel.person.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipped()
                
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
                
                Button {
                    viewModel.editPerson()
                } label: {
                    Text("Edit".localized())
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Edition".localized())
        .onChange(of: viewModel.shouldDismiss) { newValue in
            guard newValue else { return }
            dismiss()
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(uiImage: $viewModel.person.photo)
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
