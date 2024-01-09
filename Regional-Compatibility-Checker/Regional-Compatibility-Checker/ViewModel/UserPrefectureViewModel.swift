//
//  UserPrefectureViewModel.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/07.
//

import Foundation
import UIKit

class UserPrefectureViewModel: ObservableObject {
  @Published var userData: UserData // ユーザー情報
  @Published var prefectureData: PrefectureData? { // APIのレスポンスデータ
    didSet { // prefectureDataが更新されたら、ロゴ（イラスト）をダウンロードする
      if let logoUrl = prefectureData?.logoUrl {
        downloadPrefectureImage(from: logoUrl)
      }
    }
  }
  @Published var selectedDate: Date = Date() {  // DatePickerで使うユーザーの生年月日
    didSet {
      userData.birthday = convertDateToYearMonthDay(date: selectedDate)
      validateBirthday()
    }
  }
  
  @Published var isLoading: Bool = false // APIリクエスト中かどうか
  @Published var isAlertPresented: Bool = false // アラートを表示するかどうか
  @Published var isResultViewPresented: Bool = false
  @Published var errorMessage: String? // エラーメッセージ
  @Published var nameErrorMessage: String? // 名前のエラーメッセージ
  @Published var birthdayErrorMessage: String? // 誕生日のエラーメッセージ
  @Published var bloodTypeErrorMessage: String? // 血液型のエラーメッセージ
  
  @Published var downloadedImage: UIImage? // logoUrlカラ取得してきた県のロゴ（イラスト）
  
  
  private var apiService: APIService
  private var imageDownloadService = ImageDownloadService()
  
  init(apiService: APIService = APIService()) {
    self.apiService = apiService
    self.userData = UserData(name: "", birthday: YearMonthDay(year: 0, month: 1, day: 1), bloodType: "", today: YearMonthDay(year: 0, month: 0, day: 0))
  }
  
  enum ImageDownloadError: Error {
    case invalidURL
    case imageDataError
    case unknown
  }
  
  
  // Date型をYearMonthDay型に変換するメソッド
  // MARK: - convertDateToYearMonthDay()
  func convertDateToYearMonthDay(date: Date) -> YearMonthDay {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    
    return YearMonthDay(year: year, month: month, day: day)
  }
  
  
  // APIリクエストを実装し、結果をハンドリングするメソッド
  // MARK: - fetchPrefectureData()
  func fetchPrefectureData() {
    self.isLoading = true
    self.errorMessage = nil
    
    // 現在時刻を取得
    let now = Date()
    let calendar = Calendar(identifier: .gregorian)
    let year = calendar.component(.year, from: now)
    let month = calendar.component(.month, from: now)
    let day = calendar.component(.day, from: now)
    
    self.userData.today = YearMonthDay(year: year, month: month, day: day)  // ユーザー情報(today)に現在時刻をセット
    
    apiService.postUserData(userData: self.userData) { [weak self] result in  // [weak self]を使って循環参照を防ぐ
      
      DispatchQueue.main.async {  //メインスレッドで実行
        self?.isLoading = false
        switch result {
        case .success(let data):
          self?.prefectureData = data
        case .failure(let error):
          self?.handleError(error)
        }
      }
    }
  } // -> fetchPrefectureData()
  
  
  // URLSessionに関わるエラーをハンドリングするメソッド
  // MARK: - handleError()
  private func handleError(_ error: Error) {
    // URLErrorのハンドリング
    if let urlError = error as? URLError {
      switch urlError.code {
      case .notConnectedToInternet:
        self.errorMessage = "インターネット接続がありません。"
      default:
        self.errorMessage = "ネットワークエラーが発生しました。"
      }
    }
    // カスタムエラーのハンドリング
    else if let downloadError = error as? ImageDownloadError {
      switch downloadError {
      case .invalidURL:
        self.errorMessage = "無効なURLです。"
      case .imageDataError:
        self.errorMessage = "画像データに問題があります。"
      case .unknown:
        self.errorMessage = "エラーが発生しました。"
      }
    }
    // その他のエラーのハンドリング
    else {
      self.errorMessage = "データの取得に失敗しました。"
    }
    self.isAlertPresented = true
  }  // -> handleError()
  
  
  // ユーザー名のバリデーションを行うメソッド
  // MARK: - validateName()
  func validateName() {
    if userData.name.isEmpty {
      nameErrorMessage = "名前を入力してください。"
    } else {
      nameErrorMessage = nil
    }
    
    return
  }
  
  
  // 誕生日のバリデーションを行うメソッド
  // MARK: - validateBirthday()
  func validateBirthday() {
    self.birthdayErrorMessage = nil
    
    let calendar = Calendar(identifier: .gregorian)
    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.year = userData.birthday.year
    dateComponents.month = userData.birthday.month
    dateComponents.day = userData.birthday.day
    // 誕生日が未入力の場合のチェック
    if userData.birthday.year == 0 || userData.birthday.month == 0 || userData.birthday.day == 0 {
      self.birthdayErrorMessage = "誕生日を入力してください。"
      return
    }
    // 日付の形式が正しいかどうかのチェック
    guard let birthdayDate = calendar.date(from: dateComponents) else {
      self.birthdayErrorMessage = "無効な日付です。"
      return
    }
    // 誕生日が未来の日付でないかのチェック
    if birthdayDate > currentDate {
      self.birthdayErrorMessage = "誕生日が未来の日付です。"
      return
    }
  }  // -> validateBirthday()
  
  
  // 血液型のバリデーションを行うメソッド
  // MARK: - validateBloodType()
  func validateBloodType() {
    if userData.bloodType.isEmpty {
      bloodTypeErrorMessage = "血液型を入力してください。"
    } else if !["a", "b", "o", "ab"].contains(userData.bloodType) {  // 入力された血液型がA, B, O, ABのいずれかでない場合
      bloodTypeErrorMessage = "A, B, O, ABのいずれかを入力してください。"
    }
    else {
      bloodTypeErrorMessage = nil
    }
    
    return
  }
  
  
  // 全てのユーザー情報のバリデーションを行うメソッド
  // MARK: - validateAllFields()
  func validateAllFields() -> Bool {
    validateName()
    validateBirthday()
    validateBloodType()
    return nameErrorMessage == nil && birthdayErrorMessage == nil && bloodTypeErrorMessage == nil  // エラーメッセージが全てnilであればtrueを返す
  }
  
  
  // prefectureDataのlogoUrlの県のイラストをダウンロードする
  // MARK: - downloadPrefectureImage()
  func downloadPrefectureImage(from urlString: String) {
    imageDownloadService.downloadImage(from: urlString) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let image):
          self?.downloadedImage = image
        case .failure(let error):
          self?.handleError(error)
        }
      }
    }
  }
  
}  // -> UserDataViewModel class
