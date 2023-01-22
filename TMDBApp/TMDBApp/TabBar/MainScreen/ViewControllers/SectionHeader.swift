//
//  SectionHeader.swift
//  TMDBApp
//
//  Created by Artyom Butorin on 22.01.23.
//

import UIKit

class HeaderView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
