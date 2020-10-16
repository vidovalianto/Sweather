//
//  Double + toFahrenheit.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/15/20.
//

import Foundation

extension Double {
    var toFahrenheit: Int {
        return Int((self - 273.15)*9/5 + 32)
    }
}
