//
//  ViewController.swift
//  lesson208
//
//  Created by Garib Agaev on 31.12.2022.
//

import UIKit

class AnimalsViewController: UIViewController {
    
    private let interviewAndAnimalStackView = UIStackView()
    private let animalLabel = UILabel()
    private let interviewButton = UIButton(type: .system)
    private var animalLabels: [UILabel] = []
    
    private var propertysView: [UIView] {
        [interviewAndAnimalStackView] + animalLabels
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingALLProperties()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setAllConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let questionNC = segue.destination as? UINavigationController else { return }
        questionNC.modalPresentationStyle = .fullScreen
        questionNC.navigationBar.prefersLargeTitles = true
    }
    
    @objc private func jumpByInterviewButtonAction() {
        performSegue(withIdentifier: "questionNC", sender: nil)
    }
}

private extension AnimalsViewController {
    
    func settingInterviewAndAnimalStackView() {
        for property in [animalLabel, interviewButton] {
            interviewAndAnimalStackView.addArrangedSubview(property)
        }
        interviewAndAnimalStackView.axis = .vertical
        interviewAndAnimalStackView.alignment = .center
        interviewAndAnimalStackView.distribution = .fill
        interviewAndAnimalStackView.spacing = 16
    }
    
    func settingAnimalLabels() {
        var index = 0
        for animal in Animal.allCases {
            if index >= 4 {
                return
            }
            animalLabels.append(UILabel())
            animalLabels[index].text = animal.rawValue
            animalLabels[index].textAlignment = .center
            animalLabels[index].font = animalLabels[index].font.withSize(30)
            index += 1
        }
    }
    
    func settingAnimalLabel() {
        animalLabel.text = "Какое вы животное?"
        animalLabel.font = animalLabel.font.withSize(30)
        animalLabel.textAlignment = .center
    }
    
    func settingInterviewButton() {
        // style?
        interviewButton.setTitle("Начать опрос", for: .normal)
        interviewButton.titleLabel?.font = interviewButton.titleLabel?.font.withSize(20)
        interviewButton.addTarget(self, action: #selector(jumpByInterviewButtonAction), for: .touchUpInside)
    }
    
    func addSubiewInView() {
        propertysView.forEach {
            view.addSubview($0)
        }
    }
    
    func setFalseForPropertyConstraints() {
        propertysView.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func settingALLProperties() {
        
        settingInterviewAndAnimalStackView()
        settingAnimalLabel()
        settingInterviewButton()
        settingAnimalLabels()
        
        addSubiewInView()
        setFalseForPropertyConstraints()
    }
    
    func setAllConstraints() {
        setInterviewAndAnimalStackViewConstraint()
        setAnimalsButtonСonstraint()
    }
}

private extension AnimalsViewController {
    
    func setInterviewAndAnimalStackViewConstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: interviewAndAnimalStackView, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: interviewAndAnimalStackView, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: interviewAndAnimalStackView, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            )
        ])
    }
    
    func setAnimalsButtonСonstraint() {
        let attributes: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        for (index, label) in animalLabels.enumerated() {
            let (i, j) = (index % 2, index / 2)
            NSLayoutConstraint.activate([
                NSLayoutConstraint(
                    item: label, attribute: attributes[i],
                    relatedBy: .equal,
                    toItem: view.safeAreaLayoutGuide, attribute: attributes[i],
                    multiplier: 1, constant: pow(-1, CGFloat(i)) * 16
                ),
                NSLayoutConstraint(
                    item: label, attribute: attributes[2 + j],
                    relatedBy: .equal,
                    toItem: view.safeAreaLayoutGuide, attribute: attributes[2 + j],
                    multiplier: 1, constant: pow(-1, CGFloat(j)) * 20
                )
            ])
        }
    }
}
