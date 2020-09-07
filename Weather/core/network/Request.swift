//
//  Request.swift
//  Weather
//
//  Created by Владимир Курдюков on 04.09.2020.
//  Copyright © 2020 Numkms. All rights reserved.
//

import Foundation
import Alamofire

class Request {
    
    var baseUrl: String
    
    init(with baseUrl: String) {
        self.baseUrl = baseUrl
   
    }
    
    enum RequestError: Error {
        case endpointError(String)
        case noData(String)
    }
    
    func get(url uri: String, completion: @escaping (Result<Data, RequestError>) -> Void) {
        AF.request(baseUrl + uri, method: .get).responseJSON { response in
            switch response.response?.statusCode {
            case 401:
                completion(.failure(.endpointError("Wrong api key or reached api day api queries count")))
            case .none:
                completion(.failure(.endpointError("Неизвестная ошибка сервера")))
            case 400:
                completion(.failure(.endpointError("The request had bad syntax or the parameters supplied were invalid.")))
            case 403:
                completion(.failure(.endpointError("A valid API Key was not supplied in the query.")))
            case 404:
                completion(.failure(.endpointError("The server has not found a route matching the given URI.")))
            case 500:
                completion(.failure(.endpointError("The server encountered an unexpected condition which prevented it from fulfilling the request.")))
            case 503:
                completion(.failure(.endpointError(" The server is currently unavailable.")))
            default:
                if let data = response.data {
                    completion(.success(data))
                } else {
                    completion(.failure(.noData("The server returns empty data")))
                }
                
            }
        }
    }
    
    func post(url uri: String, parameters: [String: String], completion: @escaping (Data?) -> Void) {
        AF.request(baseUrl + uri, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default).responseJSON { response in
            completion(response.data)
        }
    }
}
