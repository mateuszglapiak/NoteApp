//
//  URLRequest+Utils.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

extension URLRequest {
    enum Method: String {
        case get, put, post, delete
    }
    
    init(url: URL, httpMethod: Method, encodableBody: Codable? = nil) {
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue.uppercased()
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        if let encodableBody = encodableBody {
            self.httpBody = try! JSONEncoder().encode(encodableBody)
        }
    }
}
