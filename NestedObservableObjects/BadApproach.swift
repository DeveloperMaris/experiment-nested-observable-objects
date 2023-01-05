//
//  BadApproach.swift
//  NestedObservableObjects
//
//  Created by Maris Lagzdins on 05/01/2023.
//

import Combine
import SwiftUI

/*
 This approach won't work, because nested objects will not trigger the
 ViewModel `objectWillChange` notification, which the View observes.

 Therefore if the Profile will change its properties,
 the ViewModel will not signal the ContentView to trigger update.

 There is a hack to make it update by subscribing to the `objectWillChange` property
 on the Profile and then trigger the same property on ViewModel to signal the
 View for the body update.
 */

struct BadApproach: View {
    @StateObject private var viewModel: ViewModel

    init(profile: Profile) {
        _viewModel = StateObject(wrappedValue: ViewModel(profile: profile))
    }

    var body: some View {
        VStack {
            HStack {
                Text("Planned savings:")
                Text(viewModel.localizedPlannedSavings)
                    .foregroundColor(viewModel.isPlannedSavingsReached ? .green : .red)
            }
            Button("Increase savings amount") {
                viewModel.plannedSavings += 10
            }

            Divider()

            HStack {
                Text("Current money amount:")
                Text(viewModel.localizedMoney)
            }

            Button("Add money") {
                viewModel.addMoney()
            }
        }
        .padding()
    }
}

extension BadApproach {
    class ViewModel: ObservableObject {
        private let formatter: NumberFormatter = .currency
        private var profile: Profile
        private var cancellable: AnyCancellable?

        @Published var plannedSavings: Double = 0

        var localizedPlannedSavings: String {
            formatter.string(from: plannedSavings as NSNumber)!
        }

        var localizedMoney: String {
            formatter.string(from: profile.moneyAmount as NSNumber)!
        }

        var isPlannedSavingsReached: Bool {
            profile.moneyAmount >= plannedSavings
        }

        init(profile: Profile) {
            self.profile = profile

            // Need to manually observe and trigger view update if the Profile property changes it's properties.
            cancellable = profile.objectWillChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        }

        func addMoney() {
            profile.addMoney()
        }
    }
}

struct BadApproach_Previews: PreviewProvider {
    static var previews: some View {
        BadApproach(profile: Profile())
    }
}
