import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

struct CameraCaptureView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var resultText: String = ""
    let geminiService = GeminiService()

    var body: some View {
        VStack {
            Spacer()
            if let image = inputImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .padding()
            }
            Button(action: {
                showImagePicker = true
            }) {
                VStack {
                    Image(systemName: "camera.on.rectangle.fill")
                        .font(.system(size: 64))
                    Text(inputImage == nil ? "Open Camera" : "Retake Photo")
                        .font(.headline)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }
            .padding()
            Text(resultText)
                .padding()
            Spacer()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: processImage) {
            ImagePicker(image: $inputImage)
        }
        .padding()
        .navigationTitle("Scan")
    }

    private func processImage() {
        guard let uiImage = inputImage,
              let imageData = uiImage.jpegData(compressionQuality: 0.7) else { return }
        let base64String = imageData.base64EncodedString()
        let prompt = "Identify the clothing and washing instructions from this image: \(base64String)"
        geminiService.generateResponse(prompt: prompt) { response in
            DispatchQueue.main.async {
                resultText = response ?? "No information retrieved"
            }
        }
    }
}
