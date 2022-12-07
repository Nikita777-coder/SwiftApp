//
//  ApiService.swift
//  iomorinPW2
//
//  Created by Илья Морин on 07.12.2022.
//

import Foundation

final class ApiService {
    static let shared = ApiService()
    
    struct Constants {
        static let topHeadlinesURL = URL (string: "https://newsapi.org/v2/everything?q=apple&from=2022-12-06&to=2022-12-06&sortBy=popularity&apiKey=8981ea0446f4406e99cc10481e76dec4")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print ("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
}

// Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
