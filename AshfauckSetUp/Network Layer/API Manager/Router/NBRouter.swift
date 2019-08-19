//
//  NBRouter.swift
//  Neobone
//
//  Created by Ashfauck Thaminsali on 4/25/19.
//  Copyright © 2019 ORGware. All rights reserved.
//

import UIKit

public typealias NetworkRouterCompletion = (Result<(Data?, URLResponse?), Error>) -> ()


public protocol NetworkRouter: class
{
    associatedtype EndPoint: NBRequestSchema
    
    func request(_ route: EndPoint, loadingView:UIView?, completion: @escaping NetworkRouterCompletion)
    
    func cancel()
}

public extension NBRouter
{
    func request(_ route: EndPoint, loadingView:UIView?, completion: @escaping NetworkRouterCompletion)
    {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20
        sessionConfig.timeoutIntervalForResource = 20
        sessionConfig.waitsForConnectivity = true
        
        let session = URLSession(configuration: sessionConfig)
        
        do {
            let request = try self.buildRequest(from: route)
            
            // Log the response on the console
            NBNetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                NBNetworkLogger.log(response: response)
                
                if let err =  error{
                    completion(.failure(err))
                }
                
                let succ = (data,response)
                completion(.success(succ))
            })
            
            self.task?.resume()
        }
        catch
        {
            completion(.failure(error))
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }

}

public class NBRouter<EndPoint: NBRequestSchema>: NetworkRouter {
    
    private var task: URLSessionTask?
    {
        didSet
        {
            guard let task = task else { return }
            
            DispatchQueue.main.async {
                if task.state == .running
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                else
                {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: NBHTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}

