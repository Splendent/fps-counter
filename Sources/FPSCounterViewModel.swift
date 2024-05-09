//
//  FPSCounterViewModel.swift
//  FPSCounter
//
//  Created by Splenden on 2024/5/9.
//

import SwiftUI
import FPSCounter

class FPSCounterViewModel:NSObject, ObservableObject {
    @Published var fps: Int = 0
    var millisecondsPerFrame: Int {
        return 1000 / max(fps, 1)
    }
    private var fpsCounter = FPSCounter()
    
    override init() {
        super.init()
        fpsCounter.delegate = self
    }
    
    func start() {
        fpsCounter.startTracking()
    }
    
    func stop() {
        fpsCounter.stopTracking()
    }
}

extension FPSCounterViewModel: FPSCounterDelegate {
    func fpsCounter(_ counter: FPSCounter, didUpdateFramesPerSecond fps: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.fps = fps
        }
    }
}
