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

//var sevenDayData = [
//    ProfitDataPoint(day: "Mon", profits: 20),
//    ProfitDataPoint(day: "Tue", profits: 237),
//    ProfitDataPoint(day: "Wed", profits: 108),
//    ProfitDataPoint(day: "Thu", profits: 55),
//    ProfitDataPoint(day: "Fri", profits: 156),
//    ProfitDataPoint(day: "Sat", profits: 99),
//    ProfitDataPoint(day: "Sun", profits: 305)
//]

//var thirtyDayData = [
//    ProfitDataPoint(day: "1", profits: 20),
//    ProfitDataPoint(day: "2", profits: 237),
//    ProfitDataPoint(day: "3", profits: 108),
//    ProfitDataPoint(day: "4", profits: 55),
//    ProfitDataPoint(day: "5", profits: 156),
//    ProfitDataPoint(day: "6", profits: 99),
//    ProfitDataPoint(day: "7", profits: 305),
//    ProfitDataPoint(day: "8", profits: 20),
//    ProfitDataPoint(day: "9", profits: 237),
//    ProfitDataPoint(day: "10", profits: 108),
//    ProfitDataPoint(day: "11", profits: 55),
//    ProfitDataPoint(day: "12", profits: 156),
//    ProfitDataPoint(day: "13", profits: 99),
//    ProfitDataPoint(day: "14", profits: 305),
//    ProfitDataPoint(day: "15", profits: 20),
//    ProfitDataPoint(day: "16", profits: 237),
//    ProfitDataPoint(day: "17", profits: 108),
//    ProfitDataPoint(day: "18", profits: 55),
//    ProfitDataPoint(day: "19", profits: 156),
//    ProfitDataPoint(day: "20", profits: 99),
//    ProfitDataPoint(day: "21", profits: 305),
//    ProfitDataPoint(day: "22", profits: 20),
//    ProfitDataPoint(day: "23", profits: 237),
//    ProfitDataPoint(day: "24", profits: 108),
//    ProfitDataPoint(day: "25", profits: 55),
//    ProfitDataPoint(day: "26", profits: 156),
//    ProfitDataPoint(day: "27", profits: 99),
//    ProfitDataPoint(day: "28", profits: 305),
//    ProfitDataPoint(day: "29", profits: 389),
//    ProfitDataPoint(day: "30", profits: 500)
//]

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

//var menu: [FoodItemDataPoint] = [
//    FoodItemDataPoint(name: "cookie", numberOrdered: 20),
//    FoodItemDataPoint(name: "taco", numberOrdered: 5),
//    FoodItemDataPoint(name: "pizza", numberOrdered: 11),
//    FoodItemDataPoint(name: "burger", numberOrdered: 13)
//]


@MainActor
final class SellerHomeViewModel: ObservableObject {
    @Published private(set) var user: Seller? = nil
    @Published private(set) var thirtyDayData: [ProfitDataPoint] = []
    @Published private(set) var sevenDayData: [ProfitDataPoint] = []
    @Published private(set) var menu: [FoodItemDataPoint] = []
    
    
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
        
        if let user = user, let soldItems = user.soldItems {
            for item in soldItems {
                let calendar = Calendar.current
                if let date = item.date {
                    let day = calendar.component(.day, from: date)
                    thirtyDayData.append(ProfitDataPoint(day: String(day), profits: (item.price ?? 0) * (item.quantity ?? 0)))
                    
                    if (calculateDifference(date: date) > 0 && calculateDifference(date: date) < 7) {
                        sevenDayData.append(ProfitDataPoint(day: String(day), profits: (item.price ?? 0) * (item.quantity ?? 0)))
                    }
                    
                }
            }
            thirtyDayData = thirtyDayData.sorted(by: {Int($0.day) ?? 0 < Int($1.day) ?? 0})
            sevenDayData = sevenDayData.sorted(by: {Int($0.day) ?? 0 < Int($1.day) ?? 0})
            
            for item in soldItems {
                menu.append(FoodItemDataPoint(name: item.name, numberOrdered: item.quantity ?? 0))
            }
            menu = menu.sorted(by: { $0.name < $1.name})
            
            
            
            
        }
        
        
    }
    
    func calculateDifference(date: Date) -> Int {
        let calendar = Calendar.current
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) else { return -1 }
        let endDate = date
        let difference = calendar.dateComponents([.day], from: startDate, to: endDate)
        return difference.day ?? -1
    }
    
    
}



struct SellerHomeView: View {
    
    @StateObject var viewModel = SellerHomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.tan.edgesIgnoringSafeArea(.all)
                ScrollView {
                    
//                    if let user = viewModel.user, let soldItems = user.soldItems {
//                        ForEach(soldItems) { item in
//                            VStack {
//                                Text("\(item.name)")
//                                Text("\(item.date ?? Date())")
//                                Text("quantity: \(item.quantity ?? 0)")
//                                Text("price of item: $\(item.price ?? 0)")
//                            }
//                        }
//                    }
                    
//                    Text("items in the data: \(viewModel.thirtyDayData.description)")
          
                    
                    
                    
                    WeekProfitsView(sevenDayProfitsTotal: calculateTotalProfits(data: viewModel.sevenDayData), sevenDayData: viewModel.sevenDayData)
                    MonthProfitsView(thirtyDayProfitsTotal: calculateTotalProfits(data: viewModel.thirtyDayData), thirtyDayData: viewModel.thirtyDayData)
                    MonthPageViewsView()
                    CustomerFavoritesView(menu: viewModel.menu, totals: calculateFavoriteTotals())
                   
                    
       
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total Orders (all-time): \(allTimeOrders())")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .task {
                try? await viewModel.loadCurrentUser()
            }
            .navigationTitle("\(viewModel.user?.firstName ?? "User")'s Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                }
            }
        }
        
    }
    
    func calculateFavoriteTotals() -> [String: Int] {
        var favorites: [String: Int] = [:]
        for dish in viewModel.menu {
            if favorites.keys.description.contains(dish.name) {
                favorites[dish.name]! += dish.numberOrdered
            } else {
                favorites[dish.name] = dish.numberOrdered
            }
        }
        
        return favorites
    }
    
    
    func allTimeOrders() -> Int {
        var total = 0
        let allOrders = calculateFavoriteTotals()
        for item in allOrders.values {
            total += item
        }
        
        return total
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
    let sevenDayProfitsTotal: Int    // Calculate total profits for 7 days, sevenDayData: viewModel.sevenDayData)
    let sevenDayData: [ProfitDataPoint]

    var body: some View {
        // View content for weekly profits
        Text("This Week's Profits")
        
        Chart {
            let totals = calculatebarTotal()
            ForEach(sevenDayData) { d in

                
                BarMark(
                    x: .value("Day", d.day),
                    y: .value("Profits", Double(d.profits)))
                    .annotation{
                        if let day = Int(d.day) {
                            Text("\(totals[day-1])").foregroundColor(.green)
                        }
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
    
    func calculatebarTotal() -> [Int] {
        
        var totals: [Int] = [0,0,0,0,0,0,0]
        
        for item in sevenDayData {
            if let day = Int(item.day) {
                totals[day-1] += item.profits
            }
            
        }
        
        return totals
    }
    
    
}
struct MonthProfitsView: View {
    @State private var averageIsShown30 = false
    let thirtyDayProfitsTotal: Int          // Calculate total profits for 30 days
    let thirtyDayData: [ProfitDataPoint]
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
                    .annotation(position: .bottom, alignment: .bottomTrailing) {
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










// Preview
struct SellerHomeView_Previews: PreviewProvider {
    static var previews: some View {
        SellerHomeView()
    }
}
