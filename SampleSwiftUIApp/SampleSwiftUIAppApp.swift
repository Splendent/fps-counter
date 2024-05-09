//
//  SampleSwiftUIAppApp.swift
//  SampleSwiftUIApp
//
//  Created by Splenden on 2024/5/8.
//  Copyright © 2024 konoma GmbH. All rights reserved.
//

import SwiftUI
import FPSCounter
@main
struct SampleSwiftUIAppApp: App {
    init() {
        FPSCounter.showInStatusBar()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
