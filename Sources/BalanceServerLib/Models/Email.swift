//
//  Email.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 12/6/17.
//

import Foundation
import PerfectLib

public struct Email {
    public static func send(from: String, to: String, subject: String, body: String, attachment: Data?, fileName: String?, mimeType: String?, urlString: String = Config.Mailgun.url, session: DataSession = sharedSession, completion: @escaping (BalanceError?) -> Void) {
        if let attachment = attachment, let fileName = fileName, let mimeType = mimeType {
            sendAttachment(from: from, to: to, subject: subject, body: body, attachment: attachment, fileName: fileName, mimeType: mimeType, urlString: urlString, session: session, completion: completion)
        } else {
            sendText(from: from, to: to, subject: subject, body: body, urlString: urlString, session: session, completion: completion)
        }
    }
    
    public static func sendText(from: String, to: String, subject: String, body: String, urlString: String = Config.Mailgun.url, session: DataSession = sharedSession, completion: @escaping (BalanceError?) -> Void) {
        let parameters: [String: String] = ["from": from, "to": to, "subject": subject, "text": body]
        let postString = encodePostParameters(parameters)
        let postData = postString.data(using: .utf8)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = session.dataTask(with: request) { data, response, error in
            processMailgunResponse(from: from, to: to, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    public static func sendAttachment(from: String, to: String, subject: String, body: String, attachment: Data, fileName: String, mimeType: String, urlString: String = Config.Mailgun.url, session: DataSession = sharedSession, completion: @escaping (BalanceError?) -> Void) {
        let parameters: [String: String] = ["from": from, "to": to, "subject": subject, "text": body]
        let boundary = generateBoundaryString()
        let postData = createAttachmentPostData(boundary: boundary, from: from, to: to, parameters: parameters, attachment: attachment, fileName: fileName, mimeType: mimeType)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request) { data, response, error in
            processMailgunResponse(from: from, to: to, data: data, response: response, error: error, completion: completion)
        }
        task.resume()
    }
    
    public static func createAttachmentPostData(boundary: String, from: String, to: String, parameters: [String: String], attachment: Data, fileName: String, mimeType: String) -> Data? {
        var httpBody = Data()
        let boundaryString = "--\(boundary)\r\n"
        guard let boundaryData = boundaryString.data(using: .utf8) else {
            Log.error(message: "Email attachment send from \(from) to \(to), Failed to encode boundary string")
            return nil
        }
        
        // Add parameters
        for (key, value) in parameters {
            let nameString = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n"
            //let valueString = "\(value.URLQueryParameterEncodedValue)\r\n"
            let valueString = "\(value)\r\n"
            guard let nameData = nameString.data(using: .utf8), let valueData = valueString.data(using: .utf8) else {
                Log.error(message: "Email attachment send from \(from) to \(to), Failed to encode parameter (\(key), \(value)")
                return nil
            }
            
            httpBody.append(boundaryData)
            httpBody.append(nameData)
            httpBody.append(valueData)
        }
        
        // Add attachment
        let nameString = "Content-Disposition: form-data; name=\"attachment\"; filename=\"\(fileName)\"\r\n"
        let typeString = "Content-Type: \(mimeType)\r\n\r\n"
        let endString = "\r\n"
        guard let nameData = nameString.data(using: .utf8), let typeData = typeString.data(using: .utf8), let endData = endString.data(using: .utf8) else {
            Log.error(message: "Email attachment send from \(from) to \(to) failed to encode attachment strings")
            return nil
        }
        
        httpBody.append(boundaryData)
        httpBody.append(nameData)
        httpBody.append(typeData)
        httpBody.append(attachment)
        httpBody.append(endData)
        
        // Terminate the request
        let terminatorString = "--\(boundary)--\r\n"
        guard let terminatorData = terminatorString.data(using: .utf8) else {
            Log.error(message: "Email attachment send from \(from) to \(to) failed to encode terminator string")
            return nil
        }
        
        httpBody.append(terminatorData)
        
        return httpBody;
    }
    
    public static func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    public static func processMailgunResponse(from: String, to: String, data: Data?, response: URLResponse?, error: Error?, completion: @escaping (BalanceError?) -> Void) {
        guard error == nil else {
            Log.error(message: "Email send: network error received sending from \(from) to \(to): \(String(describing: error))")
            completion(.networkError)
            return
        }
        
        guard let data = data else {
            Log.error(message: "Email send: no data returned from MailGun sending from \(from) to \(to)")
            completion(.noData)
            return
        }
        
        let responseString = String(data: data, encoding: .utf8)
        guard responseString != "Forbidden" else {
            Log.error(message: "Email send: failed to send email, MailGun returned Forbidden, API key is invalid sending from \(from) to \(to)")
            completion(.unexpectedData)
            return
        }
        
        guard let responseDictOptional = try? responseString?.jsonDecode() as? [String: String], let responseDict = responseDictOptional else {
            Log.error(message: "Email send: json response failed to decode, message probably failed to send from \(from) to \(to)")
            completion(.jsonDecoding)
            return
        }
        
        // On success, MailGun will return an id
        guard let id = responseDict["id"] else {
            let message = responseDict["message"]
            Log.error(message: "Email send: message failed to send from \(from) to \(to), error: \(String(describing: message))")
            completion(.unknownError)
            return
        }
        
        Log.info(message: "Email send: message sent successfully from \(from) to \(to), with id: \(id)")
        completion(nil)
    }
}
