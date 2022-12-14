//
//  BaseNavigationViewController.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/14.
//

import UIKit

class BaseNavigationViewController: UINavigationController,UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.delegate = self;
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // 在完全退出时，强制类型转为 BaseViewController，并重置 导航栏隐藏与显示
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        var vc: BaseViewController?
//        if viewControllers.count > 0 {
//            vc = viewControllers.last as? BaseViewController
//            //vc!.resetNavigationBar()
//        }
//    }
}
