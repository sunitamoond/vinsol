//
//  APIManager.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

//import Foundation
//import PromiseKit
//import Alamofire
//
//enum HTTPHeaderKeys: String {
//    case authorization = "Authorization"
//    case contentType = "Content-Type"
//}
//
//
//
//enum HTTPHeaderValues: String {
//    case json = "application/json; charset=utf-8"
//    case authorization = "Basic YWRtaW46ZG90c2xhc2g="
//}
//enum APIError: Error {
//    case invalidPath
//    case invalidURL(reason: String)
//    case parameterEncodingFailed(reason: String)
//    case timeout
//    case internetNotReachable
//    case decodingFailed(reason: String)
//    case unknown(reason: String)
//
//    static func handleURLRequestError(_ error: Error) -> APIError {
//        guard let e = error as? AFError else {
//            return APIError.unknown(reason: error.localizedDescription)
//        }
//        if e.isParameterEncodingError {
//            return APIError.parameterEncodingFailed(reason: e.localizedDescription)
//        } else if e.isInvalidURLError {
//            return APIError.invalidURL(reason: e.localizedDescription)
//        } else {
//            return APIError.unknown(reason: e.localizedDescription)
//        }
//    }
//
//    init(_ error: Error) {
//        if let error = error as? AFError {
//            if error.isInvalidURLError {
//                self = APIError.invalidURL(reason: error.localizedDescription)
//            } else if error.isParameterEncodingError {
//                self = APIError.parameterEncodingFailed(reason: error.localizedDescription)
//            }else {
//                self = APIError.unknown(reason: error.localizedDescription)
//            }
//        } else {
//            let error = error as NSError
//             if error.code == NSURLErrorTimedOut {
//                self = APIError.timeout
//            } else if error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet {
//                self = APIError.internetNotReachable
//            } else {
//                self = APIError.unknown(reason: error.localizedDescription)
//            }
//        }
//    }
//
//    static func errorParsing(_ error: Error) -> APIError {
//        guard let e = error as? APIError else {
//            return APIError.unknown(reason: error.localizedDescription)
//        }
//        return e
//    }
//}
//
//extension APIError {
//    var description: String {
//        switch self {
//        case .invalidPath:
//            return "Invalid Path"
//        case .invalidURL(reason: let reason):
//            return "in valid url \(reason)"
//        case .parameterEncodingFailed(let reason):
//            return "parameter encoding failed\(reason)"
//         case .timeout:
//            return "request timeout"
//        case .internetNotReachable:
//            return "Internet not reachable"
//        case .decodingFailed(reason: let reason):
//            return "decoding failed"
//        case .unknown(reason: let reason):
//            return "some error occured \(reason)"
//        }
//    }
//}
//
//extension URLRequest {
//
//    init(endPoint: URL) {
//        self.init(url: endPoint)
//    }
//}
//
//extension URLRequestConvertible {
//    func asPromise() -> Promise<URLRequest> {
//        return Promise { fulfill, reject in
//            do {
//                let urlRequest = try asURLRequest()
//                fulfill(urlRequest)
//            } catch {
//                reject(APIError.errorParsing(error))
//            }
//        }
//    }
//}
//
//extension DataRequest {
//
//    public func responseJSONCodable<T: Codable>(decoder: JSONDecoder) -> Promise<T> {
//        return Promise { fulfill, reject in
//            responseData { response in
//                switch response.result {
//                case .success(let data):
//                    do {
//                        let decodedValue = try decoder.decode(T.self, from: data)
//                        fulfill(decodedValue)
//                    } catch let error as DecodingError {
//                        return reject(APIError.decodingFailed(reason: error.localizedDescription))
//                    } catch {
//                        return reject(APIError.unknown(reason: error.localizedDescription))
//                    }
//                case .failure(let error):
//                    //TODO: get error from API response.
//                    return reject(APIError(error))
//                }
//            }
//        }
//    }
//}
//
//
//struct APIManager {
//    struct Configuration {
//
//        #if DEBUG
//        enum Environment: String {
//            case dev = "https://ply-reporter-dev.herokuapp.com"
//            case staging = "https://ply-reporter-staging.herokuapp.com"
//            case production = "https://woood-com.herokuapp.com"
//        }
//        let environment = Environment.dev.rawValue //we can change this at any time
//        #else
//        let environment = Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as! String
//        #endif
//    }
//
//    static let baseURL = Configuration().environment
//
//    static func requestAndDecode<T: Codable>(urlRequest: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {
//        let (promise, _): (Promise<T>, Request) = requestAndDecode(urlRequest: urlRequest, decoder: decoder)
//
//        return promise
//    }
//
//    static func requestAndDecode<T: Codable>(urlRequest: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> (Promise<T>, Request) {
//        let request = Alamofire.request(urlRequest)
//            .validate()
//        debugPrint(request)
//        let response: Promise<Response<T>> = request
//            .responseJSONCodable(decoder: decoder)
//        let promise = response.then { response -> Promise<T> in
//            if let error = response.error  {
//                return Promise.init(error: APIError.unknown(reason: error))
//            } else if !(response.success ?? true) {
//                return Promise(error: APIError.unknown(reason: "Request Failed"))
//            } else if let result = response.result, (response.success ?? false) {
//                return Promise(value: result)
//            } else {
//                return Promise(error: APIError.unknown(reason: "Error"))
//            }
//            }
//            .recover { error -> Promise<T> in
//                if let _ = error as? APIError { throw error }
//                throw APIError.init(error)
//        }
//
//        return (promise, request)
//    }
//
//
//    static func request(urlRequest: URLRequest) -> Promise<Data> {
//        return Promise { fulfill, reject in
//            let request = Alamofire.request(urlRequest).validate().responseData { response in
//                switch response.result {
//                case .success(let value):
//                    fulfill(value)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    reject(APIError(error))
//                }
//            }
//            debugPrint(request)
//        }
//    }
//
//    static func parseResponse<T: Codable>(_ data: Data) -> Promise<T> {
//        let decoder = JSONDecoder()
//        do {
//            let response = try decoder.decode(Response<T>.self, from: data)
//            if let error = response.error  {
//                return Promise.init(error: APIError.unknown(reason: error))
//            } else if !(response.success ?? true) {
//                return Promise(error: APIError.unknown(reason: "Request Failed"))
//            } else if let result = response.result, (response.success ?? false) {
//                return Promise(value: result)
//            } else {
//                return Promise(error: APIError.unknown(reason: "Error"))
//            }
//        } catch let error as DecodingError {
//            return Promise(error: APIError.decodingFailed(reason: error.localizedDescription))
//        } catch let error {
//            return Promise(error: APIError.unknown(reason: error.localizedDescription))
//        }
//    }
//}
//
