//
//  gemini.swift
//  Wash Wizard
//
//  Created by Fayaz Rafin on 2025-07-07.
//



import Foundation
import SwiftUI


struct GeminiRequest: Codable {
    let contents: [GeminiContent]
}

struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

struct GeminiPart: Codable {
    let text: String
}

struct GeminiResponse: Codable {
    let candidates: [GeminiCandidate]
}

struct GeminiCandidate: Codable {
    let content: GeminiContent
}

class GeminiService {
    private let apiKey = Bundle.main.infoDictionary?["GEMINI_API_KEY"] as? String ?? ""
    private let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="

    func generateResponse(prompt: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: endpoint + apiKey) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = GeminiRequest(contents: [
            GeminiContent(parts: [GeminiPart(text: prompt)])
        ])

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil)
                return
            }

            do {
                let decoded = try JSONDecoder().decode(GeminiResponse.self, from: data)
                let result = decoded.candidates.first?.content.parts.first?.text
                completion(result)
            } catch {
                print("Decoding error:", error)
                completion(nil)
            }
        }.resume()
    }
}

struct GeminiView: View {
    @State private var userPrompt: String = ""
    @State private var geminiResponse: String = ""
    @State private var isLoading = false

    let geminiService = GeminiService()

    var body: some View {
        VStack(spacing: 20) {
            Text("Ask Wash Wizard")
                .font(.title)
                .bold()

            TextField("Enter a question like: How do I wash silk?", text: $userPrompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                isLoading = true
                geminiService.generateResponse(prompt: userPrompt) { response in
                    DispatchQueue.main.async {
                        geminiResponse = response ?? "No response from AI"
                        isLoading = false
                    }
                }
            }) {
                Text("Ask Gemini")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(userPrompt.isEmpty)

            if isLoading {
                ProgressView("Thinking...")
            } else if !geminiResponse.isEmpty {
                ScrollView {
                    Text(geminiResponse)
                        .padding()
                }
            }

            Spacer()
        }
        .padding()
    }
}
