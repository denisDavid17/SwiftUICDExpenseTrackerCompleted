//
//  CategoryRowView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    let category: Category
    let sum: Double
    
    var body: some View {
        
        NavigationStack {
            HStack {
                
                CategoryImageView(category: category)
                
                Text(category.rawValue.capitalized)
                Spacer()
                
                NavigationLink("\(Text(sum.formattedCurrencyText).font(.headline))") {
                    
                    LogsTabView(selectedCategories: Set(arrayLiteral: category))
                }
            }
            
        }
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: .donation, sum: 2500)
    }
}
