//
//  Repository.swift
//  ios-repo-app
//
//  Created by Brian Bansenauer on 10/5/19.
//  Copyright © 2019 Cascadia College. All rights reserved.
//
import Foundation
// TODO : Add Repo Protocol to allow for a MockAPIRepo
protocol APIRepository {

}	
// TODO : Use Generics and typeAlias to make the Repository class more general
class Repository<T> where T: Codable {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    
    func fetch(withCompletion completion: @escaping ([T]?) -> Void) { }
    
    func fetch(withId id: Int, withCompletion completion: @escaping (T?) -> Void) {
        let URLstring = path + "\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let user = try? JSONDecoder().decode(T.self, from: data!){
                    completion (user)
                }
            }
            task.resume()
        }
    }
    func create( a:T, withCompletion completion: @escaping (T?) -> Void ) {
        let url = URL.init(string: path)
        var urlRequest = URLRequest.init(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            let user = try? JSONDecoder().decode(T.self, from: data!)
            completion (user)
        }
        task.resume()
    }
    func update( withId id:Int, a:T ) {
        if let url = URL.init(string: path + "\(id)"){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try? JSONEncoder().encode(a)
            let task = URLSession.shared.dataTask(with: urlRequest)
            task.resume()
        }
    }
    func delete( withId id:Int ) {
        if let url = URL.init(string: path + "\(id)"){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: urlRequest)
            task.resume()
        }
    }
}

