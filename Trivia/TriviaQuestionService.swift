//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by MPSPR24 on 3/19/24.
//

import Foundation

class TriviaQuestionService {
    func fetchTriviaQuestions(completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(TriviaResponse.self, from: data)
                completion(decodedResponse.results)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}

