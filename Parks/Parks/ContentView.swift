//
//  ContentView.swift
//  Parks
//
//  Created by Athena Lopez on 3/3/26.
//

import SwiftUI

struct ContentView: View {

    @State private var parks: [Park] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(parks) { park in
                        NavigationLink(value: park) {
                            ParkRow(park: park)
                        }
                    }
                }
            }
            .navigationDestination(for: Park.self) { park in
                ParkDetailView(park: park)
            }
            .navigationTitle("National Parks") 
        }
        .padding()
        .onAppear(perform: {
            Task {
                await fetchParks()
            }
        })
    }

    private func fetchParks() async {
        let url = URL(string: "https://developer.nps.gov/api/v1/parks?stateCode=ca&api_key=3qpgxlWlXTuzo1LfO8MbqzJcTmMiyuQAY2gBYaJc")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parksResponse = try JSONDecoder().decode(ParksResponse.self, from: data)
            let parks = parksResponse.data
            
            for park in parks {
                print(park.fullName)
            }
            
            self.parks = parks
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ParkRow: View {
    let park: Park

    var body: some View {
        Rectangle()
            .aspectRatio(4/3, contentMode: .fit)
            .overlay {
                let image = park.images.first
                let urlString = image?.url
                let url = urlString.flatMap { string in
                    URL(string: string)
                }
                
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color(.systemGray4)
                }
            }
            .overlay(alignment: .bottomLeading) {
                Text(park.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
            }
            .cornerRadius(16)
            .padding(.horizontal)
    }
}


#Preview {
    ContentView()
}
