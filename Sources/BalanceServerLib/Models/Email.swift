//
//  Email.swift
//  BalanceServerLib
//
//  Created by Benjamin Baron on 12/6/17.
//

import Foundation
import PerfectLib

public struct Email {
    public static func send(from: String, to: String, subject: String, body: String, urlString: String = Config.Mailgun.url, session: DataSession = sharedSession, completion: @escaping (BalanceError?) -> Void) {
        let parameters: [String: String] = ["from": from, "to": to, "subject": subject, "text": body]
        let postString = encodePostParameters(parameters)
        let postData = postString.data(using: .utf8)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                Log.error(message: "Email send: network error received sending to \(to): \(String(describing: error))")
                completion(.networkError)
                return
            }
            
            guard let data = data else {
                Log.error(message: "Email send: no data returned from MailGun")
                completion(.noData)
                return
            }
            
            let responseString = String(data: data, encoding: .utf8)
            guard responseString != "Forbidden" else {
                Log.error(message: "Email send: failed to send email, MailGun returned Forbidden, API key is invalid sending to \(to)")
                completion(.unexpectedData)
                return
            }
            
            guard let responseDictOptional = try? responseString?.jsonDecode() as? [String: String], let responseDict = responseDictOptional else {
                Log.error(message: "Email send: json response failed to decode, message probably failed to send to \(to)")
                completion(.jsonDecoding)
                return
            }
            
            // On success, MailGun will return an id
            guard let id = responseDict["id"] else {
                let message = responseDict["message"]
                Log.error(message: "Email send: message failed to send to \(to), error: \(String(describing: message))")
                completion(.unknownError)
                return
            }
            
            Log.info(message: "Email send: message sent successfully to \(to), with id: \(id)")
            completion(nil)
        }
        task.resume()
    }
}
