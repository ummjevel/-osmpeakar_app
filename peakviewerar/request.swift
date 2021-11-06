//
//  request.swift
//  peakviewerar
//
//  Created by 전민정 on 2021/10/25.
//

import Foundation
import UIKit

public struct Response : Decodable {
    let result: String
    let message: String
    let body: [Osm]
    
}

enum LanguageSetting {
    case en
    case ko
}

enum ResponseResult: String, Decodable {
    case ok = "OK"
    case created = "CREATED"
    case no_content = "NO_CONTENT"
    case not_found = "NOT_FOUND"
    case error = "ERROR"
}

public struct Osm : Decodable {
    let fid: Int
    let osm_id: Int64
    let natural: String
    let name_en: String?
    let name_ko: String?
    let lat: Double
    let lon: Double
    /*
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        fid = try container.decode(Int.self)
        osm_id = try container.decode(Int64.self)
        natural = try container.decode(String.self)
        name_en = try container.decode(String.self)
        lat = try container.decode(Double.self)
        lon = try container.decode(Double.self)
    }
     */
}

func requestGet(url: String, completionHandler: @escaping (Bool, Any) -> Void) {
    guard let url = URL(string: url) else {
        print("Error: cannot create URL")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            print("Error: Error calling GET")
            print(error!)
            return
        }
        guard let data = data else {
            print("Error: Did not receive data")
            return
        }
        guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
            print("Error: HTTP request failed")
            return
        }
        /*
        let decoder = JSONDecoder()
        do {
           let array = try decoder.decode([Response].self, from: data)
           debugPrint(array)
        } catch {
           debugPrint("Error occurred!!!!")
        }
        
        guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
            print("Error: JSON Data Parsing failed")
            return
        }*/
        do {
            let result = try JSONDecoder().decode(Response.self, from: data)
            // print("result is \(result)")
            completionHandler(true, result)
        } catch {
            print(error)
            // completionHandler(false, [])
            return
        }
        
    }.resume()
}

func requestPost(url: String, method: String, param: [String: Any], completionHandler: @escaping (Bool, Any) -> Void) {
    let sendData = try! JSONSerialization.data(withJSONObject: param, options: [])
        
        guard let url = URL(string: url) else {
            print("Error: cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("Error: Error calling GET")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
          
            do {
                let result = try JSONDecoder().decode(Response.self, from: data)
                print(result)
            } catch {
                print("This is error...")
                print(error)
            }
            
            guard let output = try? JSONDecoder().decode(Response.self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            
            completionHandler(true, output)
        }.resume()
}

func request(_ url: String, _ method: String, _ param: [String: Any]? = nil, completionHandler: @escaping (Bool, Any) -> Void) {
    if method == "GET" {
        requestGet(url: url) { (success, data) in
            completionHandler(success, data)
        }
    } else {
        requestPost(url: url, method: method, param: param!) { (success, data) in
            completionHandler(success, data)
        }
    }
}
