//
//  PrefectureData.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/05.
//

import Foundation

// 県民の日を表す構造体
struct MonthDay: Codable {
    var month: Int
    var date: Int
}

// 都道府県のAPIレスポンスを表す構造体
struct PrefectureData: Codable {
  var name: String
  var capital: String
  var citizenDay: MonthDay?
  var hasCoastLine: Bool
  var logoUrl: String
  var brief: String
}
