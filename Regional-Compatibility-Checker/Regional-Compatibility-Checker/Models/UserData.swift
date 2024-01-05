//
//  User.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/05.
//

import Foundation

// 送信時の年月日を表す構造体
struct YearMonthDay: Codable {
    var year: Int
    var month: Int
    var day: Int
}

// ユーザー情報を表す構造体
struct UserData: Codable {
  var name: String
  var birthday: YearMonthDay
  var bloodType: String
  var today: YearMonthDay
}
