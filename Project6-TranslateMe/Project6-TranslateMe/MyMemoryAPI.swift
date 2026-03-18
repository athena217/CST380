//
//  MyMemoryAPI.swift
//  Project6-TranslateMe
//
//  Created by Athena Lopez on 3/17/26.
//

import Foundation
import SwiftUI

struct MyMemoryResponse: Codable {
    let responseData: ResponseData
}

struct ResponseData: Codable {
    let translatedText: String
}

class MyMemoryAPI {
    func translate(text:String, from source: String = "en", to target:String = "es") async throws -> String {
        let urlString = "https://api.mymemory.translated.net/get?q=\(text)&langpair=\(source)|\(target)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(MyMemoryResponse.self, from: data)
        return decoded.responseData.translatedText
    }
}
