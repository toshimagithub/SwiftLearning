//
//  DadJokeManager.swift
//  Clima
//
//  Created by 松原稔起 on 2024/09/16.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct DadJokeManager {
    
    func fetchDadJoke(completion: @escaping (DadJokeModel?) -> Void) {
        let url = URL(string: "https://icanhazdadjoke.com/")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching joke: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let jokeData = try decoder.decode(DadJoke.self, from: data)
                    let jokeModel = DadJokeModel(jokeText: jokeData.joke)
                    completion(jokeModel)
                } catch {
                    print("Error decoding joke: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}


