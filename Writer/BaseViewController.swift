//
//  BaseViewController.swift
//  Writer
//
//  Created by Eugene on 2022/12/3.
//

import UIKit

class BaseViewController: UIViewController {

    let navBarViewHeight = kStatueHeight + kNavigationBarHeight
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true;
        view.backgroundColor = UIColor.init(hexColor: "#FBFBFB")
          
        view.addSubview(navView)
    }
    
    func popCurrentViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    lazy var navView: NavBarView = {
        let backImage = UIImage(systemName: "arrow.backward")?.tintImage(.black)
        let navView = NavBarView.init(title: "Nav Title", backImage: backImage) {
            self.popCurrentViewController()
        }
        return navView
    }()
 

}
