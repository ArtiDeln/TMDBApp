//
//  SettingsViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 20.01.23.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    
    let versionLabel: UILabel = {
        let label = UILabel()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            label.text = "Application version: \(version)"
        }
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.versionLabel)

        self.setConstraints()
    }
    
    private func setConstraints() {
        versionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
