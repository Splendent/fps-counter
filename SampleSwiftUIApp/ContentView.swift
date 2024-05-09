//
//  ContentView.swift
//  SampleSwiftUIApp
//
//  Created by Splenden on 2024/5/8.
//  Copyright © 2024 konoma GmbH. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            FPSCounterView()
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
