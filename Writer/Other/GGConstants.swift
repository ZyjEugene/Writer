//
//  GGConstants.swift
//  Writer
//
//  Created by 张艳金 on 2022/11/29.
//

import UIKit
 
/// 方正滕占敏竹刻繁
let TengZhanMinFanFont = "FZTengZhanMinZhuKeS-R-GB"
/// 张乃仁行楷简繁
let ZhangNaiRenJianFanFont = "FZZJ-ZNRXKFW"
/// 张乃仁行楷简体
let ZhangNaiRenJianFont = "FZZJ-ZNRXKJW"
/// 张心启欧体楷书繁简
let ZhangQiOuJianFanFont = "www.6763.net"
/// 惠中行书简
let HuiZhongJianFont = "Cloudtype-HZXingshuGB"
/// 顾仲安行书
let GuZhongAnFont = "hakuyoxingshu7000"
/// 汉鼎繁颜体
let HanDingYanFanFont = "汉鼎繁颜体"
/// 勤礼碑颜体简
let QinLiBieYanJianFont = "STFQLBYTJW"
/// 勤礼碑颜体简繁
let QinLiBieYanJianFanFont = "STFQLBYTJF"
/// 杜慧田毛笔楷书简
let DuHuiTianRuanFont = "FZZJ-DHTMBKSJW"
/// 杜慧田硬笔楷书简繁
let DuHuiTianYingFont = "FZZJ-DHTMBKSJF"
/// 张颢硬笔楷书简
let ZhangHaoJianFont = "FZZJ-ZHYBKTJW"
/// 清楷体
let QingKaiFont = "zktqkt"
 
// MARK: - 全局常量
let kScreenW = UIScreen.main.bounds.size.width
let kScreenH = UIScreen.main.bounds.size.height
/// 判断是否为 iPhone X
let isIphoneX = kScreenH >= 812 ? true : false
/// 状态栏高度
let kStatueHeight : CGFloat = isIphoneX ? 44 : 20
/// 导航栏高度
let kNavigationBarHeight :CGFloat = 44
/// TabBar高度
let kTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49
/// 宽度比
let kWidthRatio = kScreenW / 375.0
/// 高度比
let kHeightRatio = kScreenH / 667.0

/// 今日诗词Token
let PoetryToken = "ZElsDDHcuauj/pN0wumCqAydBAsmePQt" 

// MARK: - 自适应宽、高度
/// 自适应宽度
func AdaptW(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kWidthRatio
}

/// 自适应高度
func AdaptH(_ value : CGFloat) -> CGFloat {
    return ceil(value) * kHeightRatio
}

/// 自适应系统字体
func SystemFontSize(_ size : CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: AdaptW(size))
}
 
/// 自适应系统字体宽度
func AdaptFontSize(_ name : String, _ size : CGFloat) -> UIFont {
    return UIFont(name: name, size: AdaptW(size)) ?? UIFont.font(size: AdaptW(size), weight: .regular)
}
 
// MARK: - 系统字体宽度枚举
enum fontWeight {
    case thin
    case ultraLight
    case regular
    case medium
    case semibold
    case bold
    
    @available(iOS 8.2, *)
    func systemWeight() -> UIFont.Weight {
        switch self {
        case .thin:
            return UIFont.Weight.thin
        case .ultraLight:
            return UIFont.Weight.ultraLight
        case .regular:
            return UIFont.Weight.regular
        case .medium:
            return UIFont.Weight.medium
        case .semibold:
            return UIFont.Weight.semibold
        case .bold:
            return UIFont.Weight.bold
        }
    }
}

// UIFont + Extension
extension UIFont {
    /// 系统字体，默认字号16，Weight为regular
    class func font(size: CGFloat = 16, weight: fontWeight = .regular) -> UIFont! {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: weight.systemWeight())
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}

extension UIFont {
    /// 动态字体获取
    static func font(name: String, size: CGFloat, of type: String = "ttf") -> UIFont {
        let fontName = loadFontFile(name, ofType: type)
        return UIFont.init(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    /// 加载本地字体
    static func loadFontFile(_ name: String, ofType type: String = "ttf", target bundle: Bundle = .main) -> String {
        var fullName: String = ""
        guard let path = bundle.path(forResource: name, ofType: type) else {
            return ""
        }
        if let fontData = NSData(contentsOfFile: path) {
            fullName = registerFont(fontData: fontData)
        }
        return fullName
    }
    
    /// 动态注册字体文件
    static func registerFont(fontData: NSData) -> String {
        // ...通过CGDataProvider承载生成CGFont对象
        let fontDataProvider = CGDataProvider(data: CFBridgingRetain(fontData) as! CFData)
        let fontRef = CGFont(fontDataProvider!)!
        // ...注册字体
        var fontError = Unmanaged<CFError>?.init(nilLiteral: ())
        CTFontManagerRegisterGraphicsFont(fontRef, &fontError)
        // ...获取了字体实际名字
        let fullName: String = fontRef.fullName! as String
        let postScriptName: String = fontRef.postScriptName! as String
        return fullName
    }
}

// MARK: - optionals 可选值转换
extension Int {
    func toDouble() -> Double {
        Double(self)
    }
    
    func toString() -> String {
        "\(self)"
    }
}

extension Double {
    func toInt() -> Int {
        Int(self)
    }
    
    func toString() -> String {
        String(format: "%.02f", self)
    }
}
