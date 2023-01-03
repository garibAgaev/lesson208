//
//  ResultViewController.swift
//  lesson208
//
//  Created by Garib Agaev on 01.01.2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    private let youDefiniteAnimalLabel = UILabel()
    private let descriptionAnimalLabel = UILabel()
    private let doneBarButtonItem = UIBarButtonItem()
    
    var resultAnimal: Animal! = nil
    
    private var propertysView: [UIView] {
        [
            youDefiniteAnimalLabel,
            descriptionAnimalLabel
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingALLProperties()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setAllConstraints()
    }
    
    @objc private func showDoneBarButtonItem() {
        navigationController?.dismiss(animated: true)
    }
}

private extension ResultViewController {
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
    func settingDoneBarButtonItem() {
        doneBarButtonItem.title = "Done"
        doneBarButtonItem.style = .done
        doneBarButtonItem.target = self
        doneBarButtonItem.action = #selector(showDoneBarButtonItem)
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func settingYouDefiniteAnimalLabelLabel() {
        youDefiniteAnimalLabel.text = "Вы — \(resultAnimal.rawValue)"
        youDefiniteAnimalLabel.font = youDefiniteAnimalLabel.font.withSize(50)
        youDefiniteAnimalLabel.textAlignment = .center
    }
    
    func settingDescriptionAnimalLabelLabelLabel() {
        descriptionAnimalLabel.text = resultAnimal.definition
        descriptionAnimalLabel.textAlignment = .center
        descriptionAnimalLabel.numberOfLines = 0
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
        
        title = "Результаты"
        
        settingYouDefiniteAnimalLabelLabel()
        settingDescriptionAnimalLabelLabelLabel()
        settingDoneBarButtonItem()
        hideBackButton()
        
        addSubiewInView()
        setFalseForPropertyConstraints()
    }
    
    func setAllConstraints() {
        
        setYouDefiniteAnimalLabelСonstraint()
        setDescriptionAnimalLabelСonstraint()
    }
}

private extension ResultViewController {
    
    func setYouDefiniteAnimalLabelСonstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: youDefiniteAnimalLabel, attribute: .centerX,
                relatedBy: .equal,
                toItem: view, attribute: .centerX,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: youDefiniteAnimalLabel, attribute: .bottom,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: -4
            )
        ])
    }
    
    func setDescriptionAnimalLabelСonstraint() {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(
                item: descriptionAnimalLabel, attribute: .centerX,
                relatedBy: .equal,
                toItem: view, attribute: .centerX,
                multiplier: 1, constant: 0
            ),
            NSLayoutConstraint(
                item: descriptionAnimalLabel, attribute: .top,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1, constant: 4
            ),
            NSLayoutConstraint(
                item: descriptionAnimalLabel, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1, constant: 16
            ),
            NSLayoutConstraint(
                item: descriptionAnimalLabel, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1, constant: -16
            )
        ])
    }
}
