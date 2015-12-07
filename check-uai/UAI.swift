//
//  UAI.swift
//  check-uai
//
//  Created by Nicolás López on 30-11-15.
//  Copyright © 2015 Nicolás López. All rights reserved.
//

import UIKit
import Alamofire

typealias UAIApiStringResponse = (UAIApiError?, String?) -> Void
typealias UAIApiDictionaryResponse = (UAIApiError?, NSDictionary?) -> Void
typealias UAIApiArrayResponse = (UAIApiError?, NSArray?) -> Void

class UAI {

    class func loginTeacher(email: String, password: String, onCompletion: UAIApiStringResponse) {
        let api = UAIApi()
        api.request(.POST, path: "Asistencia/LoginProfesor", parameters: ["email": email, "password": password, "tokenApp": tokenApp])
        .responseJSON { response in
            if (response.result.isSuccess) {
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    if let token = JSON["token"] as? String {
                        if let decoded = token.stringByRemovingPercentEncoding {
                            onCompletion(nil, decoded)
                        }
                    } else {
                        if let message = JSON["respuesta"] as? String {
                            onCompletion(UAIApiError(code: 0, message: message), nil)
                        } else {
                            onCompletion(UAIApiError(code: 1), nil)
                        }
                    }
                }
            } else {
                onCompletion(UAIApiError(code: 1), nil)
            }
        }
    }
    
    class func loginColaborator(rut: String, onCompletion: UAIApiStringResponse) {
        let api = UAIApi()
        api.request(.POST, path: "Asistencia/LoginColaborador", parameters: ["rut": rut, "tokenApp": tokenApp])
            .responseJSON { response in
                if (response.result.isSuccess) {
                    if let JSON = response.result.value {
                        if let token = JSON["token"] as? String {
                            if let decoded = token.stringByRemovingPercentEncoding {
                                onCompletion(nil, decoded)
                            }
                        } else {
                            if let message = JSON["respuesta"] as? String {
                                onCompletion(UAIApiError(code: 0, message: message), nil)
                            } else {
                                onCompletion(UAIApiError(code: 1), nil)
                            }
                        }
                    }
                } else {
                    onCompletion(UAIApiError(code: 1), nil)
                }
        }
    }
    
    class func getTeacherSessions(teacherToken: String, academicUnit: Int, onCompletion: UAIApiArrayResponse) {
        let api = UAIApi()
        api.request(.POST, path: "Asistencia/AsignaturasProfesor", parameters: ["token": teacherToken, "idUnidadAcademica": academicUnit])
            .responseJSON { response in
                if response.result.isSuccess {
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        if let sessions = JSON as? NSArray {
                            onCompletion(nil, sessions)
                        } else {
                            onCompletion(UAIApiError(code: 1), nil)
                        }
                    }
                } else {
                    onCompletion(UAIApiError(code: 1), nil)
                }
            }
        }
}

class UAIApi {
    
    func request(method: Alamofire.Method, path: String, parameters: [String : AnyObject]) -> Alamofire.Request {
        
        let URL = NSURL(string: baseUrl + path)!
        var request = NSMutableURLRequest(URL: URL)
        
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: parameters)
        
        print(request.URL!)
        
        return Alamofire.request(method, request.URL!)
    }
    
}

class UAIApiError {
    
    let code: Int
    let message: String
    let errors = [
        1: "Error desconocido"
    ]
    
    init (code: Int) {
        self.code = code
        self.message = self.errors[code]!
    }
    
    init (code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    func describe() -> String {
        return "[Error \(self.code)] \(self.message)"
    }
    
}