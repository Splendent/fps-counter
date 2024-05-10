//
//  FPSCounterTests.swift
//  FPSCounterTests
//
//  Created by Splenden on 2024/5/10.
//  Copyright © 2024 konoma GmbH. All rights reserved.
//

import XCTest
@testable import FPSCounter

class FPSCounterTests: XCTestCase {
    var fpsCounter: FPSCounter!
    var mockFPSCounter: MockFPSCounter!
    var mockDelegate: MockFPSCounterDelegate!
    var mockDisplayLinkProxy: MockDisplayLinkProxy!
    
    override func setUp() {
        super.setUp()
        fpsCounter = FPSCounter()
        mockFPSCounter = MockFPSCounter()
        mockDelegate = MockFPSCounterDelegate()
        mockDisplayLinkProxy = MockDisplayLinkProxy()
        mockDisplayLinkProxy.parentCounter = mockFPSCounter
        mockFPSCounter.delegate = mockDelegate
        mockFPSCounter.mockDisplayLinkProxy = mockDisplayLinkProxy
    }
    
    override func tearDown() {
        fpsCounter = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    func testFPSCounterInitialization() {
        let mirror = Mirror(reflecting: fpsCounter!)
        let privateDisplayLink = mirror.descendant("displayLink") as? CADisplayLink
        XCTAssertNotNil(privateDisplayLink)
        let privateDisplayLinkProxy = mirror.descendant("displayLinkProxy") as? FPSCounter.DisplayLinkProxy
        XCTAssertNotNil(privateDisplayLinkProxy)
        XCTAssertNotNil(privateDisplayLinkProxy?.parentCounter)
    }
    
    func testStartAndStopTracking() {
        let mirror = Mirror(reflecting: fpsCounter!)
        var privateRunloop = mirror.descendant("runloop") as? RunLoop
        var privateMode = mirror.descendant("mode") as? RunLoop.Mode
        XCTAssertNil(privateRunloop)
        XCTAssertNil(privateMode)
        
        fpsCounter.startTracking()
        privateRunloop = mirror.descendant("runloop") as? RunLoop
        privateMode = mirror.descendant("mode") as? RunLoop.Mode
        XCTAssertNotNil(privateRunloop)
        XCTAssertNotNil(privateMode)
        
        fpsCounter.stopTracking()
        privateRunloop = mirror.descendant("runloop") as? RunLoop
        privateMode = mirror.descendant("mode") as? RunLoop.Mode
        XCTAssertNil(privateRunloop)
        XCTAssertNil(privateMode)
    }

    func testUpdateFromDisplayLinkWithMockDisplayLink() {
        let expectation = XCTestExpectation(description: "Update from display link")
        mockDelegate.expectation = expectation

        let displayLink = CADisplayLink(target: mockFPSCounter.displayLinkProxy, selector: #selector(mockFPSCounter.displayLinkProxy.updateFromDisplayLink(_:)))
        mockFPSCounter.displayLinkProxy.updateFromDisplayLink(displayLink)
        DispatchQueue.global().asyncAfter(deadline: .now() + fpsCounter.notificationDelay * 2) {
            self.mockFPSCounter.displayLinkProxy.updateFromDisplayLink(displayLink) //this should execute while fpsCounter.notificationDelay * 2
        }

        wait(for: [expectation], timeout: fpsCounter.notificationDelay * 5)

        XCTAssertTrue(mockDisplayLinkProxy.updateFromDisplayLinkCalled)
        XCTAssertTrue(mockDelegate.didUpdateFramesPerSecondCalled)
    }
}

class MockFPSCounter: FPSCounter {
    var mockDisplayLinkProxy: MockDisplayLinkProxy!

    var displayLinkProxy: DisplayLinkProxy {
        return mockDisplayLinkProxy
    }
}

class MockDisplayLinkProxy: FPSCounter.DisplayLinkProxy {
    @objc var updateFromDisplayLinkCalled = false

    @objc override func updateFromDisplayLink(_ displayLink: CADisplayLink) {
        super.updateFromDisplayLink(displayLink)
        updateFromDisplayLinkCalled = true
    }
}

class MockFPSCounterDelegate:NSObject, FPSCounterDelegate {
    var didUpdateFramesPerSecondCalled = false
    var expectation: XCTestExpectation?
    
    func fpsCounter(_ counter: FPSCounter, didUpdateFramesPerSecond fps: Int) {
        didUpdateFramesPerSecondCalled = true
        expectation?.fulfill()
    }
}
