//
//  TriviaQuestion.swift
//  Trivia
//
//  
//
import Foundation

struct TriviaQuestion: Decodable {
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]

    private enum CodingKeys: String, CodingKey {
        case category, question, correctAnswer = "correct_answer", incorrectAnswers = "incorrect_answers"
    }
}
