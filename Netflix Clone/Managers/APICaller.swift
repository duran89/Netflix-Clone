//
//  APICaller.swift
//  Netflix Clone
//
//  Created by 권정근 on 3/4/24.
//

import Foundation

struct Constants {
    static let API_KEY = "678025f9b853729922748d16feb442f9"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedToGetData
}


class APICaller {
    
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(results)
                
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                print(results)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                print(results)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
        
    }
    
    
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void ) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                print(results)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                print(results)
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
}








/*
let headers = [
  "accept": "application/json",
  "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NzgwMjVmOWI4NTM3Mjk5MjI3NDhkMTZmZWI0NDJmOSIsInN1YiI6IjY1ZTUyODRmMjBlNmE1MDE4NjUzYzIwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Hd-3l416D_iUzXWz37jvK9O4X0PvEBZW4nXdJ159srM"
]

let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/trending/all/day?language=en-US")! as URL,
                                        cachePolicy: .useProtocolCachePolicy,
                                    timeoutInterval: 10.0)
request.httpMethod = "GET"
request.allHTTPHeaderFields = headers

let session = URLSession.shared
let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
  if (error != nil) {
    print(error as Any)
  } else {
    let httpResponse = response as? HTTPURLResponse
    print(httpResponse)
  }
})

dataTask.resume()
*/


/*
 import Foundation

 let headers = [
   "accept": "application/json",
   "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NzgwMjVmOWI4NTM3Mjk5MjI3NDhkMTZmZWI0NDJmOSIsInN1YiI6IjY1ZTUyODRmMjBlNmE1MDE4NjUzYzIwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Hd-3l416D_iUzXWz37jvK9O4X0PvEBZW4nXdJ159srM"
 ]

 let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1")! as URL,
                                         cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 10.0)
 request.httpMethod = "GET"
 request.allHTTPHeaderFields = headers

 let session = URLSession.shared
 let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
   if (error != nil) {
     print(error as Any)
   } else {
     let httpResponse = response as? HTTPURLResponse
     print(httpResponse)
   }
 })

 dataTask.resume()
 
 */
