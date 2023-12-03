import SwiftUI
import Charts

struct ProfitDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var profits: Int
}

struct SellerHomeView: View {
    var data = [
        ProfitDataPoint(day: "Mon", profits: 5),
        ProfitDataPoint(day: "Tue", profits: 3),
        ProfitDataPoint(day: "Wed", profits: 10),
        ProfitDataPoint(day: "Thu", profits: 2),
        ProfitDataPoint(day: "Fri", profits: 6),
        ProfitDataPoint(day: "Sat", profits: 3),
        ProfitDataPoint(day: "Sun", profits: 7)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                    Chart {
                        ForEach(data) { d in
                            BarMark(
                                x: .value("Day", d.day),
                                y: .value("Profits", d.profits))
                                .annotation{
                                    Text(String(d.profits))
                                }
                        }
                    }
                    
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
                    }
                    .padding()
                }
            }
            .navigationTitle("Your Business Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
