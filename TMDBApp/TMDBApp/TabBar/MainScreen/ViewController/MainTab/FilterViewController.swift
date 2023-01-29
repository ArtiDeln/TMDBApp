//
//  FilterViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 24.01.23.
//

import UIKit

class FilterViewController: UIViewController {
    
    private(set) lazy var mainTabVC = MainTabViewController()
    
    // MARK: GUI
    
    private(set) lazy var stackView = UIStackView()
    
    private(set) lazy var popularSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Popular"
        return label
    }()
    
    private(set) lazy var upcomingSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Upcoming"
        return label
    }()
    
    private(set) lazy var popularMoviesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(popularSectionToggleChanged), for: .valueChanged)
        return toggle
    }()
    
    private(set) lazy var upcomingMoviesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(upcomingSectionToggleChanged), for: .valueChanged)
        return toggle
    }()
    
    private(set) lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        self.initView()
        self.constraints()
        
        self.popularMoviesToggle.isOn = UserDefaults.standard.bool(forKey: Constants.popularKey)
        self.upcomingMoviesToggle.isOn = UserDefaults.standard.bool(forKey: Constants.upcomingKey)
    }
    
    private func initView() {
        self.stackView.axis = .vertical
        self.stackView.spacing = 10
        
        self.view.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.popularSectionLabel)
        self.stackView.addArrangedSubview(self.popularMoviesToggle)
        
        self.stackView.addArrangedSubview(self.upcomingSectionLabel)
        self.stackView.addArrangedSubview(self.upcomingMoviesToggle)
        
        self.stackView.addArrangedSubview(self.doneButton)
    }

    @objc private func popularSectionToggleChanged() {
        UserDefaults.standard.set(self.popularMoviesToggle.isOn, forKey: Constants.popularKey)
    }
    
    @objc private func upcomingSectionToggleChanged() {
        UserDefaults.standard.set(self.upcomingMoviesToggle.isOn, forKey: Constants.upcomingKey)
    }
    
    @objc private func doneButtonTapped() {
        self.mainTabVC.fetchMovies()
        dismiss(animated: true)
    }
    
    private func constraints() {
        self.stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }
}
