//
//  NetworkManager.swift
//  AppTest
//
//  Created by Ganesh Kumar on 03/09/19.
//  Copyright © 2019 Nextbrain. All rights reserved.
//

import Foundation
import UIKit


enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

final class RequestMethod {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

final class RequestManager {

    func getCodableResponse(_ url: String, method: RequestMethod.Method, param: [String: Any], completion: @escaping (_ result: Data, Bool) -> ()){
        
        if let reachability = Reachability(), !reachability.isReachable {
            RequestManager.showAlert("Please check your Internet Connection")
            return
        }
        
        loadCodableData(url, method: method, params: param) { (result) in
            switch result{
            case .success(let json):
                completion(json, true)
                break
            case .failure(let error):
                print(error.localizedDescription)
                RequestManager.showAlert(error.localizedDescription)
                break
            }
        }
    }
    
    func loadCodableData(_ urlString: String, method: RequestMethod.Method, params: [String: Any], session: URLSession = URLSession(configuration: .default), completion: @escaping (Result<Data, ErrorResult>) -> ()){
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return
        }
        var request = RequestMethod.request(method: method, url: url)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        if method == .POST{
            request.httpBody = RequestManager.dataFormat(from: params)}
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse,  ![200, 201].contains(httpStatus.statusCode) {
                completion(.failure(.network(string: "Incorrect Response")))
            }
            
            if let data = data {
                completion(.success(data))
            }
            
        }
        task.resume()
    }
    
    
    static func dataFormat(from data: [String: Any]) -> Data{
        guard let json = try? JSONSerialization.data(withJSONObject: data, options: []) else {return Data()}
        return json
    }
    
    
    static func showAlert(_ text:String){
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: "Sample App", message: text, preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present (alertView, animated: true, completion: nil)
        }
    }

}

