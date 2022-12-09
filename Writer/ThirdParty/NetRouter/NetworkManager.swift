//
//  NetworkManager.swift
//  GHMoyaNetWorkTest
//
//  Created by Guanghui Liao on 4/2/18.
//  Copyright © 2018 liaoworking. All rights reserved.
//  NetworkProvider.swift

import Foundation
import Alamofire
import Moya
import SwiftyJSON
import HandyJSON

// MARK: - 定义网络回调和返回参数的对象
/// 超时时长
private var requestTimeOut: Double = 30
/// 单个模型的成功回调 包括： 模型，网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestModelSuccessCallback<T:HandyJSON> = ((T,ResponseModel) -> Void)

// 数组模型的成功回调 包括： 模型数组， 网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestModelsSuccessCallback<T:HandyJSON> = (([T],ResponseModel) -> Void)

// 网络请求的回调 包括：网络请求的模型(code,message,data等，具体根据业务来定)
typealias RequestCallback = ((ResponseModel) -> Void)
/// 网络错误的回调
typealias errorCallback = (() -> Void)

// MARK: - 网络请求的基本设置（Private）
/// 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    /// 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    var task = target.task
    
    /*
     如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
     👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
     */
    // let additionalParameters = ["token":"888888"]
    // let defaultEncoding = URLEncoding.default
    // switch target.task {
    //     ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    // case .requestPlain:
    //     task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    // case .requestParameters(var parameters, let encoding):
    //     additionalParameters.forEach { parameters[$0.key] = $0.value }
    //     task = .requestParameters(parameters: parameters, encoding: encoding)
    // default:
    //     break
    // }
    /*
     👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
     如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     */
    
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = 30 // 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    // 针对于某个具体的业务模块来做接口配置
    if let apiTarget = target as? MultiTarget,
       let target = apiTarget.target as? API {
        switch target {
        case .register:
            requestTimeOut = 5
            return endpoint
        case .todayPoetryToken:
            requestTimeOut = 20
            return endpoint
        default:
            return endpoint
        }
    }
    
    return endpoint
}

/// 网络请求的设置
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 打印请求参数
        if let requestData = request.httpBody {
            print("请求的url：\(request.url!)" + "\n" + "\(request.httpMethod ?? "")" + "发送参数" + "\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")")
        } else {
            print("请求的url：\(request.url!)" + "\(String(describing: request.httpMethod))")
        }
        
        if let header = request.allHTTPHeaderFields {
            print("请求头内容\(header)")
        }
        
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Session看实际需求。HTTPS就要手动实现Session了
// private func defaultAlamofireSession() -> Session {
//
////     let configuration = Alamofire.Session.default
//
//     let configuration = URLSessionConfiguration.default
//     configuration.headers = .default
//
//     let policies: [String: ServerTrustEvaluating] = ["demo.mXXme.com": DisabledTrustEvaluator()]
//
//     let session = Session(configuration: configuration,
//                           startRequestsImmediately: false,
//                           serverTrustManager: ServerTrustManager(evaluators: policies))
//
//    return session
// }

/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
private let networkPlugin = NetworkActivityPlugin.init { change, target in
    print("调用networkPlugin状态: \(change)")
    // targetType 是当前请求的基本信息
    switch change {
    case .began:
        print("开始请求网络")
        if let apiTarget = apiTarget(from: target), apiTarget.isShowLoading {
            print("-- Show Loading --")
        }
    case .ended:
        print("结束")
        if let apiTarget = apiTarget(from: target), apiTarget.isShowLoading  {
                print("-- Hide Loading --")
        }
    }
}
 
/// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
/// 网络请求发送的核心初始化方法，创建网络请求对象
fileprivate let Provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)

// MARK: - 网络请求
/// 返回数据模型的网络请求
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - modelType: 模型
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult // 当我们需要主动取消网络请求的时候，可以用返回值Cancellable，一般不用的话做忽略处理
func NetWorkRequest<T: HandyJSON>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: T.Type, successCallback:@escaping RequestModelSuccessCallback<T>, failureCallback: RequestCallback? = nil) -> Cancellable? {
    return NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: { (responseModel) in
        switch responseModel.jsonType {
        case .dictionary:
            let modelObject = JsonUtil.jsonToModel(responseModel.dataString, modelType)
            successCallback(modelObject as! T,responseModel)
        case .array:
            let modelObject = JsonUtil.jsonArrayToModel(responseModel.dataString, modelType)
            successCallback(modelObject as! T,responseModel)
        default:
            errorHandler(code: responseModel.code , message: "解析失败", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }, failureCallback: failureCallback)
}
 
/// 网络请求的基础方法
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true, successCallback:@escaping RequestCallback, failureCallback: RequestCallback? = nil) -> Cancellable? {
    NetWorkRequest(target, needShowFailAlert: needShowFailAlert, needCache: false, cacheID: "", successCallback: successCallback, failureCallback: failureCallback)
}

/// 网络请求的基础方法（允许缓存的网络请求方法）
/// - Parameters:
///   - target: 接口
///   - showFailAlert: 是否显示网络请求失败的弹框
///   - needCache 是否需要缓存，默认false
///   - needCache 缓存参数
///   - successCallback: 成功的回调
///   - failureCallback: 失败的回调
/// - Returns: 取消当前网络请求Cancellable实例
@discardableResult
func NetWorkRequest(_ target: TargetType,
                    needShowFailAlert: Bool = true,
                    needCache: Bool = false,
                    cacheID: String = "",
                    successCallback:@escaping RequestCallback,
                    failureCallback: RequestCallback? = nil) -> Cancellable? {
    
    // 先判断网络是否有链接 没有的话直接返回
    if !UIDevice.isNetworkConnect {
        // code = 9999 代表无网络  这里根据具体业务来自定义
        errorHandler(code: 9999, message: "网络似乎出现了问题", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        return nil
    }
    
    // 缓存代码 设置缓存路径
    var disPath: String = ""
    if needCache {
        let cachePaths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesDir = cachePaths[0]
        let mutableSting = target.baseURL.absoluteString + target.path + (cacheID as String)
        let lastStr = mutableSting.replacingOccurrences(of: "/", with: "-")
        disPath = cachesDir + "/" + lastStr + "-.text"
        if needCache == true {
            DispatchQueue.global().async {
                do { /// 获取json字符串
                    let str = try String.init(contentsOfFile: disPath, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async { /// 字符串转化为data
                        let data = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
                        let jsonData = try! JSON(data: data!)
                        print("返回缓存数据的结果是：\(jsonData)")
                        let respModel = ResponseModel()
                        respModel.code = jsonData[RESULT_CODE].int ?? -999
                        respModel.status = jsonData[RESULT_STATUS].string ?? "fail"
                        respModel.message = jsonData[RESULT_MESSAGE].stringValue
                        respModel.jsonType = jsonData[RESULT_DATA].type
                        successCallback(respModel)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // 开启网络请求
    return Provider.request(MultiTarget(target)) { result in
        switch result {
        case let .success(response):
            do {
                // Data 转 Json
                let jsonData = try JSON(data: response.data)
                print("返回结果是：\(jsonData)")
                // 缓存
                if needCache == true && !cacheID.isEmpty {
                    let jsonStr = String(data: response.data, encoding: String.Encoding.utf8) ?? ""
                    DispatchQueue.global().async {
                        do {
                            try jsonStr.write(toFile: disPath, atomically: true, encoding: String.Encoding.utf8)
                        } catch {
                            print(error)
                        }
                    }
                }
                // 数据验证
                if !validateRepsonse(response: jsonData.dictionary, needShowFailAlert: needShowFailAlert, failure: failureCallback) { return }
                // 生成响应数据模型
                let respModel = ResponseModel()
                // 这里的 -999的code码以及"fail"的状态码 需要根据具体业务来设置
                respModel.code = jsonData[RESULT_CODE].int ?? -999
                respModel.status = jsonData[RESULT_STATUS].string ?? "fail"
                respModel.message = jsonData[RESULT_MESSAGE].stringValue
                respModel.jsonType = jsonData[RESULT_DATA].type
                if respModel.code == RESULT_SUCCESS_CODE ||
                    respModel.status == RESULT_SUCCESS_STATUS {
                    respModel.dataString = jsonData[RESULT_DATA].rawString() ?? ""
                    successCallback(respModel)
                } else {
                    errorHandler(code: respModel.code , message: respModel.message , needShowFailAlert: needShowFailAlert, failure: failureCallback)
                    return
                }
                
            } catch {
                // code = 1000000 代表JSON解析失败  这里根据具体业务来自定义
                errorHandler(code: 1000000, message: String(data: response.data, encoding: String.Encoding.utf8)!, needShowFailAlert: needShowFailAlert, failure: failureCallback)
            }
        case let .failure(error as NSError):
            errorHandler(code: error.code, message: "网络连接失败", needShowFailAlert: needShowFailAlert, failure: failureCallback)
        }
    }
}

// MARK: - 网络数据处理方法
/// 预判断后台返回的数据有效性 如通过Code码来确定数据完整性等  根据具体的业务情况来判断  有需要自己可以打开注释
/// - Parameters:
///   - response: 后台返回的数据
///   - showFailAlet: 是否显示失败的弹框
///   - failure: 失败的回调
/// - Returns: 数据是否有效
private func validateRepsonse(response: [String: JSON]?, needShowFailAlert: Bool, failure: RequestCallback?) -> Bool {
    /**
     var errorMessage: String = ""
     if response != nil {
     if !response!.keys.contains(codeKey) {
     errorMessage = "返回值不匹配：缺少状态码"
     } else if response![codeKey]!.int == 500 {
     errorMessage = "服务器开小差了"
     }
     } else {
     errorMessage = "服务器数据开小差了"
     }
     
     if errorMessage.count > 0 {
     var code: Int = 999
     if let codeNum = response?[codeKey]?.int {
     code = codeNum
     }
     if let msg = response?[messageKey]?.stringValue {
     errorMessage = msg
     }
     errorHandler(code: code, message: errorMessage, showFailAlet: showFailAlet, failure: failure)
     return false
     }
     */
    
    return true
}

/// 错误处理
/// - Parameters:
///   - code: code码
///   - message: 错误消息
///   - needShowFailAlert: 是否显示网络请求失败的弹框
///   - failure: 网络请求失败的回调
private func errorHandler(code: Int, message: String, needShowFailAlert: Bool, failure: RequestCallback?) {
    print("发生错误：\(code)--\(message)")
    let model = ResponseModel()
    model.code = code
    model.message = message
    if needShowFailAlert {
        // 弹框
        print("弹出错误信息弹框\(message)")
    }
    failure?(model)
}

private func judgeCondition(_ flag: String?) {
    switch flag {
    case "401", "402": break // token失效
    default:
        return
    }
}

/// 获取当前使用的API(TargetType)管理对象，返回对象可为空
private func apiTarget(from target: TargetType) -> API? {
    if let apiTarget = target as? MultiTarget,
       let target = apiTarget.target as? API {
        return target
    }
    return nil
}

// MARK: - Swift5.5 Concurrency的支持
/**
 下面的三个方法是对于 Swift5.5 Concurrency的支持  目前(2022.02.18)一般项目中还用不到。 可自行删除
 */
@available(iOS 13.0, *)
@discardableResult
///  Swift5.5 Concurrency的支持
func NetWorkRequest<T: HandyJSON>(_ target: TargetType, needShowFailAlert: Bool = true, modelType: T.Type) async -> (model:T?,response: ResponseModel) {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, modelType: modelType) { model, responseModel in
            continuation.resume(returning: (model,responseModel))
        } failureCallback: { responseModel in
            continuation.resume(returning: (nil,responseModel))
        }
    })
}

@available(iOS 13.0, *)
@discardableResult
///  Swift5.5 Concurrency的支持
func NetWorkRequest(_ target: TargetType, needShowFailAlert: Bool = true) async -> ResponseModel {
    await withCheckedContinuation({ continuation in
        NetWorkRequest(target, needShowFailAlert: needShowFailAlert, successCallback: {(responseModel) in
            continuation.resume(returning: responseModel)
        }, failureCallback:{(responseModel) in
            continuation.resume(returning: responseModel)
        })
    })
}

// MARK: - 网络数据基础模型、以及设备网络拓展
class ResponseModel: BaseModel {
    /// 状态码
    var code: Int = -999
    /// 状态码（和code一样的功能，只是服务器接口返回的数据不同，用来判断网络请求结果的状态）
    var status: String = "fail"
    /// 网络返回的信息
    var message: String = ""
    /// 这里的data用String类型 保存response.data
    var dataString: String = ""
    /// 分页的游标 根据具体的业务选择是否添加这个属性
    var cursor: String = ""
    
    /// 判断返回的json数据是：json字典、json数组 or 其他
    var jsonType: Type = .null
}

/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用计算型属性是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
extension UIDevice {
    static var isNetworkConnect: Bool {
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true // 无返回就默认网络已连接
    }
}
