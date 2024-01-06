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
  
  // CoodingKeysを使って、JSONのキーと構造体のプロパティ名を紐付ける
  enum CodingKeys: String, CodingKey {
          case name
          case capital
          case citizenDay = "citizen_day"
          case hasCoastLine = "has_coast_line"
          case logoUrl = "logo_url"
          case brief
      }
}
