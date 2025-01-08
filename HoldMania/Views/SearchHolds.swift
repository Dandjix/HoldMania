//
//  SearchHolds.swift
//  HoldMania
//
//  Created by dubreuil timon on 19/12/2024.
//

import SwiftUI

struct SizeConstants {
    static let expandedHeight: CGFloat = 600  // Height when expanded
    static let collapsedHeight: CGFloat = 50  // Height when collapsed
    static let minimumHeight: CGFloat = 50    // Minimum height to collapse to
    static let dragThreshold: CGFloat = 350   // Threshold for collapsing or expanding
}

struct SearchHolds: View {
    @EnvironmentObject var searchHoldsViewModel : SearchHoldViewModel
    @EnvironmentObject var homeViewModel : HomeViewModel

    @State private var searchHoldsHeight: CGFloat = SizeConstants.collapsedHeight
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            if searchHoldsViewModel.isLoading {
                Text("Chargement...")
            }
            else {
                VStack(alignment: .leading) {
                    
                    if(searchHoldsHeight == SizeConstants.expandedHeight)
                    {
                        // Display checkboxes for colors
                        Text("Couleurs de prises:")
                            .font(.headline)
                        ForEach(searchHoldsViewModel.colors) { color in
                            Toggle(isOn: Binding(
                                get: {
                                    // Check if the color is selected
                                    return searchHoldsViewModel.selectedColors.contains(color.id)
                                },
                                set: { newValue in
                                    if newValue {
                                        searchHoldsViewModel.selectedColors.append(color.id)
                                    } else {
                                        searchHoldsViewModel.selectedColors.removeAll { $0 == color.id }
                                    }
                                }
                            )) {
                                Text(color.holdColorName)
                                    .font(.system(size:13))
                            }
                            .toggleStyle(CheckBoxToggleStyle()) // Use CheckBox toggle style
                        }
                        
                        Divider() // Add a separator between color and level selections
                        
                        // Display checkboxes for levels
                        Text("Niveaux de difficulté:")
                            .font(.headline)
                        ForEach(searchHoldsViewModel.levels) { level in
                            Toggle(isOn: Binding(
                                get: {
                                    // Check if the color is selected
                                    return searchHoldsViewModel.selectedLevels.contains(level.id)
                                },
                                set: { newValue in
                                    if newValue {
                                        searchHoldsViewModel.selectedLevels.append(level.id)
                                    } else {
                                        searchHoldsViewModel.selectedLevels.removeAll { $0 == level.id }
                                    }
                                }
                            )) {
                                Text(level.clientLevelName)
                                    .font(.system(size:13))
                            }
                            .toggleStyle(CheckBoxToggleStyle()) // Use CheckBox toggle style
                        }
                        
                        TextField("Chercher par nom", text:$searchHoldsViewModel.searchName)
                            .padding()
                            .textFieldStyle(RoundedBorderTextFieldStyle()) // Optional style
                            .frame(width: 300)
                            .frame(maxWidth: .infinity)
                        Button(action: {
                            Task {
                                await searchHoldsViewModel.search(homeViewModel: homeViewModel)
                            }
                        }) {
                            Text("Chercher")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        HStack{
                            Spacer()
                            Image(systemName: "arrow.up")
                            Spacer()
                        }
                        .padding()
   
                    }
                    else
                    {
                        HStack{
                            Spacer()
                            Text("Options de recherche")
                            Spacer()
                        }
                            .font(.headline)
                        HStack{
                            Spacer()
                            Image(systemName: "arrow.down")
                            Spacer()
                        }

                    }
                 
                }
                .padding()
                .frame(height: searchHoldsHeight) // Dynamically change height based on drag
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Adjust the height based on drag offset
                            let newHeight = searchHoldsHeight + value.translation.height
                            if newHeight > SizeConstants.minimumHeight {  // Minimum height to keep it collapsible
                                searchHoldsHeight = newHeight
                            }
                        }
                        .onEnded { value in
                            // Smooth transition to collapsed or expanded state
                            if searchHoldsHeight < SizeConstants.dragThreshold {
                                withAnimation {
                                    searchHoldsHeight = SizeConstants.collapsedHeight  // Collapse
                                }
                            } else {
                                withAnimation {
                                    searchHoldsHeight = SizeConstants.expandedHeight  // Expand
                                }
                            }
                        }
                )
                .animation(.spring(), value: searchHoldsHeight) // Animation for smooth transition
            }
            
        }
    }
}

struct CheckBoxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .padding(.vertical, 5)
    }
}
