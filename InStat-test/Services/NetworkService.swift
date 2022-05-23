//
//  NewworkService.swift
//  InStat-test
//
//  Created by Денис Рубцов on 21.05.2022.
//

import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    enum AppError: Error {
        case networkError(Error)
        case dataNotFound
        case jsonParsingError(Error)
    }

    enum Result<T> {
        case success(T)
        case failure(AppError)
    }

    // MARK: LOAD & FETCH JSON

    func dataRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {
        let dataURL = URL(string: url)!
        let session = URLSession.shared
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }
            guard let data = data else {
                completion(Result.failure(AppError.dataNotFound))
                return
            }
            do {
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(AppError.jsonParsingError(error as! DecodingError)))
            }
        })
        task.resume()
    }
    
    
    // MARK: LOAD & CACHE IMAGE
    
    private let imageCache = NSCache<AnyObject, AnyObject>()

    func loadImage(with url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(Result.success(imageFromCache))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(Result.failure(AppError.networkError(error!)))
                return
            }

            DispatchQueue.main.async { [self] in
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    completion(Result.success(imageToCache))
                }
            }
        }
        task.resume()
    }

}
