//
//  HomeViewController.swift
//  Writer
//
//  Created by 张艳金 on 2022/11/28.
//

import UIKit

class HomeViewController: BaseViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadFontsData()
        
        view.addSubview(writingFontCollectionView)
        writingFontCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kStatueHeight)
            make.left.bottom.right.equalToSuperview()
        }
        
        let lunYuJson = loadLocalJson("lunyu")
        let poetryAry = JsonUtil.jsonArrayToModel(lunYuJson, PoetryDetailModel.self)
        print("model ary : \(poetryAry)")
        
        NetWorkRequest(API.todayWeather, modelType: TodayWeatherModel.self) { weatherData, rspModel in
            print(weatherData)
        }
        
        
        NetWorkRequest(API.todayPoetrySentence, modelType: TodayPoetryModel.self) { weatherData, rspModel in
            print(weatherData)
        }
        
        // 并行调用异步方法
//        Task.init(priority: .low) {
//            await getTodayWeatherData()
//            await getTodayPoetryData()
//        }
    }
    
    
    
    func getTodayPoetryData() async -> Void {
        NetWorkRequest(API.todayPoetrySentence, modelType: TodayPoetryModel.self) { weatherData, rspModel in
            print(weatherData)
        }
    }
    func getTodayWeatherData() async -> Void {
        NetWorkRequest(API.todayWeather, modelType: TodayWeatherModel.self) { weatherData, rspModel in
            print(weatherData)
        }
    }
    
    /// 初始化数据
    private func loadFontsData() {
        let fonts = [TengZhanMinFanFont,
                     ZhangNaiRenJianFanFont,
                     ZhangNaiRenJianFont,
                     QinLiBieYanJianFont,
                     QinLiBieYanJianFanFont,
                     DuHuiTianRuanFont]
        
        let fontsInfo = [TengZhanMinFanFont : "方正滕占敏竹刻 繁",
                     ZhangNaiRenJianFanFont : "张乃仁行楷 简繁",
                        ZhangNaiRenJianFont : "张乃仁行楷 简",
                        QinLiBieYanJianFont : "勤礼碑颜体 简",
                     QinLiBieYanJianFanFont : "勤礼碑颜体 简繁",
                          DuHuiTianRuanFont : "杜慧田毛笔楷书"]
        for font in fonts {
            let model = FontModel()
            model.name = font
            model.author = fontsInfo[font] ?? ""
            dataArray.append(model)
        }
    }
    
    private let WritingFontCellID = "FontItemCollectionViewCell"
    private let WritingFontHeadID = "FontsCollectionReusableView"
    private lazy var writingFontCollectionView : UICollectionView = {
        //设置布局
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical //竖直
        layout.itemSize = CGSize.init(width: kScreenW - 32, height: 80)
        layout.minimumLineSpacing = 20
        layout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        
        let collectView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectView.delegate = self
        collectView.dataSource = self
        collectView.backgroundColor = .white.withAlphaComponent(0)
        collectView.showsVerticalScrollIndicator = false
        
        //注册cell、 header、 Footer
        collectView.register(FontItemCollectionViewCell.self, forCellWithReuseIdentifier: WritingFontCellID)
        collectView.register(FontsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingFontHeadID)
        collectView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "foot")
        return collectView
    }()
    
    private lazy var dataArray: [FontModel] = {
        return []
    }()
}

extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WritingFontCellID, for: indexPath) as! FontItemCollectionViewCell
        let fontModel = dataArray[indexPath.row]
        cell.titleLabel.text = fontModel.author
        cell.subTitleLabel.text = fontModel.displayText
        cell.titleLabel.font = AdaptFontSize(fontModel.name, 20)
        cell.subTitleLabel.font = AdaptFontSize(fontModel.name, 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fontModel = dataArray[indexPath.row]
        let bookVC = BooksViewController();
        bookVC.fontName = fontModel.name
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenW-14, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenW, height: 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WritingFontHeadID, for: indexPath) as! FontsCollectionReusableView
            return head
        }else{
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "foot", for: indexPath)
            return footerView
        }
    }
}
