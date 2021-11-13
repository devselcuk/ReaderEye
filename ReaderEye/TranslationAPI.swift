//
//  TranslationAPI.swift
//  ReaderEye
//
//  Created by MacMini on 7.10.2021.
//

import Foundation


let apikey = "d16556f952d2d7e6aae859355055e0b3"
let baseURLString = "https://od-api.oxforddictionaries.com/api/v2"
let appId = "8db4ef90"

let saveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("words").appendingPathExtension("plist")

let prdecoder = PropertyListDecoder()
let prencoder = PropertyListEncoder()





struct TranslationAPI {
    
    
    
    static func call(word : String , completion : @escaping (Result<ApiResult,Error>) -> () ) {
        
        let headers = ["Accept" : "application/json","app_id" : appId, "app_key" : apikey]
        
        guard let url = URL(string: "\(baseURLString)/translations/en/zh/\(word)") else { return}
        
        var request = URLRequest(url: url)
        
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
                return 
            }
            
            guard let data = data else {
                return
            }
            
            print(try? JSONSerialization.jsonObject(with: data, options: []))
            do {
                let result = try JSONDecoder().decode(ApiResult.self, from: data)
                completion(.success(result))
                
                
            }  catch let error {
                completion(.failure(error))
                print(error)
            }
            
            
        }.resume()
        
    }
    
}


struct ApiResult : Codable {
   
    let results : [WordItem]
}

struct WordItem : Codable {
    let id, language : String
    let  lexicalEntries : [LexicalEntry]
}

struct LexicalEntry : Codable {
    let entries : [Entry]
}

struct Entry : Codable {
    let pronunciations : [Pronunciation]
    let senses : [Sense]
}


struct Pronunciation : Codable {
    let audioFile : String
}


struct Sense : Codable {
    let examples : [Example]?
    let translations : [Translation]?
}


struct Example : Codable {
    let text : String
    let translations : [Translation]
}

struct Translation : Codable {
    let language : String
    let text : String
}
