//
//  Session.swift
//  BalanceExchangeRateServerLib
//
//  Created by Benjamin Baron on 11/17/17.
//

import Foundation

public protocol DataSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask;
}

extension URLSession: DataSession {
}

public func encodePostParameters(_ parameters: [String: String]) -> String {
    let parametersArray = parameters.map({"\($0)=\($1.URLQueryParameterEncodedValue)"})
    return parametersArray.joined(separator: "&")
}
