import SwiftUI

// Main Dashboard View
struct DashboardView: View {
    @State private var showUploadScreen = false
    @State private var showTrainModelScreen = false
    @State private var showViewResultsScreen = false

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
                    CustomFileUploadScreenV2() // Ensure this view provides feedback for success or failure
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
                    CustomTrainModelView() // This view should include a loading indicator during training
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
                    CustomViewResultsView() // Ensure it displays results clearly with possible error handling
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

// Custom Train Model View Definition
struct CustomTrainModelView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isTraining = false
    @State private var trainingMessage = "Preparing to train the model..."

    var body: some View {
        NavigationView {
            VStack {
                Text("Train Your Model")
                    .font(.largeTitle)
                    .padding()

                // Display training message or spinner
                if isTraining {
                    ProgressView("Training in progress...")
                        .padding()
                        .transition(.opacity)
                } else {
                    Text(trainingMessage)
                        .padding()
                        .transition(.slide)
                }

                Button(action: startTraining) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Training")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 5)
                }

                Spacer()
            }
            .navigationBarTitle("Train Model", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
        }
    }

    // Dummy training function
    func startTraining() {
        withAnimation {
            isTraining = true
        }
        // Simulate training delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                isTraining = false
                trainingMessage = "Training completed successfully!"
            }
        }
    }
}

// Custom View Results View Definition
struct CustomViewResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var resultsLoaded = false
    @State private var resultsMessage = "Loading results..."

    var body: some View {
        NavigationView {
            VStack {
                Text("View Results")
                    .font(.largeTitle)
                    .padding()

                // Display loading or actual results
                if resultsLoaded {
                    Text("Results are shown here.")
                        .padding()
                        .transition(.opacity) // Placeholder for real results display
                } else {
                    ProgressView(resultsMessage)
                        .padding()
                        .transition(.scale)
                }

                Spacer()
            }
            .navigationBarTitle("View Results", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                Text("Back")
            })
            .onAppear(perform: loadResults) // Load results when view appears
        }
    }

    // Dummy results loading function
    func loadResults() {
        withAnimation {
            resultsMessage = "Loading results..."
        }
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                resultsLoaded = true
                resultsMessage = "Results loaded successfully!"
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
