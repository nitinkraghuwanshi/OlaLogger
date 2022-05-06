import Foundation

struct API {
    static let formSubmissionAPI = "https://docs.google.com/forms/d/%@/formResponse"
}

public enum LoggerError: Error {
    case internalError(description: String)
    case serverError(statusCode: Int, description: String)
    case serverError(description: String)
    case invalidResponse(description: String)
}

public struct OlaLogger {
 
    public init() {}
    
    public func submitForm(form: LoggerForm, completion: @escaping (Result<Bool, LoggerError>) -> Void) {
        do {
            let request = try prepareQueryRequest(form: form)
            submitForm(request: request, completion: completion)
        } catch {
            completion(.failure(.internalError(description: "failed in creating request")))
        }
    }
    public func submitForm(formID: String, dictionary: [String: String], completion: @escaping (Result<Bool, LoggerError>) -> Void)  {
        do {
            let request = try prepareQueryRequest(formID: formID, dictionary: dictionary)
            submitForm(request: request, completion: completion)
        } catch {
            completion(.failure(.internalError(description: "failed in creating request")))
        }
    }
    public func submitForm(formID: String, postDataStr: String, completion: @escaping (Result<Bool, LoggerError>) -> Void)  {
        do {
            let request = try prepareQueryRequest(formID: formID, postDataStr: postDataStr)
            submitForm(request: request, completion: completion)
        } catch {
            completion(.failure(.internalError(description: "failed in creating request")))
        }
    }
}

// MARK: - Private Helpers
extension OlaLogger {
    private func prepareQueryRequest(form: LoggerForm) throws -> URLRequest{
        let paramsStr = form.fieldsParamString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return try prepareQueryRequest(formID: form.id, postDataStr: paramsStr ?? "")
    }
    private func prepareQueryRequest(formID: String, dictionary: [String: String]) throws -> URLRequest{
        let paramsStr = dictionary.responseSubmissionString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return try prepareQueryRequest(formID: formID, postDataStr: paramsStr ?? "")
    }

    private func prepareQueryRequest(formID: String, postDataStr: String) throws -> URLRequest {
        // Preparing for request
        let strEndPointPath: String = String(format: API.formSubmissionAPI, formID)
        var request = URLRequest(url: URL(string: strEndPointPath)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postDataStr.data(using: String.Encoding.utf8)
        return request
    }
    
    //"https://docs.google.com/forms/d/19MbGnGA54cj9nobK5FxvRNcXJ-Gtudb_xSA3VChzSxU/formResponse", versionField: "entry_631576183", userInfoField: "entry_922538006", methodInfoField: "entry_836974774", textField: "entry_526236259")
    //API call
    
    private func submitForm(request: URLRequest, completion: @escaping (Result<Bool, LoggerError>) -> Void) {

            let sessionConfig = URLSessionConfiguration.default
            URLSession(configuration: sessionConfig).dataTask(with: request, completionHandler: { (data, response, networkError) in
                let strDebugLog = LogHelper.getDebugLog(request: request, data: data, response: response, error: networkError)
                print(strDebugLog)
                
                if let networkError = networkError, let error = networkError as NSError?{
                    print("  Error: \(String(describing: error.debugDescription))")
                    completion(.failure(.serverError(description:  error.debugDescription)))
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(.invalidResponse(description:  strDebugLog)))
                    return
                }
                if statusCode == 200, let data = data {
                    print("Success response = \(response.debugDescription)")
                    completion(.success(true))
                } else {
                    print("  Error: \(String(describing: response))")
                    completion(.failure(.serverError(statusCode: statusCode, description: "Status code is not 200")))
                }
            }).resume()

    }
}

extension OlaLogger {
   public static func getDummyFormObject() -> LoggerForm {
        let formId = "1zluSCg3NOIfOK1OZfwSU2mub78i9Ozl6W4IYMBf06RU"
        let googleFormNameField: String  = "entry_1611941115"
        let googleFormGenderField: String = "entry_1672478587"
        let googleFormCompanyField: String = "entry_143709910"
       
        
        let name = "nitin test"
        let gender = "Male"
        let company = "OlaElectic"
        
        let fields = [
            googleFormNameField : name,
            googleFormGenderField : gender,
            googleFormCompanyField : company
        ]
        return LoggerForm(id: formId, fields: fields)
    }
}
