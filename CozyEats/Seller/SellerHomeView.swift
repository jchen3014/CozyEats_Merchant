import SwiftUI

struct BarGraphView: View {
    let data: [Double]
    let barColor: Color
    let barSpacing: CGFloat = 8.0

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: barSpacing) {
                ForEach(data.indices, id: \.self) { index in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(barColor)
                            .frame(width: geometry.size.width / CGFloat(data.count) - barSpacing,
                                   height: CGFloat(data[index]) * geometry.size.height)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct SellerHomeView: View {
    // Example data for the empty bar graph
    let emptyData: [Double] = [0, 0, 0, 0, 0] // Add the necessary data points

    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                    // Your existing content
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Profits:")
                            .font(.headline)
                        
                        Text("Your 7-Day Profits:")
                            .font(.headline)
                        
                        Text("Your 30-Day Profits:")
                            .font(.headline)
                            .padding(.top)

                        Text("Page Views (last 30 days):")
                            .font(.headline)

                        Text("Best Seller:")
                            .font(.headline)
                        
                        Text("Total Orders:")
                            .font(.headline)
                        

                        // Display an empty bar graph
                        BarGraphView(data: emptyData, barColor: .blue) // Customize color as needed
                            .frame(height: 200) // Adjust height as per requirement
                            .padding()
                    }
                    .padding()
                }
            }
            .navigationTitle("Your Business Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Add any additional toolbar items if needed
                }
            }
        }
    }
}

// Preview
struct SellerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SellerHomeView()
    }
}





//AnalyticsManager.shared.log(.menuSelected(.init(menuName: "Jackie's Restaurant", origin: "rmMenuViewController", timestamp: Date())))
