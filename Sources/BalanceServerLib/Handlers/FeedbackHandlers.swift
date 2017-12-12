//
//  FeedbackHandlers.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 12/12/17.
//

import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectThread

public struct FeedbackHandlers {
    public static let routes = [["method": "post", "uri": "/feedback/send", "handler": sendHandler]]
    
    public static func formatBody(appVersion: String, osVersion: String, hardwareVersion: String, comment: String, errorType: String?, errorCode: String?, source: String?, sourceInstitutionId: String?, institutionName: String?) -> String {
        var body  = "Balance version: \(appVersion)\n"
        body     += "OS version: \(osVersion)\n"
        body     += "Hardware version: \(hardwareVersion)\n"
        if let errorType = errorType {
            body += "Error type: \(errorType)\n"
        }
        if let errorCode = errorCode {
            body += "Error code: \(errorCode)\n"
        }
        if let source = source {
            body += "Source: \(source)\n"
        }
        if let sourceInstitutionId = sourceInstitutionId {
            body += "Source institution ID: \(sourceInstitutionId)\n"
        }
        if let institutionName = institutionName {
            body += "Institution name: \(institutionName)\n"
        }
        body     += "\n\n\(comment)"
        
        return body
    }
    
    public static func sendHandler(data: [String: Any]) throws -> RequestHandler {
        return { request, response in
            // Parse required input parameters
            guard let paramsUnwrapped = try? request.postBodyString?.jsonDecode() as? [String: Any?],
                let params = paramsUnwrapped,
                let email = params["email"] as? String,
                let appVersion = params["appVersion"] as? String,
                let osVersion = params["osVersion"] as? String,
                let hardwareVersion = params["hardwareVersion"] as? String,
                let comment = params["comment"] as? String else {
                    Log.error(message: "registerHandler: Invalid input data")
                    sendErrorJsonResponse(error: BalanceError.invalidInputData, response: response)
                    return
            }
            
            // Parse optional parameters
            let errorType = params["errorType"] as? String
            let errorCode = params["errorCode"] as? String
            let source = params["source"] as? String
            let sourceInstitutionId = params["sourceInstitutionId"] as? String
            let institutionName = params["institutionName"] as? String
            
            // Parse optional application logs (base64 encoded zip file)
            let logsBase64 = params["logs"] as? String
            var logsData: Data?
            if let logsBase64 = logsBase64 {
                logsData = Data(base64Encoded: logsBase64)
            }
            
            let to = "Balance Support <support@balancemy.money>"
            var subject = "Balance Feedback"
            if let source = source {
                subject = "Balance Connection Issue - \(source)"
            }
            let body = formatBody(appVersion: appVersion, osVersion: osVersion, hardwareVersion: hardwareVersion, comment: comment, errorType: errorType, errorCode: errorCode, source: source, sourceInstitutionId: sourceInstitutionId, institutionName: institutionName)
            
            // Send the email
            Email.send(from: email, to: to, subject: subject, body: body, attachment: logsData, fileName: "logs.zip", mimeType: "application/zip") { error in
                if let error = error {
                    Log.error(message: "Error sending feedback email from \(email), \(error)")
                    sendErrorJsonResponse(error: BalanceError.emailSendError, response: response)
                } else {
                    sendSuccessJsonResponse(dict: [:], response: response)
                }
            }
        }
    }
}
