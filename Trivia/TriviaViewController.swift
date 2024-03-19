//
//  ViewController.swift
//  Trivia
//
//  
//

import UIKit

class TriviaViewController: UIViewController {
  
  @IBOutlet weak var currentQuestionNumberLabel: UILabel!
  @IBOutlet weak var questionContainerView: UIView!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var answerButton0: UIButton!
  @IBOutlet weak var answerButton1: UIButton!
  @IBOutlet weak var answerButton2: UIButton!
  @IBOutlet weak var answerButton3: UIButton!
  
    private var questions = [TriviaQuestion]()
    private var currQuestionIndex = 0
    private var numCorrectQuestions = 0
    private var triviaQuestionService = TriviaQuestionService()
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTriviaQuestions()
        // Set the background color of the view controller's main view
            view.backgroundColor = UIColor.systemBlue
    }

    private func fetchTriviaQuestions() {
        triviaQuestionService.fetchTriviaQuestions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let questions):
                    self?.questions = questions
                    self?.updateUI()
                case .failure(let error):
                    print("Error fetching trivia questions: \(error)")
                }
            }
        }
    }

    private func updateUI() {
        guard currQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currQuestionIndex]
        
        categoryLabel.text = currentQuestion.category
        questionLabel.text = currentQuestion.question
        currentQuestionNumberLabel.text = "Question \(currQuestionIndex + 1)/\(questions.count)"
        
        let answers = [currentQuestion.correctAnswer] + currentQuestion.incorrectAnswers
        let shuffledAnswers = answers.shuffled()
        
        answerButton0.setTitle(shuffledAnswers[0], for: .normal)
        answerButton1.setTitle(shuffledAnswers[1], for: .normal)
        answerButton2.setTitle(shuffledAnswers[2], for: .normal)
        answerButton3.setTitle(shuffledAnswers[3], for: .normal)
    }
    
    @IBAction func answerSelected(_ sender: UIButton) {
        guard currQuestionIndex < questions.count else { return }
        let currentQuestion = questions[currQuestionIndex]
        
        if sender.titleLabel?.text == currentQuestion.correctAnswer {
            numCorrectQuestions += 1
        }
        
        currQuestionIndex += 1
        if currQuestionIndex < questions.count {
            updateUI()
        } else {
            // Game finished, show results
            showResults()
        }
    }
    
    private func showResults() {
        let alertController = UIAlertController(title: "Game Over", message: "Your score is \(numCorrectQuestions) out of \(questions.count).", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] _ in
            self?.currQuestionIndex = 0
            self?.numCorrectQuestions = 0
            self?.fetchTriviaQuestions()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
