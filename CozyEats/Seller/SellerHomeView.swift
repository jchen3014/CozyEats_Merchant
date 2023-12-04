import SwiftUI
import Charts

struct ProfitDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var profits: Int
}

struct PageViewDataPoint: Identifiable {
    var id = UUID().uuidString
    var day: String
    var views: Int
}

struct FoodItemDataPoint: Identifiable {
    var id = UUID().uuidString
    var name: String
    var numberOrdered: Int
}

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

var pageViews = [
    PageViewDataPoint(day: "1", views: 2),
    PageViewDataPoint(day: "2", views: 23),
    PageViewDataPoint(day: "3", views: 10),
    PageViewDataPoint(day: "4", views: 5),
    PageViewDataPoint(day: "5", views: 15),
    PageViewDataPoint(day: "6", views: 9),
    PageViewDataPoint(day: "7", views: 30),
    PageViewDataPoint(day: "8", views: 2),
    PageViewDataPoint(day: "9", views: 23),
    PageViewDataPoint(day: "10", views: 10),
    PageViewDataPoint(day: "11", views: 5),
    PageViewDataPoint(day: "12", views: 15),
    PageViewDataPoint(day: "13", views: 9),
    PageViewDataPoint(day: "14", views: 30),
    PageViewDataPoint(day: "15", views: 2),
    PageViewDataPoint(day: "16", views: 23),
    PageViewDataPoint(day: "17", views: 10),
    PageViewDataPoint(day: "18", views: 5),
    PageViewDataPoint(day: "19", views: 15),
    PageViewDataPoint(day: "20", views: 9),
    PageViewDataPoint(day: "21", views: 30),
    PageViewDataPoint(day: "22", views: 2),
    PageViewDataPoint(day: "23", views: 23),
    PageViewDataPoint(day: "24", views: 10),
    PageViewDataPoint(day: "25", views: 5),
    PageViewDataPoint(day: "26", views: 15),
    PageViewDataPoint(day: "27", views: 9),
    PageViewDataPoint(day: "28", views: 30),
    PageViewDataPoint(day: "29", views: 38),
    PageViewDataPoint(day: "30", views: 50)
]

var menu: [FoodItemDataPoint] = [
    FoodItemDataPoint(name: "cookie", numberOrdered: 20),
    FoodItemDataPoint(name: "taco", numberOrdered: 5),
    FoodItemDataPoint(name: "pizza", numberOrdered: 11),
    FoodItemDataPoint(name: "burger", numberOrdered: 13)
]



struct SellerHomeView: View {

    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                    WeekProfitsView()
                    MonthProfitsView()
                    MonthPageViewsView()
                    CustomerFavoritesView()
                   
                    
       
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Orders (all-time): 1234")
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
        
    }
}

func calculateTotalProfits(data: [ProfitDataPoint]) -> Int {
        return data.map { $0.profits }.reduce(0, +)
    }

func calculateTotalPageViews(data: [PageViewDataPoint]) -> Int {
        return data.map { $0.views }.reduce(0, +)
    }

struct WeekProfitsView: View {
    @State private var averageIsShown7 = false
    @State private var sevenDayProfitsTotal = calculateTotalProfits(data: sevenDayData) // Calculate total profits for 7 days

    var body: some View {
        // View content for weekly profits
        Text("This Week's Profits")
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
    }
}
struct MonthProfitsView: View {
    @State private var averageIsShown30 = false
    @State private var thirtyDayProfitsTotal = calculateTotalProfits(data: thirtyDayData) // Calculate total profits for 30 days
    var body: some View {
        // View content for monthly profits
        Text("This Month's Profits")
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
    }
}

struct MonthPageViewsView: View {
    @State private var averageIsShownPV = false
    @State private var PageViewTotal = calculateTotalPageViews(data: pageViews)
    
    var body: some View {
    
        // View content for monthly page views
        Text("This Month's Page Views")
        Chart {
            ForEach(pageViews) { d in
                AreaMark(
                    x: .value("Day", d.day),
                    y: .value("Views", d.views))
            }
            
            if averageIsShownPV {
                let averageProfit = PageViewTotal / 30
                RuleMark(y: .value("Average", averageProfit))
                    .foregroundStyle(.gray)
                    .annotation(position: .bottom, alignment: .bottomLeading) {
                        Text("Average Views: \(averageProfit)")
                    }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        
        Text("30-day Total: \(calculateTotalPageViews(data: pageViews)) views")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
    
        
        Toggle(averageIsShownPV ? "show 30-day average" : "hide 30-day average" , isOn: $averageIsShownPV.animation())
            .padding()
    }
}

struct CustomerFavoritesView: View {
    var body: some View {
        // View content for customer favorites
        Text("Customer Favorites")
        Chart {
            ForEach(menu) { d in
                BarMark(
                    x: .value("name", d.name),
                    y: .value("numberOrdered", d.numberOrdered))
                .annotation{
                    Text(String(d.numberOrdered)).foregroundColor(.green)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
        
        if let maxItem = menu.max(by: { $0.numberOrdered < $1.numberOrdered }) {
            Text("Customer Favorite: \(maxItem.name)")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
        }

    }
}









// Preview
struct SellerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SellerHomeView()
    }
}
