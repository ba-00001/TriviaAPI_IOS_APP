//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by MPSPR24 on 3/19/24.
//

import Foundation

class TriviaQuestionService {
    func fetchTriviaQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(TriviaResponse.self, from: data)
                completion(.success(decodedData.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// Helper struct to match the JSON structure.
struct TriviaResponse: Decodable {
    let results: [TriviaQuestion]
}

