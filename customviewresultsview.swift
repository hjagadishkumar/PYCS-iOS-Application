import SwiftUI
import Charts

struct CustomViewResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    var yields: [Double]
    var adjustedPredictions: [Double]
    var timestamps: [Int]

    @State private var resultsLoaded = false
    @State private var resultsMessage = "Loading results..."

    var body: some View {
        NavigationView {
            VStack {
                Text("Prediction Data Analysis")
                    .font(.largeTitle)
                    .padding()

                // Display the chart once results are loaded
                if resultsLoaded {
                    if yields.isEmpty || adjustedPredictions.isEmpty {
                        Text("No data available to display.")
                            .padding()
                            .foregroundColor(.gray)
                    } else {
                        HistoricalLineChartView(yields: yields, adjustedPredictions: adjustedPredictions, timestamps: timestamps)
                            .frame(height: 300)
                            .padding()
                    }
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
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            })
            .onAppear(perform: loadResults)  // Load results on appear
        }
    }

    // Function to simulate results loading
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

// Line chart view to display yields and adjusted predictions
struct HistoricalLineChartView: View {
    var yields: [Double]
    var adjustedPredictions: [Double]
    var timestamps: [Int]

    var body: some View {
        Chart {
            ForEach(Array(yields.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Time", index + 1),
                    y: .value("Yield", value)
                )
                .foregroundStyle(.blue)
                .symbol(Circle())
                .lineStyle(StrokeStyle(lineWidth: 2))
            }

            ForEach(Array(adjustedPredictions.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Time", timestamps[index]),
                    y: .value("Adjusted Prediction", value)
                )
                .foregroundStyle(.black)
                .symbol(.diamond)  // Use .diamond or any other available symbol
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 3]))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1))
        }
        .chartLegend(position: .top, alignment: .center)
        .chartForegroundStyleScale([
            "Yield": .blue,
            "Adjusted Prediction": .black
        ])
    }
}
