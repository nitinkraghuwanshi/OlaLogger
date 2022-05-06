//
//  LoggerForm.swift
//  OlaElectricLogger
//
//  Created by Nitin Kumar Raghuwanshi on 06/05/22.
//

import Foundation

protocol LoggerFormType {
    var id: String {get set}
    var fields: [String: String] {get set}
}
extension LoggerFormType {
    var fieldsParamString: String {
        return fields.responseSubmissionString
    }
}
public struct LoggerForm: LoggerFormType {
   public var id: String
   public var fields: [String : String]
    
}

