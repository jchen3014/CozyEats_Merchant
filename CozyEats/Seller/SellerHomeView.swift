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
                    Text("Your existing content here")
                        .padding()

                    // Display an empty bar graph
                    BarGraphView(data: emptyData, barColor: .blue) // Customize color as needed
                        .frame(height: 200) // Adjust height as per requirement
                        .padding()
                }
            }
            .navigationTitle("Cozy Eats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Add")
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
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
