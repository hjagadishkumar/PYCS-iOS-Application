import SwiftUI

struct ViewResultsView: View {
    @State private var results: String = "No results available yet." // State to store and display results

    var body: some View {
        VStack(spacing: 20) {
            Text("Model Results")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Text("Visualize the model's performance and explore the results.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Placeholder for results content
            ScrollView {
                Text(results)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            .padding()

            // Button to refresh or load results
            Button(action: loadResults) {
                Text("Load Results")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("View Results", displayMode: .inline)
    }

    // Dummy function to simulate loading results
    private func loadResults() {
        results = "Displaying sample results...\nAccuracy: 92%\nError Rate: 8%\nVisualize further with charts or graphs."
    }
}

struct ViewResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewResultsView()
    }
}
