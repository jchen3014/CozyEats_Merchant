//
//  CustomerFavoritesView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 12/4/23.
//

import SwiftUI
import Charts

struct CustomerFavoritesView: View {
    
    let menu: [FoodItemDataPoint]
    let totals: [String:Int]
    
    var body: some View {
        // View content for customer favorites
        Text("Customer Favorites")
        Chart {
            ForEach(menu) { d in
                BarMark(
                    x: .value("name", d.name),
                    y: .value("numberOrdered", d.numberOrdered)
                )
                .annotation {
                    Text(String(totals[d.name] ?? 0)).foregroundColor(.green)
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
    
    func calculateFavoriteTotals() -> [String: Int] {
        var favorites: [String: Int] = [:]
        for dish in menu {
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
