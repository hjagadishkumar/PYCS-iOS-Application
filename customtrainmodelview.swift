import SwiftUI

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
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            })
        }
    }

    // Dummy training function to simulate training delay
    func startTraining() {
        withAnimation {
            isTraining = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                isTraining = false
                trainingMessage = "Training completed successfully!"
            }
        }
    }
}

struct CustomTrainModelView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTrainModelView()
    }
}
