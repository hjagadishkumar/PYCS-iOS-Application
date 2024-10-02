import SwiftUI
import UIKit

struct FileUploadView: View {
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

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Upload Multiple Files")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Target File Upload
                FileUploadButton(fileURL: $targetFileURL, showPicker: $showTargetFilePicker, title: "Upload Target File")

                // Boost File Upload
                FileUploadButton(fileURL: $boostFileURL, showPicker: $showBoostFilePicker, title: "Upload Boost File")

                // All Years File Upload
                FileUploadButton(fileURL: $allYearsFileURL, showPicker: $showAllYearsFilePicker, title: "Upload All Years File")

                // Final Year File Upload
                FileUploadButton(fileURL: $finalYearFileURL, showPicker: $showFinalYearFilePicker, title: "Upload Final Year File")

                // Target Year File Upload
                FileUploadButton(fileURL: $targetYearFileURL, showPicker: $showTargetYearFilePicker, title: "Upload Target Year File")

                // Process Button
                Button(action: {
                    processFiles()  // Handle file processing logic here
                }) {
                    Text("Process Files")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 30)

                Spacer()
            }
            .navigationBarTitle("Upload Data", displayMode: .inline)
            .padding()
        }
    }

    // Function to process the files (dummy function for now)
    func processFiles() {
        // Example logic for handling file uploads
        print("Processing files:")
        print("Target File: \(targetFileURL?.lastPathComponent ?? "No file selected")")
        print("Boost File: \(boostFileURL?.lastPathComponent ?? "No file selected")")
        print("All Years File: \(allYearsFileURL?.lastPathComponent ?? "No file selected")")
        print("Final Year File: \(finalYearFileURL?.lastPathComponent ?? "No file selected")")
        print("Target Year File: \(targetYearFileURL?.lastPathComponent ?? "No file selected")")
    }
}

// Reusable file upload button
struct FileUploadButton: View {
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
            }
            .sheet(isPresented: $showPicker) {
                FilePickerView(selectedFileURL: $fileURL)
            }
        }
        .padding(.horizontal, 30)
    }
}

// File picker using UIKit's UIDocumentPickerViewController
struct FilePickerView: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: FilePickerView

        init(parent: FilePickerView) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let selectedFile = urls.first {
                parent.selectedFileURL = selectedFile
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // No update needed
    }
}
