//
//  SearchHoldViewModel.swift
//  HoldMania
//
//  Created by dubreuil timon on 19/12/2024.
//

import Foundation

class SearchHoldViewModel: ObservableObject {
    @Published var colors: [HoldColor] = []
    @Published var levels: [ClientLevel] = []
    
    @Published var selectedColors : [Int] = []
    @Published var selectedLevels : [Int] = []
    @Published var searchName : String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        isLoading = true
        Task {
            await fetchColors()
            await fetchLevels()
            isLoading = false
        }
    }
    
    public func search(homeViewModel : HomeViewModel) async {
        homeViewModel.fetchHolds(colorOptions: selectedColors, levelOptions: selectedLevels, searchName: searchName)
    }

    private func fetchColors() async {
        guard let url = URL(string: "\(API.baseURL)/colors") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedColors = try JSONDecoder().decode([HoldColor].self, from: data)
            DispatchQueue.main.async {
                self.colors = decodedColors
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching colors: \(error.localizedDescription)"
            }
        }
    }

    private func fetchLevels() async {
        guard let url = URL(string: "\(API.baseURL)/levels") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedLevels = try JSONDecoder().decode([ClientLevel].self, from: data)
            DispatchQueue.main.async {
                self.levels = decodedLevels
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching levels: \(error.localizedDescription)"
            }
        }
    }
}
