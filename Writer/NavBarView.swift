//
//  NavBarView.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/14.
//

import UIKit

public enum NavBarItemDirection: Int {
    case left, right
}

public class NavBarView: UIImageView {
    // MARK: - Public
    /// 回调导航条点击的返回按钮
    public typealias backNavViewItemActionBlock = (() -> Void)
    /// 回调导航条点击按钮的方位（一般为左、右两个）
    public typealias directionNavViewItemActionBlock = ((NavBarItemDirection) -> Void)
    /// 回调导航条点击的按钮
    public typealias navBarViewItemActionBlock = ((UIButton, Int) -> Void)
    /// 隐藏返回按钮
    public var isHiddenBackItem = false {
        didSet {
            for itemView in self.subviews {
                if itemView is UIButton, itemView.tag == tagBaseNumber {
                    itemView.isHidden = isHiddenBackItem
                }
            }
        }
    }
    // MARK: - Private
    fileprivate var navItemActionBlcok: navBarViewItemActionBlock?
    private let tagBaseNumber = 90000

    // MARK: - Init
    public convenience init(title: String?) {
        self.init(bgImage: nil, title: title, backBtn: nil, rightItems: [], rightSpace: 0) { btn, btnTag in
        }
    }
    
    public convenience init(title: String?, backImage: UIImage?, itemAction: backNavViewItemActionBlock?) {
        self.init(title: title, backImage: backImage, rightImage: nil) { direction in
            if let backBlock = itemAction {
                backBlock()
            }
        }
    }
    public convenience init(title: String?, backImage: UIImage?, rightImage: UIImage?, itemsAction: directionNavViewItemActionBlock?) {
        self.init()

        let backBtn: UIButton = self.backButton
        backBtn.setImage(backImage, for: .normal)
        
        let rightBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        rightBtn.setImage(rightImage, for: .normal)
        
        self.init(bgImage: nil, title: title, backBtn: backBtn, rightItems: [rightBtn], rightSpace: 0) { btn, btnTag in
               if let items = itemsAction {
                   items(btnTag > self.tagBaseNumber ? .right : .left)
               }
        }
    }
    public convenience init(bgImage: String?, title: String?, backBtn: UIButton?, rightItems: [UIButton], rightSpace: CGFloat, itemAction: navBarViewItemActionBlock?) {
        
        self.init()
        
        let navBarH: CGFloat = getSafeAreaInsetsTopHeight() + 44.0
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: navBarH)
        self.frame = frame
        
        self.navItemActionBlcok = itemAction
        
        // 视图背景图片
        self.isUserInteractionEnabled = true
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        if let bgImg = bgImage {
            self.image = UIImage(named: bgImg)
        } else {
            self.backgroundColor = .white
        }
        
        // 返回按钮
        if let backButton = backBtn {
            backButton.addTarget(self, action: #selector(navBarViewButtonAction(sender:)), for: .touchUpInside)
            backButton.tag = tagBaseNumber
            self.addSubview(backButton)
            backBtn?.snp.makeConstraints({ make in
                make.left.bottom.equalToSuperview()
                make.size.equalTo(backButton.bounds.size)
            })
        }
        
        // title
        self.titleLabel.text = title
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp_makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44.0)
        }
        
        // 添加右边items
        var totalW: CGFloat = 0.0
            for i in 0..<rightItems.count {
            let button: UIButton = rightItems[i]
            button.addTarget(self, action: #selector(navBarViewButtonAction(sender:)), for: .touchUpInside)
            button.tag = (tagBaseNumber + 1) + i
            
            totalW += button.bounds.size.width
        }
        
        var left: CGFloat = 0.0
        for i in 0..<rightItems.count {
            let button: UIButton = rightItems[i]
            self.addSubview(button)
            
            let origin_x = (self.bounds.size.width - totalW - rightSpace) + left
            left += button.bounds.size.width
            
            button.snp_makeConstraints { make in
                make.left.equalToSuperview().offset(origin_x)
                make.bottom.equalToSuperview()
                make.size.equalTo(CGSize(width: button.bounds.size.width, height: 44.0))
            }
        }
        
    }
    
    // MARK: - Methods
    @objc private func navBarViewButtonAction(sender: UIButton){
        if let block = self.navItemActionBlcok {
            let tag  = sender.tag - tagBaseNumber
            block(sender, tag)
        }
    }
    
    /// 安全区域 - 顶部高度
    private func getSafeAreaInsetsTopHeight() -> CGFloat {
        var topHeight: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            if let window = keywindow() {
                topHeight = CGFloat((window.windowScene?.statusBarManager?.statusBarFrame.size.height)!)
            }
        } else {
            topHeight = CGFloat(UIApplication.shared.statusBarFrame.size.height)
        }
        
        if topHeight > 20.0 {
            if let window = keywindow() {
                topHeight = window.safeAreaInsets.top
            }
        } else {
            topHeight = 20;
        }
        return topHeight
    }
    
    /// 获取当前Window
    private func keywindow() ->UIWindow? {
        var window:UIWindow? = nil
        if #available(iOS 13.0, *) {
            for scene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set)!) {
                if scene.activationState == .foregroundActive {
                    window = scene.windows.first
                    break
                }
            }
            return window
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    // MARK: - Lazy
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        return backBtn
    }()
}
