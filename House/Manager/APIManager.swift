//
//  APIManager.swift
//  House
//
//  Created by andrew on 8/9/2018.
//  Copyright © 2018年 andrew. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

enum APIError:Error {
    case networkError
}

enum FixtureStatus:String {
    case on = "on"
    case off = "off"
}

class APIManager {
    static let sharedManager = APIManager()

    func getAllRooms() ->Observable<Data> {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        return self.rx_get(url: "\(Host.apiBaseUrl)/rooms", parameters: nil, headers: headers)
    }

    func changeFixtureStatus(room: String, fixture: String, status: FixtureStatus) ->Observable<Data> {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]

        return self.rx_get(url: "\(Host.apiBaseUrl)/\(room)/\(fixture)/\(status)", parameters: nil, headers: headers)
    }

    private func rx_get(url:URLConvertible, parameters:Parameters?, headers:HTTPHeaders?) -> Observable<Data> {
        return self.rx_request(url: url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }

    private func rx_request(url:URLConvertible, method:HTTPMethod, parameters:Parameters?, encoding:ParameterEncoding , headers: HTTPHeaders?) -> Observable<Data> {
        return Observable.create(){ observer in
            
            OperationQueue.main.addOperation() {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .response(completionHandler: {
                    response in
                    
                    OperationQueue.main.addOperation() {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }

                    if let data = response.data {
                        observer.onNext(data)
                    }else{
                        observer.onError(APIError.networkError)
                    }
                    
                    observer.onCompleted()
                })
            
            return Disposables.create(with: { request.cancel() })
            }
            .share()
    }
}
