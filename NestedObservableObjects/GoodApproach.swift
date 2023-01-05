//
//  GoodApproach.swift
//  NestedObservableObjects
//
//  Created by Maris Lagzdins on 05/01/2023.
//

import SwiftUI

/*
 A better approach is to not use nested objects and just
 use the ViewModel as an object, which helps to format the View
 and show the Profile content straight from it on the View.
 */

struct GoodApproach: View {
    @StateObject private var viewModel: ViewModel
    @ObservedObject private var profile: Profile

    init(profile: Profile) {
        _profile = ObservedObject(wrappedValue: profile)
        _viewModel = StateObject(wrappedValue: ViewModel())
    }

    var body: some View {
        VStack {
            HStack {
                Text("Planned savings:")
                Text(viewModel.localizedPlannedSavings)
                    .foregroundColor(viewModel.isPlannedSavingsReached(moneyAmount: profile.moneyAmount) ? .green : .red)
            }
            Button("Increase savings amount") {
                viewModel.plannedSavings += 10
            }

            Divider()

            HStack {
                Text("Current money amount:")
                Text(viewModel.localized(moneyAmount: profile.moneyAmount))
            }

            Button("Add money") {
                profile.addMoney()
            }
        }
        .padding()
    }
}

extension GoodApproach {
    class ViewModel: ObservableObject {
        private let formatter: NumberFormatter = .currency

        @Published var plannedSavings: Double = 0

        var localizedPlannedSavings: String {
            formatter.string(from: plannedSavings as NSNumber)!
        }

        func localized(moneyAmount: Double) -> String {
            formatter.string(from: moneyAmount as NSNumber)!
        }

        func isPlannedSavingsReached(moneyAmount: Double) -> Bool {
            moneyAmount >= plannedSavings
        }
    }
}

struct GoodApproach_Previews: PreviewProvider {
    static var previews: some View {
        GoodApproach(profile: Profile())
    }
}
