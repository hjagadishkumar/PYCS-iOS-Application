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
    @State private var yields: [Double] = []
    @State private var adjustedPredictions: [Double] = []
    @State private var timestamps: [Int] = []
    @State private var showResultsScreen = false

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
                Button(action: { processFiles() }) {
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
                .fullScreenCover(isPresented: $showResultsScreen) {
                    CustomViewResultsView(yields: yields, adjustedPredictions: adjustedPredictions, timestamps: timestamps)
                }

                // Show loading spinner if uploading
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
                presentationMode.wrappedValue.dismiss()
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

    // Updated processFiles function to handle multiple file uploads
    private func processFiles() {
        guard let targetFileURL = targetFileURL,
              let boostFileURL = boostFileURL,
              let allYearsFileURL = allYearsFileURL,
              let finalYearFileURL = finalYearFileURL,
              let targetYearFileURL = targetYearFileURL else {
            responseMessage = "Please select all required files."
            return
        }

        isLoading = true
        responseMessage = ""

        let requestURL = URL(string: "http://172.20.208.90:5000/upload")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Prepare the multipart form data
        var body = Data()

        // Helper function to append file data
        func appendFileData(url: URL, fieldName: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(url.lastPathComponent)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
            if let fileData = try? Data(contentsOf: url) {
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
                } else if let data = data {
                    // Parse JSON response data if available
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let yieldsArray = jsonResponse["all_years_data"] as? [[String: Any]],
                           let adjustedPredictionsArray = jsonResponse["adjusted_predictions"] as? [Double],
                           let timestampsArray = jsonResponse["prediction_timestamps"] as? [Int] {

                            // Extract yields data
                            self.yields = yieldsArray.compactMap { $0["yield"] as? Double }
                            self.adjustedPredictions = adjustedPredictionsArray
                            self.timestamps = timestampsArray

                            responseMessage = "Files processed successfully!"
                            showResultsScreen = true  // Navigate to results screen
                        } else {
                            responseMessage = "Unexpected response format."
                        }
                    } catch {
                        responseMessage = "Error parsing server response."
                    }
                } else {
                    responseMessage = "Unexpected response from server."
                }
            }
        }.resume()
    }
}

// Custom file upload button that triggers a file picker
struct CustomFileUploadButtonV2: View {
    @Binding var fileURL: URL?  // Stores the selected file URL
    @Binding var showPicker: Bool  // Controls the display of the file picker
    var title: String  // Title of the upload button

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: { showPicker = true }) {
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
                CustomFilePickerViewV2(selectedFileURL: $fileURL)
            }
        }
        .padding(.horizontal, 30)
    }
}

// Custom file picker using UIDocumentPickerViewController
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

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
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
        // No updates needed
    }
}
