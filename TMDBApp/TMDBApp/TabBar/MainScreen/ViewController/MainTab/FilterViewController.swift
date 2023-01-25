//
//  FilterViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 24.01.23.
//

import UIKit

class FilterViewController: UIViewController {
    
    private(set) lazy var mainTabVC = MainTabViewController()
    private(set) lazy var stackView = UIStackView()
    private(set) lazy var popularMoviesToggle = UISwitch()
    private(set) lazy var upcomingMoviesToggle = UISwitch()
    private(set) lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStackView()
        self.setupToggleButtons()
        self.setupDoneButton()
        self.constraints()
        self.view.backgroundColor = .systemBackground
        
        self.popularMoviesToggle.isOn = UserDefaults.standard.bool(forKey: "section1SelectedKey")
        self.upcomingMoviesToggle.isOn = UserDefaults.standard.bool(forKey: "section2SelectedKey")
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
    }
    
    private func setupToggleButtons() {
        self.popularMoviesToggle.addTarget(self, action: #selector(section1ToggleChanged), for: .valueChanged)
        let section1Label = UILabel()
        section1Label.text = "Popular"
        stackView.addArrangedSubview(section1Label)
        stackView.addArrangedSubview(popularMoviesToggle)
        
        self.upcomingMoviesToggle.addTarget(self, action: #selector(section2ToggleChanged), for: .valueChanged)
        let section2Label = UILabel()
        section2Label.text = "Upcoming"
        stackView.addArrangedSubview(section2Label)
        stackView.addArrangedSubview(upcomingMoviesToggle)
    }
    private func setupDoneButton() {

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
