//
//  GGDataManager.swift
//  Writer
//
//  Created by Eugene on 2022/12/5.
//

import Foundation
 
/// 将本地Json数据转为字典
func loadLocalJsonDict(_ fileName: String) -> Dictionary<String, Any> {
    return loadLocalJson(fileName).asDict ?? [:]
}

/// 获取本地Json数据
func loadLocalJson(_ fileName: String) -> String {
    if fileName.isEmpty {
        return ""
    }
  
    let path = Bundle.main.path(forResource: fileName, ofType: "json")
    guard let jsonStr = try? NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String else {
        return ""
    }
    //print("json: \(jsonStr)")
    return jsonStr

    
//    let jsonStrData = jsonStr.data(using: .utf8)
//    print("jsonStrData:\(String(describing: jsonStrData))")
     
//    guard let jsonData = try? NSData(contentsOfFile: path!) as Data else {
//        return
//    }
 
//    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
//        return
//    }
 
//    guard let data = try? Data(contentsOf: url) else {
//        return
//    }

}
 
/// 获取本地Json数据,并转数据为Data
func loadLocalJsonToData(_ fileName: String) -> Data {
 
    if fileName.isEmpty {
        return Data()
    }
  
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        return Data()
    }
 
    guard let localData = try? Data(contentsOf: url) else {
        return Data()
    } 

    return localData
}
 
 
