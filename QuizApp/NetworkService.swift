//
//  NetworkService.swift
//  QuizApp
//
//  Created by Marin on 10.05.2021..
//

import UIKit

class NetworkService: NetworkServiceProtocol {
    private let baseURL: String! = "iosquiz.herokuapp.com"
    private let apiToken: String! = "api_token"
    private let userId: String! = "user_id"
    private let userDefaults = UserDefaults.standard
    
    func login(username: String, password: String, completionHandler: @escaping (Result<Bool, RequestError>) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        var params: [String: String] = [:]
        params["username"] = username
        params["password"] = password
        let urlComponent = addURLComponent(path: "/api/session", params: params)
        guard let url = urlComponent.url else {
            completionHandler(.failure(.serverError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        session.dataTask(with: urlRequest){
            data, response, error in
            if error != nil {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.serverError))
                return
            }
            
            if !(200...299).contains(response.statusCode) {
                completionHandler(.failure(.serverError))
                return
            }
        
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let loginData: LoginData = try? JSONDecoder().decode(LoginData.self, from: data) else {
                completionHandler(.failure(.decodingError))
                return
            }
            
            self.userDefaults.set(loginData.token, forKey: self.apiToken)
            self.userDefaults.set(loginData.userId, forKey: self.userId)
            
            completionHandler(.success(true))
        }.resume()
    }
    
    func fetchQuizzes(completionHandler: @escaping (Result<[Quiz], RequestError>) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let urlComponent = addURLComponent(path: "/api/quizzes")
        guard let url = urlComponent.url else {
            print("URL error")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue(userDefaults.string(forKey: apiToken), forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                print("Error with request")
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("HTTP Response error")
                completionHandler(.failure(.serverError))
                return
            }
            
            if !(200...299).contains(response.statusCode) {
                print("Status code error")
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                print("Data error")
                completionHandler(.failure(.noDataError))
                return
            }
            
            guard let quizzes = try? JSONDecoder().decode(Quizzes.self, from: data) else {
                print("Decode error")
                completionHandler(.failure(.decodingError))
                return
            }
            
            completionHandler(.success(quizzes.quizzes))
        }.resume()
    }
    
    func sendQuizResult(quizId: Int, noOfCorrect: Int, time: Double, completionHandler: @escaping (Result<Bool, RequestError>) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let urlComponent = addURLComponent(path: "/api/result")
        
        guard let url = urlComponent.url else {
            print("URL error")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue(userDefaults.string(forKey: apiToken), forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let quizResult: QuizResult = QuizResult(quizId: quizId, userId: userDefaults.integer(forKey: userId), time: time, noOfCorrect: noOfCorrect)
        
        guard let jsonBody = try? JSONEncoder().encode(quizResult) else {
            print("JSON Encoder error")
            return
        }
        
        urlRequest.httpBody = jsonBody
        
        session.dataTask(with: urlRequest) {
            data, response, error in
            if error != nil {
                completionHandler(.failure(.clientError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            switch response.statusCode {
            case 401:
                print("Error 401")
                completionHandler(.failure(.clientError))
                break
            case 403:
                print("Error 403")
                completionHandler(.failure(.clientError))
                break
            case 404:
                print("Error 404")
                completionHandler(.failure(.clientError))
                break
            case 400:
                print("Error 400")
                completionHandler(.failure(.clientError))
                break
            case 200:
                print("OK - quiz result sent")
                completionHandler(.success(true))
            default:
                completionHandler(.failure(.clientError))
                break
            }
        }.resume()
        
        
        
        
    }
    
    private func addURLComponent(path: String, params:[String: String] = [:]) -> URLComponents {
        var urlComponent = URLComponents()
        urlComponent.host = baseURL
        urlComponent.path = path
        urlComponent.scheme = "https"
        var queryParams: [URLQueryItem] = []
        for (name, value) in params {
            queryParams.append(URLQueryItem(name: name, value: value))
        }
        urlComponent.queryItems = queryParams
        
        return urlComponent
    }
}
