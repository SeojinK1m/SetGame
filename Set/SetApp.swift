//
//  SetApp.swift
//  Set
//
//  Created by Sam Kim on 11/16/22.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel: SetGameViewModel = SetGameViewModel()
            SetGameView(viewModel: viewModel)
        }
    }
}
