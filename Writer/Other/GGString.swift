//
//  GGString.swift
//  Writer
//
//  Created by Eugene on 2022/12/5.
//  让代码更整洁的24个Swift扩展：https://www.jianshu.com/p/611fff8d739e

import UIKit
import Foundation

class GGString: NSObject {

}
 
extension String {
    /// JSON 是一种交换或存储结构化数据的流行格式。大多数 API 都喜欢使用 JSON。JSON 是一种 JavaScript 结构。Swift 有完全相同的数据类型—字典（dictionary）
    /// let json = "{\"hello\": \"world\"}"
    /// let dictFromJson = json.asDict
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
    
    
    /// 将 JSON 数组转换为 Swift 数组
    /// let json2 = "[1, 2, 3]"
    /// let arrFromJson2 = json2.asArray
    var asArray: [Any]? {
            guard let data = self.data(using: .utf8) else { return nil }
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
        }
    
    /// UILabel 可以显示带有粗体（<strong>）部分的文本、带下划线的文本、更大和更小的片段等。您只需要将 HTML 转换为 NSAttributedString，并将其分配给 UILabel.attributedText 即可
    /// let htmlString = "<p>Hello, <strong>world!</strong></p>"
    /// let attrString = htmlString.asAttributedString
    var asAttributedString: NSAttributedString? {
            guard let data = self.data(using: .utf8) else { return nil }
            return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }
    
    /// 裁剪 String 类型的字符串时，去掉空格和其他类似的符号（例如，换行和制表符）
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    /// var str1 = "  a b c d e   \n"
    /// var str2 = str1.trimmed
    /// str1.trim() // a b c d e
    mutating func trim() {
        self = self.trimmed
    }
    
    /// 处理可选类型或链式转换
    /// let strUrl = "https://medium.com"
    /// let url = strUrl.asURL
    var asURL: URL? {
        URL(string: self)
    }
    
    /** 计算字符串的宽度和高度
     let text = "Hello, world!"
     let textHeight = text.height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 16))
     */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
           let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

           return ceil(boundingBox.height)
       }

       func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
           let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
           let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

           return ceil(boundingBox.width)
       }
    
    /// 从 String 中获取 Date 日期
    func toDate(format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: self)
    }
    
}

/// 格式化 Date 日期
/// let strDate = "2020-08-10 15:00:00"
/// let date = strDate.toDate(format: "yyyy-MM-dd HH:mm:ss")
/// let strDate2 = date?.toString(format: "yyyy-MM-dd HH:mm:ss")
extension Date {
    func toString(format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}

/** 计算字符串的宽度和高度
 let text = "Hello, world!"
 let textHeight = text.height(withConstrainedWidth: 100, font: UIFont.systemFont(ofSize: 16))
 */
extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.width)
    }
}

/**
 Swift 5有一种下标字符串的方式。例如，如果你想获得从5到10的字符，计算索引和偏移量是很麻烦的。这个扩展允许使用简单的 Ints 类型来实现这个目的。
 用法
 let subscript1 = "Hello, world!"[7...]
 let subscript2 = "Hello, world!"[7...11]*/
extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
}
