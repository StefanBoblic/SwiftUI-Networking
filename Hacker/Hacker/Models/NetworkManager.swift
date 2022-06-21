//
//  NetworkManager.swift
//  Hacker
//
//  Created by Stefan Boblic on 19.06.2022.
//

import Foundation

class NetworkManager: ObservableObject {
    
    //anyone subed to network manager will have info updated because of @Published
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") { //fetch data
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do { //decode data
                            let results =  try decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                // Main thread
                                self.posts = results.hits
                            }
                            //save results.hits to posts property
                        } catch {
                            print(error)
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
}
