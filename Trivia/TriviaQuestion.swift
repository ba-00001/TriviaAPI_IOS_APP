//
//  TriviaQuestion.swift
//  Trivia
//
//  
//

import Foundation

// Assuming the JSON structure based on your initial message
struct TriviaResponse: Decodable {
    let responseCode: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Decodable {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case category, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

