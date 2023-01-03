//
//  QuestionViewController.swift
//  lesson208
//
//  Created by Garib Agaev on 01.01.2023.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    private let questionLabel = UILabel()
    private let questionProgressView = UIProgressView()
    
    private let singleStackView = UIStackView()
    private let multipleStackView = UIStackView()
    private let rangedStackView = UIStackView()
    
    private let multipleAndRangedButton = UIButton(type: .system)
    
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var animalChosen: [Animal: Int] = [:]
    
    private var propertiesView: [UIView] {
        [
            questionLabel,
            questionProgressView,
            singleStackView,
            multipleStackView,
            rangedStackView,
            multipleAndRangedButton
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        settingALLProperties()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setAllConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else { return }
        guard let resultAnimal = sender as? Animal else { return }
        resultVC.resultAnimal = resultAnimal
    }
    
    @objc private func singleButtonAnswerPressed(_ sender: UIButton) {
        guard let buttonIndex = singleStackView.arrangedSubviews.firstIndex(of: sender) else { return }
        animalChosen[questions[questionIndex].answers[buttonIndex].animal, default: 0] += 1
        nextQuestion()
    }
    
    @objc private func multipleAndRangedButtonAnswerPressed() {
        let currentQuestion = questions[questionIndex]
        let currentAnswers = questions[questionIndex].answers
        switch currentQuestion.responseType {
        case .multiple:
            for (index, stackView) in multipleStackView.arrangedSubviews.enumerated() {
                guard let stackView = stackView as? UIStackView else { return }
                guard let propertySwitch = stackView.arrangedSubviews[1] as? UISwitch else { return }
                if propertySwitch.isOn {
                    animalChosen[currentAnswers[index].animal, default: 0] += 1
                }
            }
        case .ranged:
            guard let slider = rangedStackView.arrangedSubviews[0] as? UISlider else { return }
            let index = lrintf(slider.value * Float(currentAnswers.count - 1))
            animalChosen[currentAnswers[index].animal, default: 0] += 1
        default:
            break
        }
        nextQuestion()
    }
}

private extension QuestionsViewController {
    
    func updateUI() {
        let hidenView = [
            singleStackView,
            multipleStackView,
            rangedStackView,
            multipleAndRangedButton
        ]
        let currentQuestion = questions[questionIndex]
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        for viewsQuestion in hidenView {
            viewsQuestion.isHidden = true
        }
        
        questionLabel.text = currentQuestion.title
        questionProgressView.setProgress(totalProgress, animated: true)
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        showCurrentAnswers(for: currentQuestion.responseType)
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        let resultAnimal = Array(animalChosen).max(by: {$1.value > $0.value})?.key
        performSegue(withIdentifier: "resultVC", sender: resultAnimal)
    }
    
    func showCurrentAnswers(for type: ResponseType) {
        let currentAnswer = questions[questionIndex].answers
        switch type {
        case .single:
            showSingleQuestion(with: currentAnswer)
        case .multiple:
            showMultipleQuestion(with: currentAnswer)
        case .ranged:
            showRangedQuestion(with: currentAnswer)
        }
    }
    
    func showSingleQuestion(with answers: [Answer]) {
        singleStackView.isHidden = false
        for answer in answers {
            settingButtonOfSingleQuestion(text: answer.title)
        }
    }
    
    func showMultipleQuestion(with answers: [Answer]) {
        multipleStackView.isHidden = false
        multipleAndRangedButton.isHidden = false
        for answer in answers {
            settingLabelOfMultipleQuestion(text: answer.title)
        }
    }
    
    func showRangedQuestion(with answers: [Answer]) {
        rangedStackView.isHidden = false
        multipleAndRangedButton.isHidden = false
        settingLabelOfRangedQuestion(
            leftText: answers.first?.title ?? "",
            rightText: answers.last?.title ?? ""
        )
    }
}

private extension QuestionsViewController {
    
    func settingQuestionLabel() {
        questionLabel.font = questionLabel.font.withSize(20)
        questionLabel.adjustsFontSizeToFitWidth = true
    }
    
    func settingSingleStackView() {
        singleStackView.axis = .vertical
        singleStackView.spacing = 16
        singleStackView.alignment = .center
    }
    
    func settingMultipleStackView() {
        multipleStackView.axis = .vertical
        multipleStackView.spacing = 16
    }
    
    func settingRangedStackView() {
        rangedStackView.axis = .vertical
        rangedStackView.spacing = 16
        let slider = UISlider()
        slider.value = 0.5
        rangedStackView.addArrangedSubview(slider)
    }
    
    func settingButtonOfSingleQuestion(text: String) {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: #selector(singleButtonAnswerPressed), for: .touchUpInside)
        singleStackView.addArrangedSubview(button)
    }
    
    func settingLabelOfMultipleQuestion(text: String) {
        let stackView = UIStackView()
        let propertyLabel = UILabel()
        let propertySwitch = UISwitch()
        
        stackView.axis = .horizontal
        propertyLabel.text = text
        propertySwitch.isOn = true
        
        stackView.addArrangedSubview(propertyLabel)
        stackView.addArrangedSubview(propertySwitch)
        multipleStackView.addArrangedSubview(stackView)
    }
    
    func settingLabelOfRangedQuestion(leftText: String, rightText: String) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.textAlignment = .right
        leftLabel.text = leftText
        rightLabel.text = rightText
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightLabel)
        rangedStackView.addArrangedSubview(stackView)
    }
    
    func settingMultipleAndRangedButtonButtonAnswerPressed() {
        multipleAndRangedButton.setTitle("Ответить", for: .normal)
        multipleAndRangedButton.addTarget(
            self,
            action:#selector(multipleAndRangedButtonAnswerPressed),
            for: .touchUpInside
        )
    }
    
    func addSubiewInView() {
        propertiesView.forEach {
            view.addSubview($0)
        }
    }
    
    func setFalseForPropertiesConstraints() {
        propertiesView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func settingALLProperties() {
        
        settingQuestionLabel()
        settingSingleStackView()
        settingMultipleStackView()
        settingRangedStackView()
        settingMultipleAndRangedButtonButtonAnswerPressed()
        
        addSubiewInView()
        setFalseForPropertiesConstraints()
    }
    
    func setAllConstraints() {
        setQuestionLabelConstraint()
        setQuestionProgressViewConstraint()
        setSingleStackViewConstraint()
        setMultipleStackViewConstraint()
        setRangedStackViewConstraint()
        setMultipleAndRangedButtonButtonAnswerPressedConstraint()
    }
}

// Установка констреинтов
private extension QuestionsViewController {
    // Установка констреинтов для лейбла, отвечающего за вопрос
    func setQuestionLabelConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: questionLabel, attribute: .top,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .top,
                multiplier: 1, constant: 8
            ),
            NSLayoutConstraint(
                item: questionLabel, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: questionLabel, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            ),
        ])
    }
    // Установка констреинтов для прогресса
    func setQuestionProgressViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: questionProgressView, attribute: .centerX,
                relatedBy: .equal,
                toItem: view, attribute: .centerX,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: questionProgressView, attribute: .top,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .top,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: questionProgressView, attribute: .width,
                relatedBy: .equal,
                toItem: view, attribute: .width,
                multiplier: 1, constant: 0
            )
        ])
    }
    // Устанвока констреинтов для стека батонов
    func setSingleStackViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: singleStackView, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: singleStackView, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            ),
            NSLayoutConstraint(
                item: singleStackView, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: 0
            )
        ])
    }
    // Установка констреинтов для стека переключателей
    func setMultipleStackViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: multipleStackView, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: multipleStackView, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            ),
            NSLayoutConstraint(
                item: multipleStackView, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: 0
            )
        ])
    }
    // Установка констреинтов для стека диапазона
    func setRangedStackViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: rangedStackView, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: rangedStackView, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            ),
            NSLayoutConstraint(
                item: rangedStackView, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: 0
            )
        ])
    }
    // Установка констреинтов для батона "ответить"
    func setMultipleAndRangedButtonButtonAnswerPressedConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: multipleAndRangedButton, attribute: .centerX,
                relatedBy: .equal,
                toItem: view, attribute: .centerX,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: multipleAndRangedButton, attribute: .bottom,
                relatedBy: .equal,
                toItem: view, attribute: .bottom,
                multiplier: 1, constant: -20
            )
        ])
    }
}
