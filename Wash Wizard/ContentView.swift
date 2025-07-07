//
//  ContentView.swift
//  Wash Wizard
//
//  Created by Fayaz Rafin on 2025-07-07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                CameraCaptureView()
            }
            .tabItem {
                Image(systemName: "camera.fill")
                Text("Scan")
            }

            NavigationStack {
                InfoView()
            }
            .tabItem {
                Image(systemName: "info.circle.fill")
                Text("Info")
            }
        }
        .accentColor(.blue)
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text("Welcome to Wash Wizard!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("Take a photo of your clothing tag to get wash instructions.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            NavigationLink(destination: CameraCaptureView()) {
                Label("Scan Clothing Tag", systemImage: "camera.fill")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}

struct CameraView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // TODO: Open camera
            }) {
                VStack {
                    Image(systemName: "camera.on.rectangle.fill")
                        .font(.system(size: 64))
                    Text("Open Camera")
                        .font(.headline)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Scan")
    }
}

struct InfoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("About Wash Wizard")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("""
                Wash Wizard is your AI-powered laundry assistant. \
                Snap a picture of your clothing tag, and let our AI explain \
                the care symbols and washing instructions in plain language. \
                Say goodbye to guesswork!
                """)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Info")
    }
}

#Preview {
    ContentView()
}
