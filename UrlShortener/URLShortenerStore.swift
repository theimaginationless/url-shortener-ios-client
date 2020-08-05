//
//  URLShortenerStore.swift
//  UrlShortener
//
//  Created by Dmitry Teplyakov on 05.08.2020.
//  Copyright © 2020 Dmitry Teplyakov. All rights reserved.
//

import UIKit

class URLShortenerStore {
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchShortenerFor(url: String, completion: @escaping (URLResult) -> Void) {
        let urlRequest = ShortenerAPI.shortenerUrl(parameters: nil)!
        var request = URLRequest(url: urlRequest)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonBody = ["sourceUrl": url]
        print(jsonBody)
        guard let jsonBodyData = try? JSONSerialization.data(withJSONObject: jsonBody, options: []) else {
            return
        }
        request.httpBody = jsonBodyData
        print(request.description)
        let task = session.dataTask(with: request) {
            (data, response, error) in

            let result = self.processingJSON(data: data)
            
            completion(result)
        }
        
        task.resume()
    }
    
    func processingJSON(data: Data?) -> URLResult {
        guard let jsonData = data else {
            return .Failure(ShortenerError.ProcessingJSONError)
        }
        
        return ShortenerAPI.URLFromJSON(data: jsonData)
    }
}
