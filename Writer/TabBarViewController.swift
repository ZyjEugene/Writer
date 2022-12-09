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
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: MoreViewController())
//        let vc3 = UINavigationController(rootViewController: SearchViewController())
//        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "ellipsis.circle")//pencil.circle
//        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")// more -》ellipsis.circle
//        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")// person -》 person.circle
        
        vc1.title = "Home"
        vc2.title = "More"
//        vc3.title = "Top Search"
//        vc4.title = "Downloads"
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2], animated: true)
    }
    
}
