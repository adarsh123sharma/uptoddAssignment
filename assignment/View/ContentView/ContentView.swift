//
//  ContentView.swift
//  assignment
//
//  Created by Adarsh Sharma on 24/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @ObservedObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            VStack (spacing: .zero) {
                if let dietResponse = viewModel.dietResponse {
                    headerView
                    streakView(dietResponse: dietResponse)
                    searchView
                    
                    listView(dietResponse: dietResponse)
                    //DietListView(diets: dietResponse.allDiets ?? [])
                } else if let errorString = viewModel.errorString {
                    Text(errorString)
                        .foregroundColor(.red)
                } else {
                    ProgressView("Loading...")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    debugPrint("Back Pressed")
                } label: {
                    Image.backIcon
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
    
    private func handleSearch() {
        print("Searching for: \(searchText)")
    }
    
    // MARK: Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Everyday Diet Plan")
                    .font(.title)
                    .frame(alignment: .leading)
                Text("Track Ananya’s every meal")
                    .font(.subheadline)
                    .frame(alignment: .leading)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button {
                debugPrint("Grocery Pressed")
            } label: {
                VStack {
                    Image.groceryIcon
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Text("Grocery List")
                        .font(.system(size: 12))
                        .foregroundColor(.black)
                }
            }
        }
        .padding()
    }
    
    // MARK: Streak View
    private func streakView(dietResponse: Diets) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Diet Streak")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                HStack(spacing: 8) {
                    Image.flameIcon
                        .foregroundColor(.blue)
                    Text("1 Streak")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    let titles = ["Morning", "Afternoon", "Evening", "Night"]
                    let dietStreak = dietResponse.dietStreak ?? []
                    
                    ForEach(0..<titles.count, id: \.self) { index in
                        let statusString = index < dietStreak.count ? dietStreak[index] : ""
                        DayStreakItem(
                            title: titles[index],
                            status: DayStatus(rawValue: statusString) ?? .upcoming
                        )
                        .frame(width: 85, height: 60)
                    }
                }
            }
            .scrollIndicators(.hidden)
            .frame(height: 80)
        }
        .padding([.horizontal, .vertical], 10)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding()
    }
    
    
    // MARK: Search View
    private var searchView: some View {
        HStack {
            HStack {
                Image.magnifyingGlassIcon
                    .foregroundColor(.gray)
                TextField("Search Meals", text: $searchText)
                    .submitLabel(.search)
                    .onSubmit {
                        handleSearch()
                    }
            }
            .padding()
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            Spacer(minLength: 15)
            Button {
                debugPrint("Filter Pressed")
            } label: {
                Image.filterIcon
                    .resizable()
                    .frame(width: 40, height: 40)
            }
        }
        .padding()
    }
    
    // MARK: List View
    private func listView(dietResponse: Diets) -> some View {
        List {
            ForEach(dietResponse.allDiets ?? [], id: \.timings) { diet in
                Section(header: sectionUI(allDiet: diet)) {
                    ForEach(diet.recipes ?? [], id: \.title) { recipe in
                        rowUI(recipe: recipe)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //MARK: List Section
    private func sectionUI(allDiet: AllDiets) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(allDiet.daytime ?? "N/A")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.black)
                Text(allDiet.timings ?? "N/A")
                    .font(.system(size: 14, weight: .regular))
                    .textCase(.uppercase)
            }
            Spacer()
            circularCapacityGauge(current: Double(allDiet.progressStatus?.completed ?? 0), min: .zero, max: Double(allDiet.progressStatus?.total ?? 0))
        }
        .padding(.bottom, 10)
    }
    
    //MARK: List Row
    private func rowUI(recipe: Recipes) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(recipe.timeSlot ?? "N/A")
                .textCase(.uppercase)
                .fontWeight(.bold)
                .foregroundStyle(.gray)
            HStack(spacing: 5) {
                asyncImage(urlString: recipe.image ?? "")
                    .padding([.leading, .vertical], 5)
                recipeData(recipe: recipe)
                    .frame(maxWidth: .infinity)
                    .padding([.trailing, .vertical], 5)
            }
            .frame(maxWidth: .infinity)
            .background(.purple.opacity(0.1))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }
    
    
    //MARK: Row Image
    private func asyncImage(urlString: String) -> some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 100, height: 100)
            } else if phase.error != nil {
                Text("Failed to load image")
                    .foregroundColor(.red)
            } else {
                ProgressView() // Loading indicator while the image loads
            }
        }
    }
    
    //MARK: Row Content
    private func recipeData(recipe: Recipes) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(recipe.title ?? "N/A")
                .font(.headline)
                .padding(.bottom, 15)
            
            // Subtext
            Group {
                HStack {
                    Image.clockIcon
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.gray)
                    Text("\(recipe.duration ?? 0) mins")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(5)
            }
            .background(.white)
            .cornerRadius(3)
            
            // Action Buttons
            HStack {
                Button(action: {
                    debugPrint("Customize Pressed")
                }) {
                    HStack {
                        Image.customiseIcon
                            .foregroundColor(.white)
                        Text("Customize")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.indigo)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    debugPrint("Fed Pressed")
                }) {
                    HStack {
                        Image.fedCheckmarkIcon
                            .foregroundColor(.indigo)
                        Text("Fed?")
                            .font(.subheadline)
                            .foregroundColor(.indigo)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.purple.opacity(0.1))
                    .cornerRadius(12)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.indigo, lineWidth: 2)
                    }
                }
            }
        }
        
    }
    
    //MARK: Section Gauge
    private func circularCapacityGauge(current: Double, min: Double, max: Double ) -> some View {
        Gauge(value: current, in: min...max) {
        } currentValueLabel: {
            Text("Status\n\(Int(current)) of \(Int(max))")
                .frame(alignment: .center)
        } minimumValueLabel: {
            Text("\(Int(min))")
        } maximumValueLabel: {
            Text("\(Int(max))")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.pink)
        .frame(width: 64, height: 64)
    }
}

//MARK: Preview
#Preview {
    ContentView()
}
