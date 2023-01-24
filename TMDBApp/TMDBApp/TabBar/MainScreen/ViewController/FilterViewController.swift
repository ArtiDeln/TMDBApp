//
//  FilterViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 24.01.23.
//

import UIKit

class FilterViewController: UIViewController {
    private let stackView = UIStackView()
    private let section1Toggle = UISwitch()
    private let section2Toggle = UISwitch()
    private let section3Toggle = UISwitch()
    private let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupToggleButtons()
        setupDoneButton()
        self.view.backgroundColor = UIColor.clear
//        self.modalPresentationStyle = UIModalPresentationStyle
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupToggleButtons() {
        section1Toggle.isOn = true
        section1Toggle.addTarget(self, action: #selector(section1ToggleChanged), for: .valueChanged)
        let section1Label = UILabel()
        section1Label.text = "Section 1"
        stackView.addArrangedSubview(section1Label)
        stackView.addArrangedSubview(section1Toggle)
        
        section2Toggle.isOn = true
        section2Toggle.addTarget(self, action: #selector(section2ToggleChanged), for: .valueChanged)
        let section2Label = UILabel()
        section2Label.text = "Section 2"
        stackView.addArrangedSubview(section2Label)
        stackView.addArrangedSubview(section2Toggle)
        
        section3Toggle.isOn = true
        section3Toggle.addTarget(self, action: #selector(section3ToggleChanged), for: .valueChanged)
        let section3Label = UILabel()
        section3Label.text = "Section 3"
        stackView.addArrangedSubview(section3Label)
        stackView.addArrangedSubview(section3Toggle)
    }
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
//        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(doneButton)
    }
    
    @objc private func section1ToggleChanged() {
        // update your property in MainTabViewController to keep track of which sections are selected/deselected
    }
    
    @objc private func section2ToggleChanged() {
        // update your property in MainTabViewController to keep track of which sections are selected/deselected
    }
    
    @objc private func section3ToggleChanged() {
        // update your property in MainTabViewController to keep track of which sections are selected/deselected
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
    
}
