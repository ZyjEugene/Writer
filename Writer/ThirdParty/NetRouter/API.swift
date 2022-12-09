//
//  API.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 3/30/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//  https://github.com/Moya/Moya/blob/master/docs_CN/Examples/Basic.md
//  APIServe.swift

import Foundation
import Moya

enum API {
    case register(email:String,password:String)
    /// 上传用户头像
    case uploadHeadImage(parameters: [String : Any],imageDate:Data)
    case todayPoetryToken
    case todayPoetrySentence
    case todayWeather
}

extension API: TargetType {
    /// 域名
    var baseURL: URL {
        switch self {case .todayPoetryToken, .todayPoetrySentence, .todayWeather:
            return URL.init(string:TodayPoetryBaseURL)!
        default:
            return URL.init(string:"")!
        }
    }
    
    /// 请求地址放到这里
    var path: String {
        switch self {
        case .register:
            return "register"
        case .uploadHeadImage(_, _):
            return "/file/user/upload.jhtml"
        case .todayPoetryToken:
            return "token"
        case .todayPoetrySentence:
            return "sentence"
        case .todayWeather:
            return "info"
        }
        
    }
    
    /// 接口的请求类型
    var method: Moya.Method {
        switch self {
        case .todayPoetryToken, .todayPoetrySentence, .todayWeather:
            return .get
        default:
            return .post
        }
    }
    
    /// 这个是做单元测试模拟的数据，必须要实现，只在单元测试文件中有作用
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    /// 请求任务事件,把参数之类的传进来
    var task: Task {
        var paramDict:[String:Any] = [:]
        switch self {
        case let .register(email, password):
            paramDict = ["email": email, "password": password]
        case .uploadHeadImage(let parameters, let imageDate):
            //  图片上传：name 和fileName 看后台怎么说，mineType根据文件类型上百度查对应的mineType
            let formData = MultipartFormData(provider: .data(imageDate), name: "file",
                                             fileName: "hangge.png", mimeType: "image/png")
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        case .todayPoetryToken, .todayPoetrySentence, .todayWeather:
            return .requestPlain// 不需要参数的网络请求任务返回".requestPlain"（GET请求）
        }
        // 后台可以接收json字符串做参数时选JSONEncoding.default（POST请求）
        // 后台的content-Type 为application/x-www-form-urlencoded时选择URLEncoding.default（GET请求）
        // https://github.com/Moya/Moya/issues/1533
        return .requestParameters(parameters: paramDict, encoding: encoding)
    }
    
    /// 同task，具体选择看后台要求：application/x-www-form-urlencoded 、application/json、X-User-Token
    var headers: [String : String]? {
        
        // 可以判断是否登录
        // if PreferenceUtil.isLogin() {
        //     // 获取token
        //     let session = PreferenceUtil.getSession()
        //     print("user session \(session)")
        //     // 将token设置到请求头
        //     headers["Authorization"] = session
        // }
        
        switch self {
        case .todayPoetrySentence, .todayWeather:
            return ["X-User-Token": PoetryToken]
        default:
            return ["Content-Type":"application/x-www-form-urlencoded"]
        }
    }
    
    /// 是否显示网络请求提示
    var isShowLoading: Bool {
        switch self {
        case .todayPoetryToken:
            return false
        default:
            return true
        }
    }
    
    /// 网络请求编码
    var encoding: ParameterEncoding {
        switch self.method {
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
        // 后台可以接收json字符串做参数时选JSONEncoding.default（POST请求）
        // 后台的content-Type为application/x-www-form-urlencoded时选择URLEncoding.default（GET请求）
        // https://github.com/Moya/Moya/issues/1533
    }
    
}
