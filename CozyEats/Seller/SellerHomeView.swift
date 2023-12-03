import SwiftUI
import Charts

struct ProfitDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var profits: Int
}

struct SellerHomeView: View {
    var sevenDayData = [
        ProfitDataPoint(day: "Mon", profits: 20),
        ProfitDataPoint(day: "Tue", profits: 237),
        ProfitDataPoint(day: "Wed", profits: 108),
        ProfitDataPoint(day: "Thu", profits: 55),
        ProfitDataPoint(day: "Fri", profits: 156),
        ProfitDataPoint(day: "Sat", profits: 99),
        ProfitDataPoint(day: "Sun", profits: 305)
    ]
    
    var thirtyDayData = [
        ProfitDataPoint(day: "1", profits: 20),
        ProfitDataPoint(day: "2", profits: 237),
        ProfitDataPoint(day: "3", profits: 108),
        ProfitDataPoint(day: "4", profits: 55),
        ProfitDataPoint(day: "5", profits: 156),
        ProfitDataPoint(day: "6", profits: 99),
        ProfitDataPoint(day: "7", profits: 305),
        ProfitDataPoint(day: "8", profits: 20),
        ProfitDataPoint(day: "9", profits: 237),
        ProfitDataPoint(day: "10", profits: 108),
        ProfitDataPoint(day: "11", profits: 55),
        ProfitDataPoint(day: "12", profits: 156),
        ProfitDataPoint(day: "13", profits: 99),
        ProfitDataPoint(day: "14", profits: 305),
        ProfitDataPoint(day: "15", profits: 20),
        ProfitDataPoint(day: "16", profits: 237),
        ProfitDataPoint(day: "17", profits: 108),
        ProfitDataPoint(day: "18", profits: 55),
        ProfitDataPoint(day: "19", profits: 156),
        ProfitDataPoint(day: "20", profits: 99),
        ProfitDataPoint(day: "21", profits: 305),
        ProfitDataPoint(day: "22", profits: 20),
        ProfitDataPoint(day: "23", profits: 237),
        ProfitDataPoint(day: "24", profits: 108),
        ProfitDataPoint(day: "25", profits: 55),
        ProfitDataPoint(day: "26", profits: 156),
        ProfitDataPoint(day: "27", profits: 99),
        ProfitDataPoint(day: "28", profits: 305),
        ProfitDataPoint(day: "29", profits: 389),
        ProfitDataPoint(day: "30", profits: 500)
    ]
    
    @State private var averageIsShown7 = false
    @State private var averageIsShown30 = false   //
    @State private var sevenDayProfitsTotal = 0 // Store the total profits for 7 days here
    @State private var thirtyDayProfitsTotal = 0 // Store the total profits for 30 days here
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                   
                    
                    Text("This Week's Profits:")
                    Chart {
                        ForEach(sevenDayData) { d in
                            BarMark(
                                x: .value("Day", d.day),
                                y: .value("Profits", d.profits))
                                .annotation{
                                    Text(String(d.profits)).foregroundColor(.green)
                                }
                        }
                        
                        if averageIsShown7 {
                            let averageProfit = sevenDayProfitsTotal / 7
                            RuleMark(y: .value("Average", averageProfit))
                                .foregroundStyle(.gray)
                                .annotation(position: .bottom, alignment: .bottomLeading) {
                                    Text("Average Profit: \(averageProfit)")
                                }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    
                    Text("7-day Total: $\(calculateTotalProfits(data: sevenDayData))")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                
                    
                    Toggle(averageIsShown7 ? "show 7-day average" : "hide 7-day average" , isOn: $averageIsShown7.animation())
                        .padding()
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    Text("This Month's Profits:")
                    Chart {
                        ForEach(thirtyDayData) { d in
                            LineMark(
                                x: .value("Day", d.day),
                                y: .value("Profits", d.profits))
                        }
                        
                        if averageIsShown30 {
                            let averageProfit = thirtyDayProfitsTotal / 30
                            RuleMark(y: .value("Average", averageProfit))
                                .foregroundStyle(.gray)
                                .annotation(position: .bottom, alignment: .bottomLeading) {
                                    Text("Average Profit: \(averageProfit)")
                                }
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    
                    Text("30-day Total: $\(calculateTotalProfits(data: thirtyDayData))")
                                            .font(.headline)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding()
                
                    
                    Toggle(averageIsShown30 ? "show 30-day average" : "hide 30-day average" , isOn: $averageIsShown30.animation())
                        .padding()
                    
                    
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Page Views (last 30 days):")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Best Seller:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Total Orders:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
        .onAppear {
                sevenDayProfitsTotal = calculateTotalProfits(data: sevenDayData) // Calculate total profits for 7 days
                thirtyDayProfitsTotal = calculateTotalProfits(data: thirtyDayData) // Calculate total profits for 30 days
        }
    }
}

func calculateTotalProfits(data: [ProfitDataPoint]) -> Int {
        return data.map { $0.profits }.reduce(0, +)
    }


// Preview
struct SellerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SellerHomeView()
    }
}
