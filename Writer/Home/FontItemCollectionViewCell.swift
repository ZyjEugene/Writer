//
//  FontItemCollectionViewCell.swift
//  Writer
//
//  Created by 张艳金 on 2022/11/30.
//

import UIKit

class FontItemCollectionViewCell: UICollectionViewCell {
    
    lazy var cardView: GGShadowCardView = {
        // MARK: init ShadowModel
        let shadowModel = ShadowModel()
        shadowModel.shadowRadius = 6
        shadowModel.shadowColor = UIColor.black
        shadowModel.shadowOpacity = 0.1
        shadowModel.side = .allSide
        // MARK: init CornerModel
        let cornerModel = CornerModel()
        cornerModel.cornerRadius = 6
        cornerModel.rectCorner = .all
        
        let cardView = GGShadowCardView(horizontal: 0, vertical: 0)
        cardView.setCornerModel(model: cornerModel)
        cardView.setShadowModel(model: shadowModel)
        cardView.infoView.backgroundColor = UIColor.white
        contentView.addSubview(cardView)
        return cardView
    }()
    
    lazy var tipLineView: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.init(hexColor: "#ff3300")
        cardView.infoView.addSubview(line)
        return line
    }()
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.text = "易经"
        lab.textColor = UIColor.init(hexColor: "#060606")
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.textAlignment = .center
        //lab.numberOfLines = 0
        cardView.infoView.addSubview(lab)
        return lab
    }()
 
    lazy var subTitleLabel: UILabel = {
        let lab = UILabel()
        lab.text = "昔在帝尧"
        lab.textColor = UIColor.init(hexColor: "#7D7A76")
        lab.font = UIFont.systemFont(ofSize: 13)
        lab.textAlignment = .center
        lab.numberOfLines = 0
        cardView.infoView.addSubview(lab)
        return lab
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI()
    {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tipLineView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(2)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.centerY)
            make.left.equalTo(tipLineView.snp.right).offset(14)
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.centerY)
            make.left.equalTo(titleLabel.snp.left)
            make.right.lessThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
        }
        
    }
      
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
