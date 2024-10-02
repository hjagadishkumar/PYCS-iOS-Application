import SwiftUI
import Foundation // Ensure Foundation is imported for URLSession and Data

// Define the SwiftUI view with a unique name to avoid redeclaration conflicts
struct UniquePKLFileUploadView: View {
    @State private var selectedFileURL: URL? = nil
    @State private var isLoading = false
    @State private var responseMessage = ""
    @State private var showFilePicker = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Upload and Analyze .pkl File")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Button to select a .pkl file
            Button(action: {
                showFilePicker.toggle()
            }) {
                Text(selectedFileURL?.lastPathComponent ?? "Choose File")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .fileImporter(
                isPresented: $showFilePicker,
                allowedContentTypes: [.data],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    selectedFileURL = urls.first
                case .failure(let error):
                    responseMessage = "Error selecting file: \(error.localizedDescription)"
                }
            }

            // Button to upload and analyze the file
            Button(action: uploadFile) {
                Text("Upload and Analyze")
                    .foregroundColor(.white)
                    .padding()
                    .background(selectedFileURL == nil ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(selectedFileURL == nil)
            .padding(.horizontal, 30)

            // Show a loading spinner if uploading
            if isLoading {
                ProgressView("Uploading...")
            }

            // Display the response message
            Text(responseMessage)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Upload Data", displayMode: .inline)
    }

    // Function to upload the selected file
    private func uploadFile() {
        guard let fileURL = selectedFileURL else { return }
        isLoading = true
        responseMessage = ""

        let requestURL = URL(string: "http://127.0.0.1:5000/upload")!

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)

        if let fileData = try? Data(contentsOf: fileURL) {
            body.append(fileData)
        }

        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    responseMessage = "Upload failed: \(error.localizedDescription)"
                } else if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    responseMessage = "Server Response: \(responseString)"
                } else {
                    responseMessage = "Unexpected response from server."
                }
            }
        }.resume()
    }
}

struct UniquePKLFileUploadView_Previews: PreviewProvider {
    static var previews: some View {
        UniquePKLFileUploadView() // Preview for testing the SwiftUI view
    }
}
