import SwiftUI
import UniformTypeIdentifiers

// Main view to handle multiple file uploads
struct CustomFileUploadScreenV2: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var targetFileURL: URL?
    @State private var boostFileURL: URL?
    @State private var allYearsFileURL: URL?
    @State private var finalYearFileURL: URL?
    @State private var targetYearFileURL: URL?

    @State private var showTargetFilePicker = false
    @State private var showBoostFilePicker = false
    @State private var showAllYearsFilePicker = false
    @State private var showFinalYearFilePicker = false
    @State private var showTargetYearFilePicker = false

    @State private var isLoading = false
    @State private var responseMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Upload Multiple Files")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // File Upload Buttons
                CustomFileUploadButtonV2(fileURL: $targetFileURL, showPicker: $showTargetFilePicker, title: "Upload Target File")
                CustomFileUploadButtonV2(fileURL: $boostFileURL, showPicker: $showBoostFilePicker, title: "Upload Boost File")
                CustomFileUploadButtonV2(fileURL: $allYearsFileURL, showPicker: $showAllYearsFilePicker, title: "Upload All Years File")
                CustomFileUploadButtonV2(fileURL: $finalYearFileURL, showPicker: $showFinalYearFilePicker, title: "Upload Final Year File")
                CustomFileUploadButtonV2(fileURL: $targetYearFileURL, showPicker: $showTargetYearFilePicker, title: "Upload Target Year File")

                // Process Files Button
                Button(action: {
                    processFiles() // Handle the file processing
                }) {
                    HStack {
                        Image(systemName: "tray.and.arrow.up.fill")
                            .foregroundColor(.white)
                        Text("Process Files")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .disabled(isLoading)

                // Show a loading spinner if uploading
                if isLoading {
                    ProgressView("Uploading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                }

                // Display the response message
                Text(responseMessage)
                    .foregroundColor(.gray)
                    .padding(.top, 10)

                Spacer()
            }
            .navigationBarTitle("Upload Data", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss() // Navigate back
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            })
            .padding()
            .background(
                LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }

    // Function to process and upload the files
    private func processFiles() {
        // Ensure at least one file is selected
        guard let targetFileURL = targetFileURL else {
            responseMessage = "Please select at least the Target File."
            return
        }

        isLoading = true
        responseMessage = ""

        // Replace this URL with your backend's URL
        let requestURL = URL(string: "http://127.0.0.1:5000/upload")!

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Prepare the multipart form data
        var body = Data()

        // Function to append a file to the form data
        func appendFileData(url: URL?, fieldName: String) {
            guard let fileURL = url else { return }
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            if let fileData = try? Data(contentsOf: fileURL) {
                body.append(fileData)
            }
            body.append("\r\n".data(using: .utf8)!)
        }

        // Append each file to the form data with unique field names
        appendFileData(url: targetFileURL, fieldName: "target_file")
        appendFileData(url: boostFileURL, fieldName: "boost_file")
        appendFileData(url: allYearsFileURL, fieldName: "all_years_file")
        appendFileData(url: finalYearFileURL, fieldName: "final_year_file")
        appendFileData(url: targetYearFileURL, fieldName: "target_year_file")

        // Closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        // Send the request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    responseMessage = "Upload failed: \(error.localizedDescription)"
                } else if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    responseMessage = "Server error: Received HTTP status code \(httpResponse.statusCode)"
                } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    responseMessage = "Server Response: \(responseString)"
                } else {
                    responseMessage = "Unexpected response from server."
                }
            }
        }.resume()
    }
}

// Reusable file upload button with renamed struct
struct CustomFileUploadButtonV2: View {
    @Binding var fileURL: URL?
    @Binding var showPicker: Bool
    var title: String

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                showPicker = true  // Show the file picker
            }) {
                HStack {
                    Text(fileURL?.lastPathComponent ?? title)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "doc.fill")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1)
                )
            }
            .sheet(isPresented: $showPicker) {
                CustomFilePickerViewV2(selectedFileURL: $fileURL)  // Renamed picker view
            }
        }
        .padding(.horizontal, 30)
    }
}

// File picker using UIKit's UIDocumentPickerViewController with renamed struct
struct CustomFilePickerViewV2: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: CustomFilePickerViewV2

        init(parent: CustomFilePickerViewV2) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let selectedFile = urls.first {
                parent.selectedFileURL = selectedFile
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation if needed
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No update required
    }
}

struct CustomFileUploadScreenV2_Previews: PreviewProvider {
    static var previews: some View {
        CustomFileUploadScreenV2()
    }
}
