//
//  NetworkController.swift
//  Translator
//
//  Created by Alex on 9/10/20.
//  Copyright © 2020 Weekend. All rights reserved.
//

import Foundation
import Alamofire

class NetworkController {
    
    private let baseUrl = "https://voice-translator-kranthi.herokuapp.com/api/translateText"
    
    // MARK: - Translate
    
    public func testingPostRequest(){
        AF.request(baseUrl, method: .put, parameters: ["test-key":"testvalue"]).validate(statusCode: 200..<300)
            .responseJSON { response in
                if let data = response.data {
                    print("Result PUT Request:")
                    print(String(data: data, encoding: .utf8)!)
                    //print(utf8Text)
                } else {
                    print("Alex was here")
                }
        }
    }
    
    public func sendTextToTranslate(text: String, toLanguage: String, fromLanguage: String){
//        {
//        "toLanguage": "ENGLISH",
//        "fromLanguage":"FRENCH",
//        "textToTranslate": "Hi Sir"
//        }
        
        let parameters: Parameters = [
            "toLanguage": "\(toLanguage.uppercased())",
            "fromLanguage": "\(fromLanguage.uppercased())",
            "textToTranslate": "\(text)"
        ]
        
        AF.request(baseUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: [:]).responseJSON { response in
            switch (response.result) {
            case .success:
                if let data = response.data {
                    print(response)
                    print("Result Request Request: ", data)
                    print(String(data: data, encoding: .utf8)!)
                    //print(utf8Text)
                }
            case .failure:
                print(Error.self)
            }
        }
    }
    
    
}
