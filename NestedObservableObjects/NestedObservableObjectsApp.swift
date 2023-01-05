//
//  NestedObservableObjectsApp.swift
//  NestedObservableObjects
//
//  Created by Maris Lagzdins on 05/01/2023.
//

import SwiftUI

class Profile: ObservableObject {
    @Published var moneyAmount: Double = 0.0

    func addMoney() {
        moneyAmount += Double.random(in: 1...10)
    }
}

@main
struct NestedObservableObjectsApp: App {
    @StateObject private var profile = Profile()

    var body: some Scene {
        WindowGroup {
            TabView {
                BadApproach(profile: profile)
                    .tabItem {
                        Text("Bad approach")
                    }

                GoodApproach(profile: profile)
                    .tabItem {
                        Text("Good approach")
                    }
            }
        }
    }
}

extension NumberFormatter {
    public static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.roundingMode = .halfUp    // 21.586 to 21.59, but 21.582 to 21.58
        formatter.maximumFractionDigits = 2 // to display 2.5021 as 2.50
        formatter.minimumFractionDigits = 2 // to display 2 as 2.00
        formatter.currencyCode = "EUR"
        return formatter
    }()
}
