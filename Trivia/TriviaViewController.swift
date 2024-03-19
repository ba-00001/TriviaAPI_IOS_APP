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
        addGradient()
        questionContainerView.layer.cornerRadius = 8.0
        fetchTriviaQuestions()
    }
    
    private func fetchTriviaQuestions() {
        triviaQuestionService.fetchTriviaQuestions { [weak self] questions in
            DispatchQueue.main.async {
                if let questions = questions {
                    self?.questions = questions
                    self?.currQuestionIndex = 0
                    self?.updateQuestion(withQuestionIndex: 0)
                } else {
                    // Handle the error, e.g., show an alert to the user
                }
            }
        }
    }
    
    private func updateQuestion(withQuestionIndex questionIndex: Int) {
        guard questionIndex < questions.count else { return }
        
        let question = questions[questionIndex]
        questionLabel.text = question.question
        categoryLabel.text = question.category
        currentQuestionNumberLabel.text = "Question \(questionIndex + 1) of \(questions.count)"
        
        let answers = (question.incorrectAnswers + [question.correctAnswer]).shuffled()
        
        answerButton0.setTitle(answers[0], for: .normal)
        answerButton1.setTitle(answers[1], for: .normal)
        answerButton2.setTitle(answers[2], for: .normal)
        answerButton3.setTitle(answers[3], for: .normal)
    }
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let answer = sender.titleLabel?.text else { return }
        
        if isCorrectAnswer(answer) {
            numCorrectQuestions += 1
        }
        
        currQuestionIndex += 1
        if currQuestionIndex < questions.count {
            updateQuestion(withQuestionIndex: currQuestionIndex)
        } else {
            showFinalScore()
        }
    }
    
    private func isCorrectAnswer(_ answer: String) -> Bool {
        return answer == questions[currQuestionIndex].correctAnswer
    }
    
    private func showFinalScore() {
        let alertController = UIAlertController(title: "Game Over", message: "Your score is \(numCorrectQuestions) out of \(questions.count).", preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] action in
            self?.fetchTriviaQuestions() // Restart game
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 0.54, green: 0.88, blue: 0.99, alpha: 1.00).cgColor, UIColor(red: 0.51, green: 0.81, blue: 0.97, alpha: 1.00).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
