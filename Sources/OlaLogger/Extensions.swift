//
//  File.swift
//  
//
//  Created by Nitin Kumar Raghuwanshi on 06/05/22.
//

import Foundation

// MARK: Dictionary extensions
extension Dictionary where Key == String, Value == String {
    var responseSubmissionString: String {
        let pairs = map({ return String($0.key + "=" + $0.value) })
        return pairs.joined(separator: "&")
    }
    static func +(lhs: [String : String], rhs: [String : String]) -> [String : String] {
        var result = lhs
        for (key, val) in rhs { result[key] = val }
        return result
    }
}
