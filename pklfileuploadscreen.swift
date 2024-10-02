import SwiftUI
import UniformTypeIdentifiers

// Updated view to handle multiple file uploads
struct CustomFileUploadScreen: View {
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

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Upload Multiple Files")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // File Upload Buttons
                CustomFileUploadButton(fileURL: $targetFileURL, showPicker: $showTargetFilePicker, title: "Upload Target File")
                CustomFileUploadButton(fileURL: $boostFileURL, showPicker: $showBoostFilePicker, title: "Upload Boost File")
                CustomFileUploadButton(fileURL: $allYearsFileURL, showPicker: $showAllYearsFilePicker, title: "Upload All Years File")
                CustomFileUploadButton(fileURL: $finalYearFileURL, showPicker: $showFinalYearFilePicker, title: "Upload Final Year File")
                CustomFileUploadButton(fileURL: $targetYearFileURL, showPicker: $showTargetYearFilePicker, title: "Upload Target Year File")

                // Process Files Button
                Button(action: {
                    processFiles() // Handle the file processing
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
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss() // Navigate back
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
            .padding()
        }
    }

    // Dummy function for processing the files
    private func processFiles() {
        print("Processing files:")
        print("Target File: \(targetFileURL?.lastPathComponent ?? "No file selected")")
        print("Boost File: \(boostFileURL?.lastPathComponent ?? "No file selected")")
        print("All Years File: \(allYearsFileURL?.lastPathComponent ?? "No file selected")")
        print("Final Year File: \(finalYearFileURL?.lastPathComponent ?? "No file selected")")
        print("Target Year File: \(targetYearFileURL?.lastPathComponent ?? "No file selected")")
    }
}

// Updated reusable file upload button with a new name
struct CustomFileUploadButton: View {
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
                CustomFilePickerView(selectedFileURL: $fileURL)  // Use the renamed picker view
            }
        }
        .padding(.horizontal, 30)
    }
}

// Renamed file picker using UIKit's UIDocumentPickerViewController
struct CustomFilePickerView: UIViewControllerRepresentable {
    @Binding var selectedFileURL: URL?

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: CustomFilePickerView

        init(parent: CustomFilePickerView) {
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

struct CustomFileUploadScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomFileUploadScreen()
    }
}
