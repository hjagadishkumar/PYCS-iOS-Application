import SwiftUI

struct TrainModelView: View {
    @State private var trainingStatus: String = "Ready to Train Model" // State to display training status
    @State private var isTraining = false // State to show loading spinner

    var body: some View {
        VStack(spacing: 20) {
            Text("Train Your Model")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Choose model type and start training based on uploaded data.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Button to start training
            Button(action: startTraining) {
                Text("Start Training")
                    .foregroundColor(.white)
                    .padding()
                    .background(isTraining ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .disabled(isTraining)

            // Show a loading spinner if training
            if isTraining {
                ProgressView("Training in progress...")
            }

            // Display the current training status
            Text(trainingStatus)
                .foregroundColor(.gray)
                .padding(.top, 20)

            Spacer()
        }
        .padding()
        .navigationBarTitle("Train Model", displayMode: .inline)
    }

    // Dummy function to simulate training
    private func startTraining() {
        isTraining = true
        trainingStatus = "Training started..."

        // Simulate training process
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isTraining = false
            trainingStatus = "Training completed successfully!"
        }
    }
}

struct TrainModelView_Previews: PreviewProvider {
    static var previews: some View {
        TrainModelView()
    }
}
