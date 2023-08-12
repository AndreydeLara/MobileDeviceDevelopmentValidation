//
//  DetailsView.swift
//  Validation
//
//  Created by PremierSoft on 10/08/23.
//

import CoreData
import SwiftUI

struct DetailsView: View {
    
    @Environment(\.dismiss) var dismiss: DismissAction
    
    @ObservedObject private var viewModel: DetailsViewModel
    
    @State private var showEditionView: Bool = false
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Group {
                    HStack(spacing: 0) {
                        Text("Name".localized() + ": ")
                            .font(.system(size: 20, weight: .bold))
                        Text(viewModel.person.name)
                            .font(.system(size: 20))
                    }
                    
                    HStack(spacing: 0) {
                        Text("Email".localized() + ": ")
                            .font(.system(size: 20, weight: .bold))
                        Text(viewModel.person.email)
                            .font(.system(size: 20))
                    }
                    
                    HStack(spacing: 0) {
                        Text("Birthday".localized() + ": ")
                            .font(.system(size: 20, weight: .bold))
                        Text("\(formattedDate(viewModel.person.birthday))")
                            .font(.system(size: 20))
                    }
                    
                    Image(uiImage: viewModel.person.photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipped()
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button {
                        showEditionView.toggle()
                    } label: {
                        Text("Edit".localized())
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Spacer()
                    Button {
                        viewModel.deletePerson(dismiss: dismiss)
                    } label: {
                        Text("Remove".localized())
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 60)
                
                Spacer()
                
                NavigationLink(isActive: $showEditionView) {
                    EditionView(viewModel: .init(person: viewModel.person))
                } label: {
                    EmptyView()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("Details".localized())
        .alert("ValidationError_Unknown".localized(), isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) { }
        }
        .onAppear { viewModel.fetchPerson() }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
