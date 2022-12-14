//
//  BooksViewController.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/2.
//

import UIKit
 
class BooksViewController: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var fontName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(booksCollectionView)
        booksCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(navBarViewHeight)
            make.left.bottom.right.equalToSuperview()
        }
        
    }
    
    private let BookCollectionCellID = "BookCollectionViewCell"
    lazy var booksCollectionView : UICollectionView = {
        //设置布局
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        let itemSpac = (kScreenW - 60 - 14 - (59*4)) / 3
        layout.scrollDirection = .vertical //竖直
        layout.itemSize = CGSize.init(width: 59, height: 142)
        layout.minimumInteritemSpacing = itemSpac //item 间距
        layout.minimumLineSpacing = 5
        layout.sectionInset = .init(top: 5, left: 30, bottom: 0, right: 30)
        
        let collectView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = .white.withAlphaComponent(0)
        collectView.showsVerticalScrollIndicator = false
        
        //注册cell
        collectView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionCellID)
//        collectView.register(FontsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingFontHeadID)
//        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "foot")
        return collectView
    }()
    
    lazy var dataArray: [String] = {
        return []
    }()
}

extension BooksViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6//dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionCellID, for: indexPath) as! BookCollectionViewCell
         
        cell.titleLabel.font = AdaptFontSize(fontName, 20)
        cell.subTitleLabel.font = AdaptFontSize(fontName, 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenW-14, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenW, height: 0.001)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingFontHeadID, for: indexPath) as! FontsCollectionReusableView
//            return head
//        }else{
//            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "foot", for: indexPath)
//            return footerView
//        }
//    }
}
