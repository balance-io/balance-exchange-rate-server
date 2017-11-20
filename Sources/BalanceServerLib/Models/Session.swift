//
//  Session.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 11/17/17.
//

import Foundation

public protocol DataSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask;
}

extension URLSession: DataSession {
}
