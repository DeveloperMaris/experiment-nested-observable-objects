//
//  BadApproach.swift
//  NestedObservableObjects
//
//  Created by Maris Lagzdins on 05/01/2023.
//

import SwiftUI

/*
 This approach won't work, because nested objects will not trigger the
 ViewModel `objectWillChange` notification, which the View observes.

 Therefore if the Profile will change its properties,
 the ViewModel will not signal the ContentView to trigger update.

 There is a hack to make it update by subscribing to the `objectWillChange` property
 on the Profile and then trigger the same property on ViewModel to signal the
 View for the body update.

 ```swift
 cancellable = profile.objectWillChange.sink { [weak self] _ in
    self?.objectWillChange.send()
 }
 ```
 */

struct BadApproach: View {
    @StateObject private var viewModel: ViewModel

    init(profile: Profile) {
        _viewModel = StateObject(wrappedValue: ViewModel(profile: profile))
    }

    var body: some View {
        VStack {
            Text("Current status:")
            Text(viewModel.localizedMoney)

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

        var localizedMoney: String {
            formatter.string(from: profile.moneyAmount as NSNumber)!
        }

        init(profile: Profile) {
            self.profile = profile
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
