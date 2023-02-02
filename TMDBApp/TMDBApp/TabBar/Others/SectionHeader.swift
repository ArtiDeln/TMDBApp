//
//  SectionHeader.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLabel)
        
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constraints() {
        self.titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
