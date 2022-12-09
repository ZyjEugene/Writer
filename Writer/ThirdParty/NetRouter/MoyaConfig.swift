//
//  MoyaConfig.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 4/3/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//  NetworkConfig.swift

import Foundation
/// 定义基础域名
let TodayPoetryBaseURL = "https://v2.jinrishici.com/"

/// 定义返回的JSON数据字段
let RESULT_STATUS = "status"//网络状态文本
let RESULT_CODE = "code" //状态码

let RESULT_DATA = "data" //Json数据

let RESULT_MESSAGE = "message"  //错误消息提示
 
// MARK: - 数据状态值
let RESULT_SUCCESS_STATUS: String = "success"
let RESULT_SUCCESS_CODE: Int = 200

/*  错误情况的提示
 {
 "code": "0002",
 "status": "fail",
 "message": "手机号码不能为空"
 }
 **/
