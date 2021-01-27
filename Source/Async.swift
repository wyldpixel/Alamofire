//
//  Async.swift
//  Alamofire
//
//  Created by Jon Shier on 1/26/21.
//  Copyright © 2021 Alamofire. All rights reserved.
//

import Foundation

public struct AsyncDataResponse<Value> {
    public let request: DataRequest
    public let handle: Task.Handle<AFDataResponse<Value>>
    
    fileprivate init(request: DataRequest, handle: Task.Handle<AFDataResponse<Value>>) {
        self.request = request
        self.handle = handle
    }
}

extension DispatchQueue {
    fileprivate static let asyncCompletionQueue = DispatchQueue(label: "org.alamofire.asynCompletionQueue")
}

extension DataRequest {
    public func responseHandle<Value: Decodable>(decoding: Value.Type = Value.self) -> AsyncDataResponse<Value> {
        let handle = Task.runDetached { () -> AFDataResponse<Value> in
            return await withCheckedContinuation { continuation in
                self.responseDecodable(of: Value.self, queue: .asyncCompletionQueue) { continuation.resume(returning: $0) }
            }
        }
        
        return AsyncDataResponse<Value>(request: self, handle: handle)
    }
    
    public func response<Value: Decodable>(decoding: Value.Type = Value.self) async throws -> AFDataResponse<Value> {
        try await responseHandle(decoding: Value.self).handle.get()
    }
}
