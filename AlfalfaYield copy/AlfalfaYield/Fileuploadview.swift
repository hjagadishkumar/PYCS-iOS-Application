import SwiftUI

struct PKLFileUploadViewUpdated: View {  // Changed the name to avoid redeclaration issues
    @State private var selectedFileURL: URL? = nil
    @State private var isLoading = false
    @State private var responseMessage = ""
    @State private var showFilePicker = false
    @State private var metrics: [String: Double] = [:]

    var body: some View {
        VStack(spacing: 20) {
            Text("Upload and Analyze .pkl File")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

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

            Button(action: uploadFile) {
                Text("Upload and Analyze")
                    .foregroundColor(.white)
                    .padding()
                    .background(selectedFileURL == nil ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(selectedFileURL == nil)
            .padding(.horizontal, 30)

            if isLoading {
                ProgressView("Uploading...")
            }

            Text(responseMessage)
                .foregroundColor(.gray)
                .padding(.top, 10)

            if !metrics.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(metrics.keys.sorted(), id: \.self) { key in
                        HStack {
                            Text("\(key):")
                            Spacer()
                            Text("\(metrics[key] ?? 0)")
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Upload Data", displayMode: .inline)
    }

    private func uploadFile() {
        guard let fileURL = selectedFileURL else { return }
        isLoading = true
        responseMessage = ""
        metrics.removeAll()

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
                } else if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let result = jsonResponse["result"] as? [String: Double] {
                            metrics = result
                            responseMessage = "Metrics received successfully!"
                        } else {
                            responseMessage = "Unexpected response format."
                        }
                    } catch {
                        responseMessage = "Error parsing response: \(error.localizedDescription)"
                    }
                } else {
                    responseMessage = "Unexpected response from server."
                }
            }
        }.resume()
    }
}

struct PKLFileUploadViewUpdated_Previews: PreviewProvider {
    static var previews: some View {
        PKLFileUploadViewUpdated() // Updated preview to match new struct name
    }
}
