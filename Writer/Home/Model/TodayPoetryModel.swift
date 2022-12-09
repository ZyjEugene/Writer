//
//  TodayPoetryModel.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/9.
//

import Foundation
 
class OriginModel: BaseModel {
    var dynasty: String?
    var title: String?
    var content: Array<String>?
    var translate: Array<String>?
    var author: String?
}

class TodayPoetryModel: BaseModel {
    var popularity: Int?
    var id: String?
    var matchTags: Array<String>?
    var content: String?
    var origin: OriginModel?
    var cacheAt: String?
    var recommendedReason: String?
}
