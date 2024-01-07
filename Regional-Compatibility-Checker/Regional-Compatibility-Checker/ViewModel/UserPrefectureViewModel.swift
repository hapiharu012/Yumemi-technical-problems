//
//  UserPrefectureViewModel.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/07.
//

import Foundation

class UserPrefectureViewModel: ObservableObject {
  @Published var userData: UserData
  @Published var prefectureData: PrefectureData?
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?
  
  private var apiService: APIService
  
  init(apiService: APIService = APIService()) {
    self.apiService = apiService
    self.userData = UserData(name: "", birthday: YearMonthDay(year: 0, month: 1, day: 1), bloodType: "", today: YearMonthDay(year: 0, month: 0, day: 0))
  }
  
  // MARK: - fetchPrefectureData()
  // APIリクエストを実装し、結果をハンドリングするメソッド
  func fetchPrefectureData() {
    guard validateUserData(userData: self.userData) else {
      self.errorMessage = "入力内容を確認してください。"
      return
    }
    self.isLoading = true
    self.errorMessage = nil
    
    // 現在時刻を取得
    let now = Date()
    let calendar = Calendar(identifier: .gregorian)
    let year = calendar.component(.year, from: now)
    let month = calendar.component(.month, from: now)
    let day = calendar.component(.day, from: now)
    
    self.userData.today = YearMonthDay(year: year, month: month, day: day)
    apiService.postUserData(userData: self.userData) { [weak self] result in  // [weak self]を使って循環参照を防ぐ
      DispatchQueue.main.async {
        self?.isLoading = false
        switch result {
        case .success(let data):
          self?.prefectureData = data
        case .failure(let error):
          self?.errorMessage = error.localizedDescription
        }
      }
    }
  }
  
  // ユーザー情報のバリデーションチェック
  // MARK: - validateUserData()
  func validateUserData(userData: UserData) -> Bool {
    if userData.name.isEmpty {
      self.errorMessage = "名前を入力してください"
      return false
    }
    
    if userData.birthday.year == 0 || userData.birthday.month == 0 || userData.birthday.day == 0 {
      self.errorMessage = "生年月日を入力してください"
      return false
    }
    
    if userData.bloodType.isEmpty {
      self.errorMessage = "血液型を入力してください"
      return false
    }
    
    return true
  }
  
  // prefectureDataをビューから使いやすいように必要なデータ形式に変換
  // MARK: - getPrefectureData()
  func getPrefectureData() -> PrefectureData? {
    guard let prefectureData = self.prefectureData else { return nil }
    
    return prefectureData
  }
  
  
}
