//
//  NetworkManager.swift
//  KisilerUygulamasi
//
//  Created by Mesut Aygün on 13.12.2022.
//

import Foundation


// MARK: 2--->> BURADA NETWORK ICIN GEREKLI FONKSIYONLAR GENERIC TYPE OLARAK TANIMLANDI URLSESSION and DATA TASK

class NetworkManager{
    
    static let shared = NetworkManager()
    
    
   
    // MARK: GET EXECUTE GENERIC TYPE
    func execute<T: Codable>(_ request : NetworkHelper , type : T.Type ,  completion : @escaping((Result<T, ErrorTypes>)->())){
        guard let request = self.request(from: request) else {
            completion(.failure(ErrorTypes.invalidUrl))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data , error == nil else {
                completion(.failure(ErrorTypes.invalidData))
                return
            }
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            }catch{
                print(error.localizedDescription)
                completion(.failure(ErrorTypes.generalError))
            }
            
        }
        
        task.resume()
       
            
    }
    
    
    // MARK: POST
    func requestPost<T: Codable>(type : T.Type , url : String , method : HTTPMethods ,param : String, completion : @escaping((Result<T, ErrorTypes>)->())){
        let session = URLSession.shared
        
        if let url = URL(string: url){
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            let postString = "kategori_id=\(param)"
            request.httpBody = postString.data(using: .utf8)
            
            let dataTask = session.dataTask(with: request) { data, response, error in
                if let _ = error {
                    completion(.failure(.generalError))
                }else if let data = data {
                    self.handleResponse(data: data) { response in
                        completion(response)
                        print("success")
                       
                    }
                }else{
                    completion(.failure(.invalidUrl))
                }
            }
            dataTask.resume()
            
        }
            
    }
    
    
    fileprivate func handleResponse<T: Codable>(data : Data , completion : @escaping((Result<T, ErrorTypes>)->())){
        do{
            let result = try JSONDecoder().decode(T.self, from: data)
            completion(.success(result))
        }catch{
            completion(.failure(.invalidData))
        }
    }
    
    
    
    // request icin url ve methodlari tanimliyoruz varsa post icin param i burada tanimlariz
    private func request(from rmRequest : NetworkHelper) -> URLRequest? {
        guard let url = rmRequest.url else {return nil}
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        
        return request
    }
}
