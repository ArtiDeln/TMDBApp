//
//  SpashViewController.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 18.01.23.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash-bg")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()
        
        self.displayDelay()
        self.constraints()
        
    }
    
    private func displayDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {

            self.backgroundImageView.alpha = 0
            self.logoImageView.alpha = 0
            self.activityIndicator.alpha = 0
            
        }, completion: { done in
            if done {
                let homeViewController = HomeViewController()
                homeViewController.modalTransitionStyle = .crossDissolve
                homeViewController.modalPresentationStyle = .fullScreen
                self.present(homeViewController, animated: true)
            }
        })
    }
    
    private func constraints() {
        backgroundImageView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(240)
            $0.height.equalTo(128)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerX.equalTo(logoImageView)
            $0.top.equalTo(logoImageView.snp.bottom).offset(10)
        }
    }
    
}
