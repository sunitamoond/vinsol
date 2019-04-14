//
//  ScheduleManager.swift
//  VinsolApp
//
//  Created by Sunita Moond on 13/04/19.
//  Copyright © 2019 Sunita Moond. All rights reserved.
//

import Foundation
import Alamofire
//import PromiseKit
//
//enum ScheduleRouter: URLRequestConvertible {
//    func asURLRequest() throws -> URLRequest {
//        guard let path = path else { throw APIError.invalidPath }
//        do {
//            let url = try APIManager.baseURL.asURL()
//            var urlRequest = URLRequest(endPoint: url.appendingPathComponent(path))
//            urlRequest.httpMethod = method.rawValue
//
//            let encoder = JSONEncoder()
//            switch self {
//            case .getSchedules(let date):
//                urlRequest.httpBody = try encoder.encode(date)
//
//                return urlRequest
//
//            default:
//                return urlRequest
//            }
//        } catch let error {
//            throw APIError.handleURLRequestError(error)
//        }
//    }
//
//
//    case getSchedules(date: String)
//
//
//    var method: HTTPMethod {
//        switch self {
//            case .getSchedules: return .get
//        }
//    }
//
//    var path: String? {
//        switch self {
//            case .getSchedules: return "http://fathomless-shelf-5846.herokuapp.com/api/schedule"
//        }
//    }
//
//    var parameters: [String: Any]? {
//        switch self {
//        case .getSchedules(let date):
//            let params: [String: Any] = [ "date": date]
//            return params
//    }
//    }
//}

struct ScheduleManager {

    static func getSchedules(with date: String, compilation:@escaping ([Schedule]?) -> Void?){
        Alamofire.request("http://fathomless-shelf-5846.herokuapp.com/api/schedule",
                          parameters: ["date": "7/8/15"])
            // 2

            .response { response in

                print("abc")

                print(response.data);
                guard let data = response.data, response.error == nil else {
                    print(response.error)
                    compilation(nil);
                    return;
                }
                do {
                    let jsonDecoder = JSONDecoder()
                    let schedules: [Schedule] = try jsonDecoder.decode([Schedule].self, from: data)
                    //                let schedules: [Schedule] = response
                    print(schedules.count)
                    print(schedules)
                    compilation(schedules);
                } catch let parsingError {
                    print("Error", parsingError)
                    compilation(nil)
                }
    }
    }
}
