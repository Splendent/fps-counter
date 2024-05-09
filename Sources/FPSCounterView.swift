//
//  FPSCounterView.swift
//  FPSCounter
//
//  Created by Splenden on 2024/5/9.
//

import SwiftUI
import FPSCounter

public struct FPSCounterView: View {
    @StateObject private var fpsCounter = FPSCounterViewModel()
    
    public init() {
    }
    
    public var body: some View {
        
        VStack {
            Text("\(fpsCounter.fps) FPS (\(fpsCounter.millisecondsPerFrame) ms per frame)")
                .font(.title)
                .padding()
                .background(
                    Group {
                        switch fpsCounter.fps {
                        case 120...:
                            Color.purple
                        case 61...119:
                            Color.blue
                        case 46...60:
                            Color.green
                        case 36...45:
                            Color.orange
                        default:
                            Color.red
                        }
                    }
                )
                .foregroundColor(
                    fpsCounter.fps >= 35 ? .white :
                            .black
                )
        }
        .onAppear {
            fpsCounter.start()
        }
        .onDisappear {
            fpsCounter.stop()
        }
    }
}
