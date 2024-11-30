import SwiftUI

// Main Dashboard View
struct DashboardView: View {
    @State private var showUploadScreen = false
    @State private var showTrainModelScreen = false
    @State private var showViewResultsScreen = false

    // Placeholder data arrays for graph display
    @State private var yields: [Double] = []
    @State private var adjustedPredictions: [Double] = []
    @State private var timestamps: [Int] = []

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
                    showUploadScreen = true
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
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .fullScreenCover(isPresented: $showUploadScreen) {
                    CustomFileUploadScreenV2()  // Assuming this view handles file upload
                }

                // Train Your Model Button
                Button(action: {
                    showTrainModelScreen = true
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
                    .shadow(color: .green.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: $showTrainModelScreen) {
                    CustomTrainModelView()  // Assuming this view handles model training
                }

                // View Results Button
                Button(action: {
                    showViewResultsScreen = true
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
                    .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .sheet(isPresented: $showViewResultsScreen) {
                    // Pass the yields, adjustedPredictions, and timestamps arrays to the results view
                    CustomViewResultsView(
                        yields: yields,
                        adjustedPredictions: adjustedPredictions,
                        timestamps: timestamps
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
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .green.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
