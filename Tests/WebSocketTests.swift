//
//  WebSocketTests.swift
//  Alamofire
//
//  Created by Jon Shier on 1/17/21.
//  Copyright © 2021 Alamofire. All rights reserved.
//

import Alamofire
import Foundation
import XCTest

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 12, *)
final class WebSocketTests: BaseTestCase {
    func testThatWebSocketsCanReceiveMessages() {
        // Given
        let session = Session(eventMonitors: [NSLoggingEventMonitor()])
        let didReceiveMessage = expectation(description: "didReceive")
        var message: URLSessionWebSocketTask.Message?
        
        // When
        session.websocketRequest(.websocket()).responseMessage { event in
            switch event {
            case .connected:
                break
            case let .receivedMessage(receivedMessage):
                message = receivedMessage
                didReceiveMessage.fulfill()
            case .disconnected:
                break
            }
        }
        
        waitForExpectations(timeout: timeout)
        
        // Then
        XCTAssertNotNil(message)
    }
    
    func testThatWebSocketsFinishAfterNonNormalResponseCode() {
        // Given
        let session = Session(eventMonitors: [NSLoggingEventMonitor()])
        let didReceiveMessage = expectation(description: "didReceive")
        var message: URLSessionWebSocketTask.Message?
        
        // When
        session.websocketRequest(.websocket(closeCode: .goingAway)).responseMessage { event in
            switch event {
            case .connected:
                break
            case let .receivedMessage(receivedMessage):
                message = receivedMessage
                didReceiveMessage.fulfill()
            case .disconnected:
                break
            }
        }
        
        waitForExpectations(timeout: timeout)
        
        // Then
        XCTAssertNotNil(message)
    }
}
