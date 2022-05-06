//
//  LogHelper.swift
//  OlaElectricLogger
//
//  Created by Nitin Kumar Raghuwanshi on 05/05/22.
//

import Foundation
class LogHelper {
    static func getDebugLog(request: URLRequest?, data: Data?, response: URLResponse?, error: Error?) -> String {
        // Extract Response Details
        var responseData: String = "NIL"
        if let data = data, let string = String(data: data, encoding: .utf8) {
            responseData = string
        }
        var statusCodeStr = "UNAVAILABLE"
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            statusCodeStr = "\(statusCode)"
        }
        return
"""
        \(request?.logDescription ?? "REQUEST DESC NOT FOUND")

===================== RESPONSE DETAILS ========================
        RESPONSE(STATUS CODE: \(statusCodeStr):
        \(response?.description ?? "NIL")
        BODY DATA:
        \(responseData)
=================== RESPONSE DETAILS ENDS =====================
        
===================== ERROR DETAILS ========================
        ERROR:
        \(error?.localizedDescription ?? "NIL")
=================== ERROR DETAILS ENDS =====================
"""
    }
}

extension URLRequest {
    var logDescription: String {
        // Extract Request Data for logging
        let method = httpMethod ?? "GET"
        let url: String = "URL: " + (self.url?.absoluteString ?? "NIL")
        var filteredHeaders = [String : String]()
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers {
                switch key {
                case "code" : continue
                case "Authorization":
                    if let token = value.components(separatedBy: " ").last?.suffix(5){
                        filteredHeaders["SHA"] = "......\(token)"
                    } else {
                        filteredHeaders["SHA"] = "NOT FOUND"
                    }
                default:
                    filteredHeaders[key] = value
                }
            }
        }

        var bodyData: String = "NIL"
        if let data = httpBody, data.count <= 1024 * 50, let string = String(data: data, encoding: .utf8) {
            bodyData = string
        }
        return
"""

===================== REQUEST DETAILS ========================
                "\(method.uppercased())" \(url)
                HEADERS:
                "\(filteredHeaders.description)"
                BODY DATA:
                \(bodyData)
=================== REQUEST DETAILS ENDS =====================
"""
    }
}
