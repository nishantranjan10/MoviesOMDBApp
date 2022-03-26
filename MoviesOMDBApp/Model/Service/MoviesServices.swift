//
//  MoviesServices.swift
//  MoviesOMDBApp
//
//  Created by NISHANT RANJAN on 26/3/22.
//

import Foundation

final class MoviesServices: NSObject, URLSessionDelegate {
  
    //dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

        //create the url with NSURL
        guard let dataURL = URL(string: url)  else {
            return
        }

        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                //completion(Result.failure(AppError.networkError(error!)))
                return
            }

            guard let data = data else {
                completion(Result.failure(APPError.dataNotFound))
                return
            }
            
            do {
                //create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(APPError.jsonParsingError(error as! DecodingError)))
            }
        })

        task.resume()
    }
    
    private static func getData(url: URL, completion: @escaping(Data?, URLResponse?, Error?) -> ()) {
        let request = NSMutableURLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: MoviesServices(), delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            completion(data, response, error)
        })
        task.resume()
    }
    
    
    public static func downloadImage(url: URL, completion: @escaping(DownloadResult<Data>) -> Void) {
        MoviesServices.getData(url: url) { (data, response, error) in
            if let error = error {
                completion(.faliure(error))
                return
            }
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                completion(.sucess(data))
            }
        }
    }
    
    // MARK: - URLSessionDelegate
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
