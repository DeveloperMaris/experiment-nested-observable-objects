//
//  FirstApproach.swift
//  NestedObservableObjects
//
//  Created by Maris Lagzdins on 05/01/2023.
//

import SwiftUI

/*
 An approach where there are no nested observable objects,
 and the ViewModel is used as a helper to display the Profile
 properties.
 */

struct FirstApproach: View {
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
                    .foregroundColor(viewModel.isSavingsReached(moneyAmount: profile.moneyAmount) ? .green : .red)
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

extension FirstApproach {
    class ViewModel: ObservableObject {
        private let formatter: NumberFormatter = .currency

        @Published var plannedSavings: Double = 0

        var localizedPlannedSavings: String {
            formatter.string(from: plannedSavings as NSNumber)!
        }

        func localized(moneyAmount: Double) -> String {
            formatter.string(from: moneyAmount as NSNumber)!
        }

        func isSavingsReached(moneyAmount: Double) -> Bool {
            moneyAmount >= plannedSavings
        }
    }
}

struct FirstApproach_Previews: PreviewProvider {
    static var previews: some View {
        FirstApproach(profile: Profile())
    }
}
