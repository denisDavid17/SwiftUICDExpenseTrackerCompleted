//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    
    var body: some View {
        
        NavigationStack {
        
            VStack(spacing: 30) {
                
                VStack(spacing: 5) {
                    if totalExpenses != nil {
                        Text("Total Expenses")
                            .font(.system(size: 30)).bold()
                        if totalExpenses != nil {
                            Text(totalExpenses!.formattedCurrencyText)
                                .font(.system(size: 45)).bold()
                        }
                    }
                }
                
                if categoriesSum != nil {
                    if totalExpenses != nil && totalExpenses! > 0 {
                        PieChartView(
                            data: categoriesSum!.map { ($0.sum, $0.category.color) },
                            style: Styles.pieChartStyleOne,
                            form: CGSize(width: 300, height: 240),
                            dropShadow: false
                        )
                    }
                    
                    Divider()
                    
                    Text("Breakdown").font(.headline)
                        .font(.system(size: 20)).bold()
                       
                    
                    VStack(spacing: 20) {
                        
                        ForEach(self.categoriesSum!) {
                            CategoryRowView(category: $0.category, sum: $0.sum)
                        }
                        
                        
                    }
                    
                    Spacer()
                }
                
                if totalExpenses == nil && categoriesSum == nil {
                    Text("No expenses data\nPlease add your expenses from the logs tab")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .onAppear(perform: fetchTotalSums)
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
