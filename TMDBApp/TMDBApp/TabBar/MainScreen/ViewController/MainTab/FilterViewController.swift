//
//  FilterViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 24.01.23.
//

import UIKit

class FilterViewController: UIViewController {
    
    private let mainTabVC = MainTabViewController()
    private let stackView = UIStackView()
    private let popularMoviesToggle = UISwitch()
    private let upcomingMoviesToggle = UISwitch()
    private let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupToggleButtons()
        setupDoneButton()
        self.view.backgroundColor = .systemBackground
        
        popularMoviesToggle.isOn = UserDefaults.standard.bool(forKey: "section1SelectedKey")
        upcomingMoviesToggle.isOn = UserDefaults.standard.bool(forKey: "section2SelectedKey")
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
    }
    
    private func setupToggleButtons() {
        popularMoviesToggle.addTarget(self, action: #selector(section1ToggleChanged), for: .valueChanged)
        let section1Label = UILabel()
        section1Label.text = "Popular"
        stackView.addArrangedSubview(section1Label)
        stackView.addArrangedSubview(popularMoviesToggle)
        
        upcomingMoviesToggle.addTarget(self, action: #selector(section2ToggleChanged), for: .valueChanged)
        let section2Label = UILabel()
        section2Label.text = "Upcoming"
        stackView.addArrangedSubview(section2Label)
        stackView.addArrangedSubview(upcomingMoviesToggle)
    }
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.yellow, for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(doneButton)
    }
    private func constraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
    @objc private func section1ToggleChanged() {
        UserDefaults.standard.set(popularMoviesToggle.isOn, forKey: "section1SelectedKey")
    }
    
    @objc private func section2ToggleChanged() {
        UserDefaults.standard.set(upcomingMoviesToggle.isOn, forKey: "section2SelectedKey")
    }

@objc private func doneButtonTapped() {
    self.mainTabVC.fetchMovies()
    dismiss(animated: true)
}

}
