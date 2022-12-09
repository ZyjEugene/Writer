//
//  BaseModel.swift
//  JsonModelUtil
//
//  Created by xml on 2018/4/28.
//  Copyright © 2018年 xml. All rights reserved.
//  https://github.com/alibaba/HandyJSON/blob/master/README_cn.md

import UIKit
import HandyJSON
class BaseModel: HandyJSON {
    //    var date: Date?
    //    var decimal: NSDecimalNumber?
    //    var url: URL?
    //    var data: Data?
    //    var color: UIColor?
    
    /// 标记HandyJSON jsonToModel、jsonArrayToModel、dictiToModel失败（该字段会被反序列化忽略）
    //    var fail: Bool = false
    
    // 1、模型遵循HandyJSON协议；
    // 2、class类需要实现空的initializer（Struct结构体 可以不需要init()）
    // 3、Struct自己已经帮助构造了init初始化，但如果我们需要重载init，构造我们自己的初始化，还是实现一下的init()
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        // 1、为避免关键字段混淆，替换其他关键字代替，如：xx_id（json里的数据） 可替换为 id（本地定义）;
        //        mapper <<<
        //            self.id <-- "xx_id"
        // 2、自定义解析规则，日期数字颜色，如果要指定解析格式，子类实现重写此方法即可；
        //        mapper <<<
        //            date <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd")
        //
        //        mapper <<<
        //            decimal <-- NSDecimalNumberTransform()
        //
        //        mapper <<<
        //            url <-- URLTransform(shouldEncodeURLString: false)
        //
        //        mapper <<<
        //            data <-- DataTransform()
        //
        //        mapper <<<
        //            color <-- HexColorTransform()
        
        //        mapper >>> self.fail
    }
    //运算符<--会返回一个元组，简单点理解就是，元组里第一个数据是属性id的地址，元组第二个数据是服务端返回对应数据的真实key，以demo中例子说就类似（0x39393994949, xx_id）
    //<<<执行这个最终就是将上面说的元组的内容添加到了self.mappingHandlers，实际执行的是self.mappingHandlers[key] = mappingInfo（key是元组的第一个元素，mappingInfo是元组的第二个元素）
    //<<< 和 <--是自定义的运算符，<--的优先级更高
}
