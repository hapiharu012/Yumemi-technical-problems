//
//  ContentView.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/04.
//

import SwiftUI

struct ContentView: View {
  @State var result:PrefectureData = PrefectureData(name: "-", capital: "", hasCoastLine: false, logoUrl: "", brief: "")
  let apiService = APIService()
  let birthday = YearMonthDay(year: 2000, month: 1, day: 27)
  let today = YearMonthDay(year: 2023, month: 5, day: 5)
//  let userData = UserData(name: "ゆめみん", birthday: birthday, bloodType: "AB", today: today)

    var body: some View {
      Button(action: {
        apiService.postUserData(userData: UserData(name: "晴登", birthday: self.birthday, bloodType: "a", today: self.today)
        ) { result in
          switch result {
          case .success(let prefectureData):
            print(prefectureData)
            self.result = prefectureData
            print("通信が成功しました")
          case .failure(let error):
            print(error)
            print("エラーが発生しました")
          }
        }
        print("ボタンが押されました")
      }) {
        Text("占い")
      }
      Text(result.name)
    }
}

#Preview {
    ContentView()
}
