//
//  ProfileHandlers.swift
//  BalanceServer
//
//  Created by Benjamin Baron on 11/8/17.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectMySQL
import bcrypt

public struct ProfileHandlers {
    public static let routes = [["method": "post", "uri": "/profile/register", "handler": registerHandler],
                                ["method": "post", "uri": "/profile/login", "handler": loginHandler],
                                ["method": "post", "uri": "/profile/forgotPassword", "handler": forgotPasswordHandler]]
    
    public static func registerHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Parse input parameters
            guard let params = try? request.postBodyString?.jsonDecode() as? [String: Any?],
                let email = params?["email"] as? String,
                let password = params?["password"] as? String else {
                    Log.error(message: "registerHandler: Invalid input data")
                    sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                    return
            }
            
            
        }
    }
    
    public static func loginHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Parse input parameters
            guard let params = try? request.postBodyString?.jsonDecode() as? [String: Any?],
                let email = params?["email"] as? String,
                let password = params?["password"] as? String else {
                    Log.error(message: "registerHandler: Invalid input data")
                    sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                    return
            }
        }
    }
    
    public static func forgotPasswordHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Parse input parameters
            guard let params = try? request.postBodyString?.jsonDecode() as? [String: Any?],
                let email = params?["email"] as? String else {
                    Log.error(message: "registerHandler: Invalid input data")
                    sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                    return
            }
        }
    }
}
