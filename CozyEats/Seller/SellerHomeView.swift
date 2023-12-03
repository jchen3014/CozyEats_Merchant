import SwiftUI
import Charts

struct SleepDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var hours: Int
}

struct SellerHomeView: View {
    
    var data = [
        SleepDataPoint(
        day: "Mon",
        hours: 1),
        
        SleepDataPoint(
        day: "Tue",
        hours: 2),
        
        SleepDataPoint(
        day: "Wed",
        hours: 3),
        
        SleepDataPoint(
        day: "Thu",
        hours: 4),
        
        SleepDataPoint(
        day: "Fri",
        hours: 5),
        
        SleepDataPoint(
        day: "Sat",
        hours: 6),
        
        SleepDataPoint(
        day: "Sun",
        hours: 7)]
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                    Chart {
                        ForEach (data) { d in
                            BarMark(
                                x: .value("Day", d.day),
                                y: .value("Hours", d.hours))
                        }
                    }
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
