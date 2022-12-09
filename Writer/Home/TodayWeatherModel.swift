//
//  TodayWeatherModel.swift
//  Writer
//
//  Created by 张艳金 on 2022/12/9.
//

import Foundation

class WeatherDataModel: BaseModel {
    var windDirection: String?
    var temperature: Int?
    var windPower: Int?
    var pm25: Int?
    var humidity: Int?
    var rainfall: Int?
    var updateTime: String?
    var weather: String?
    var visibility: String?
}

class TodayWeatherModel: BaseModel {
    var weatherData: WeatherDataModel?
    var ip: String?
    var region: String?
    var token: String?
    var tags: Array<String>?
    var beijingTime: String?
}
