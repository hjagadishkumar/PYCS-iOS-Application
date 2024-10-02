import SwiftUI

struct DashboardView: View {
    @State private var showUploadScreen = false  // To track file picker navigation

    var body: some View {
        VStack {
            Spacer()

            // Title Section
            Text("Precision Agriculture Model Trainer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)

            Text("Upload your data, train models, and predict crop yields with ease.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 30)

            // Option Cards in Vertical Stacking for iOS-friendly Layout
            VStack(spacing: 20) {
                
                // Upload Data Button
                Button(action: {
                    showUploadScreen = true  // Navigate to the file upload screen
                }) {
                    VStack {
                        Text("Upload Data")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        Text("Upload CSV or Excel files containing crop data.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
                .fullScreenCover(isPresented: $showUploadScreen) {
                    FileUploadView()  // Open file upload screen
                }

                // Train Your Model Button
                Button(action: {
                    // Action for training model
                }) {
                    VStack {
                        Text("Train Your Model")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        Text("Choose model type and train on uploaded data.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.green, lineWidth: 2)
                    )
                }

                // View Results Button
                Button(action: {
                    // Action for viewing results
                }) {
                    VStack {
                        Text("View Results")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)

                        Text("Visualize the model’s performance and explore the results.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.orange, lineWidth: 2)
                    )
                }
            }

            Spacer()

            // Footer
            Text("Need help? Visit our Help Page or contact support.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
    }
}
