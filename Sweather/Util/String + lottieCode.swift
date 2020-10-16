//
//  IconToLottie.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/15/20.
//

import Foundation

fileprivate let lottieDict = [
    "11d" : "storm",
    "09d" : "partlyshower",
    "10d" : "partlyshower",
    "13d" : "snow",
    "50d" : "mist",
    "01d" : "sunny",
    "01n" : "night",
    "02d" : "partlycloudy",
    "02n" : "cloudynight",
    "04d" : "partlycloudy",
    "04n" : "cloudynight",
]


extension String {
    var lottieCode: String {
        return lottieDict[self] ?? "error"
    }
}
