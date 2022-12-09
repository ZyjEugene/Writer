//
//  FontsCollectionReusableView.swift
//  Writer
//
//  Created by 张艳金 on 2022/11/30.
//

import UIKit

class FontsCollectionReusableView: UICollectionReusableView {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "名家字体库"
        titleLabel.textColor = UIColor.init(hexColor: "#161823")
        titleLabel.font = UIFont(name: QinLiBieYanJianFanFont, size: 30)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
