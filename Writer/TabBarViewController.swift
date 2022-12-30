//
//  TabBarViewController.swift
//  Writer
//
//  Created by 张艳金 on 2022/11/28.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(hexColor: "#FBFBFB")
        
        let vc1 = BaseNavigationViewController(rootViewController: HomeViewController())
        let vc2 = BaseNavigationViewController(rootViewController: MoreViewController())
 
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "ellipsis.circle")//pencil.circle
 
        vc1.title = "Home"
        vc2.title = "More"
        tabBar.tintColor = .label
        // 避免TabBar透明
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        // 设置子控制器
        setViewControllers([vc1, vc2], animated: true)
         
        // iOS 13 去掉tabBar黑线
        if #available(iOS 13, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundImage = UIImage.imageWithColor(.clear)
            appearance.shadowImage = UIImage.imageWithColor(.clear)
            tabBar.standardAppearance = appearance
        } else {
            tabBar.backgroundImage = UIImage.imageWithColor(.clear)
            tabBar.shadowImage = UIImage.imageWithColor(.clear)
        }
    }
    
}

private var isAnimating = false
// https://www.jianshu.com/p/8e4f0e808599
extension UITabBar {
    // 显示｜隐藏 TabBar 方法
    func changeTabBar(hidden:Bool, animated: Bool){
        if isAnimating { return }   // 如果动画正在执行，则不执行！
        if self.isHidden == hidden { return }  // 如果已经是指定隐藏状态，则不执行！
        
        /*=========================================*/
        // 修复在TabBar隐藏的情况下，旋转屏幕动画错乱的Bug!
        if self.isHidden {
            self.frame = CGRect(
                x: frame.minX,
                y: UIScreen.main.bounds.height,
                width: frame.width,
                height: frame.height
            ) // 强行修改tabBar的Frame
        }
        /*=========================================*/
        
        let frame = self.frame  // 获取自身的frame
        let isOutScreen = Int(UIScreen.main.bounds.height - self.frame.minY) == 0   // 是否在屏幕外面，以此为判断动画方向的依据！
        let a: CGFloat = isOutScreen ? -1 : 1   // 定义动画方向 | 上下
        let offset = a * frame.size.height  // 设置动画偏移量
        let duration: TimeInterval = (animated ? 0.5 : 0.0) // 定义动画持续时间
        
        self.isHidden = false // 开始动画之前，先开启tabBar的显示！
        isAnimating = true // 标记动画【正在执行】状态
        
        UIView.animate(
            withDuration: duration,
            animations: {
                self.center.y += offset // 改变【中心点】偏移量！
            }) { _ in
            self.isHidden = !isOutScreen    // 设置tabBar的显示状态
            isAnimating = false // 取消动画【正在执行】状态
        }
    }
}
