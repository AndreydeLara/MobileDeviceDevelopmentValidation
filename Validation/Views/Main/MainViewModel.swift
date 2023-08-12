//
//  MainViewModel.swift
//  Validation
//
//  Created by PremierSoft on 12/08/23.
//

import Foundation

final class MainViewModel: ObservableObject {
    
    @Published var isAlertPresented: Bool = false
}

extension MainViewModel {
    func setUpCoreData() {
        CoreDataController.shared.setUp {
            DispatchQueue.main.async { [weak self] in
                self?.isAlertPresented = true
            }
        }
    }
}
