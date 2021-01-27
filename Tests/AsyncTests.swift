//
//  AsyncTests.swift
//  Alamofire
//
//  Created by Jon Shier on 1/26/21.
//  Copyright © 2021 Alamofire. All rights reserved.
//

import Alamofire
import XCTest

final class AsyncTests: BaseTestCase {
    func testAsyncResponse() {
        // Given
        
        // When
        runAsyncAndBlock {
            let asyncResponse = AF.request("https://httpbin.org/get").responseHandle(decoding: HTTPBinResponse.self)
            do {
                let response = try await asyncResponse.handle.get()
                XCTAssertTrue(response.result.isSuccess)
            } catch {
                print(error)
            }
        }
        
        
        // Then
        
    }
    
    func testAsyncValue() {
        runAsyncAndBlock {
            do {
                let response = try await AF.request("https://httpbin.org/get").response(decoding: HTTPBinResponse.self)
                XCTAssertTrue(response.result.isSuccess)
            } catch {
                print(error)
            }
        }
    }
}
