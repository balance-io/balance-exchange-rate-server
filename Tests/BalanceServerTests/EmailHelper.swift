//
//  File.swift
//  BalanceServerTests
//
//  Created by Benjamin Baron on 12/7/17.
//

import Foundation

extension TestHelpers {
    public static var emailSuccessResponseData: Data {
        return emailSuccessResponse.data(using: .utf8)!
    }
    
    public static var emailNoParametersResponseData: Data {
        return emailNoParametersResponse.data(using: .utf8)!
    }
    
    public static var emailMissingToParameterResponseData: Data {
        return emailMissingToParameterResponse.data(using: .utf8)!
    }
    
    public static var emailMissingTextParameterResponseData: Data {
        return emailMissingTextParameterResponse.data(using: .utf8)!
    }
    
    public static var emailWrongApiKeyResponseData: Data {
        return emailWrongApiKeyResponse.data(using: .utf8)!
    }
    
    public static var emailSuccessStatusCode = 200
    public static var emailSuccessResponse = """
    {
        "id": "<20171207201333.57154.EB5802D1F73EDE9E@balancemy.money>",
        "message": "Queued. Thank you."
    }
    """
    
    public static var emailNoParametersStatusCode = 400
    public static var emailNoParametersResponse = """
    {
        "message": "'from' parameter is not a valid address. please check documentation"
    }
    """
    
    public static var emailMissingToParameterStatusCode = 400
    public static var emailMissingToParameterResponse = """
    {
        "message": "'to' parameter is not a valid address. please check documentation"
    }
    """
    
    public static var emailMissingTextParameterStatusCode = 400
    public static var emailMissingTextParameterResponse = """
    {
        "message": "Need at least one of 'text' or 'html' parameters specified"
    }
    """
    
    public static var emailWrongApiKeyStatusCode = 401
    public static var emailWrongApiKeyResponse = "Forbidden"
}
