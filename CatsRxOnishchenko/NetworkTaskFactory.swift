//
//  NetworkTaskFactory.swift
//  CatsRxOnishchenko
//
//  Created by lera on 24.02.2023.
//

import Foundation
import RxSwift

class NetworkTaskFactory {
    
    static func getNewTask<T: Decodable>(url: String, type: T.Type) -> Single<T>? {
        
        guard let myUrl = URL(string: url) else {
            return nil
        }
        return Single<T>.create { singleObserver in
            let dataTask = URLSession.shared.dataTask(with: URLRequest(url: myUrl)) { data, _, error in
                if let error = error {
                    singleObserver(.failure(error))
                    return
                }
                guard
                    let data = data
                else {
                    singleObserver(.failure(AppError.decodingError))
                    return
                }
                
                if T.Type.self == Data.Type.self {
                    singleObserver(.success(data as! T))
                }
                else{
                    guard let json = try? JSONDecoder().decode(T.self, from: data)
                    else {
                        singleObserver(.failure(AppError.decodingError))
                        return
                    }
                    singleObserver(.success(json))
                }
            }
            
            dataTask.resume()
            
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }
    
}

enum AppError: Error {
    case invalidError
    case decodingError
}
