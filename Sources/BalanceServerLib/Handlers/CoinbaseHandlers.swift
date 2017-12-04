//
//  CoinbaseHandlers.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 9/7/17.
//  Copyright © 2017 Balanced Software, Inc. All rights reserved.
//

import Foundation
import PerfectLib
import PerfectHTTP

public struct CoinbaseHandlers {
    public static let routes = [["method": "post", "uri": "/coinbase/requestToken", "handler": requestTokenHandler],
                                ["method": "post", "uri": "/coinbase/refreshToken", "handler": refreshTokenHandler]]
    
    // MARK: - Handlers -
    
    public static func requestTokenHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Generate the request data
            guard let params = try? request.postBodyString?.jsonDecode() as? [String: Any?] else {
                Log.error(message: "requestTokenHandler: Invalid incoming post data")
                sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                return
            }
            guard let code = params?["code"] as? String else {
                Log.error(message: "requestTokenHandler: Invalid code")
                sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                return
            }
            guard let postJsonData = preparePostData(code: code) else {
                Log.error(message: "requestTokenHandler: Invalid preparation of post data")
                sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                return
            }
            // Get the access token from Coinbase
            getAccessToken(postData: postJsonData, completion: { responseDict, error in
                if let error = error {
                    Log.error(message: "\(String(describing: error))")
                    sendErrorJsonResponse(error: error, response: response)
                    return
                }
                
                // Respond to the client
                sendSuccessJsonResponse(dict: responseDict, response: response)
            })
        }
    }
    
    
    
    public static func refreshTokenHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Generate the request data -> uni test
            guard let params = try? request.postBodyString?.jsonDecode() as? [String: Any?],
                  let refreshToken = params?["refreshToken"] as? String,
                  let postJsonData = preparePostData(refreshToken: refreshToken) else {
                Log.error(message: "requestTokenHandler: Invalid input data")
                sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                return
            }
            
            // Get the access token from Coinbase
            getAccessToken(postData: postJsonData, completion: { responseDict, error in
                if let error = error {
                    Log.error(message: "Access Token coinbase error:\(String(describing: error))")
                    sendErrorJsonResponse(error: error, response: response)
                    return
                }
                
                // Respond to the client
                sendSuccessJsonResponse(dict: responseDict, response: response)
            })
        }
    }
    
    // MARK: - Private -
    
    fileprivate static func preparePostData(code: String? = nil, refreshToken: String? = nil) -> Data? {
        // Check that we got only one parameter
        guard !(code == nil && refreshToken == nil) && !(code != nil && refreshToken != nil) else {
            return nil
        }
        
        // Prepare the data
        var postData: [String: Any] = ["client_id": Config.Coinbase.clientId, "client_secret": Config.Coinbase.clientSecret]
        if let code = code {
            postData["grant_type"] = "authorization_code"
            postData["code"] = code
            postData["redirect_uri"] = "balancemymoney://coinbase"
        } else if let refreshToken = refreshToken {
            postData["grant_type"] = "refresh_token"
            postData["refresh_token"] = refreshToken
        }
        
        // Convert to JSON
        let postJsonData = try? postData.jsonEncodedString()
        return postJsonData?.data(using: .utf8)
    }
    
    // Gets the access token from the Coinbase API
    fileprivate static func getAccessToken(postData: Data, session: DataSession = sharedSession, completion: @escaping ([String: Any?], BalanceError?) -> Void) {
        let url = URL(string: "https://api.coinbase.com/oauth/token")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil, let data = data else {
                Log.error(message: "getAccessToken: network error received or data is nil error: \(String(describing: error))")
                completion([:], .networkError)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            if let bodyOptional = try? responseString?.jsonDecode() as? [String: Any?], let body = bodyOptional {
                // Perform full Coinbase error handling
                if body["error"] != nil {
                    Log.error(message: "coinbase error response: \(body)")
                    completion([String: Any?](), .unexpectedData)
                } else {
                    var dict = [String: Any?]()
                    dict["accessToken"] = body["access_token"]
                    dict["refreshToken"] = body["refresh_token"]
                    dict["expiresIn"] = body["expires_in"]
                    dict["scope"] = body["scope"]
                    dict["tokenType"] = body["token_type"]
                    completion(dict, nil)
                }
            } else {
                completion([String: Any?](), .jsonDecoding)
            }
        }
        task.resume()
    }
}
