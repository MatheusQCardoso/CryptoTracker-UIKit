//
//  APICaller.swift
//  CryptoTracker
//
//  Created by Matheus Quirino on 09/01/22.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private struct Constants{
        static let API_KEY = "AAD4ACA5-AD80-4D87-8907-03A7277FBD31"
        static let ASSETS_URL = "https://rest.coinapi.io/v1/assets/"
        static let ICONS_URL = "https://rest.coinapi.io/v1/assets/icons/55/"
    }
    
    public var icons: [APIIconData] = []
    
    private var waitForIconsBlock: ((Result<[APICoinData], Error>) -> Void)?
        
    private init(){
    }
    
    public func getAllCryptoData(completion: @escaping (Result<[APICoinData], Error>) -> Void){
        guard !icons.isEmpty else {
            waitForIconsBlock = completion
            return
        }
        
        let urlString = Constants.ASSETS_URL + "?apiKey=" + Constants.API_KEY
        
        requestAndDecodeJSON(with: urlString,
                             method: .GET,
                             model: [APICoinData].self,
                             completion: completion)
    }
    
    public func getAllIcons() {
        
        let urlString = Constants.ICONS_URL + "?apiKey=" + Constants.API_KEY
        
        requestAndDecodeJSON(with: urlString,
                             method: .GET,
                             model: [APIIconData].self){ [weak self] result in
            switch result {
            case .success(let icons):
                self?.icons = icons
                if let completion = self?.waitForIconsBlock {
                    self?.getAllCryptoData(completion: completion)
                }
                break
            case .failure(let error):
                print("ERR_ \(error)")
                break
            }
        }
    }
    
    enum HTTPMethod: String{
        case GET
        case POST
    }
    enum APIError: Error{
        case failedToGetData
    }
    private func requestAndDecodeJSON<T: Decodable>(with urlString: String,
                                                    method: HTTPMethod,
                                                    model: T.Type,
                                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url){ data, _, error in
            guard let data = data, error == nil else{
                completion(.failure(APIError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
}
