//
//  APIService.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/06.
//

import Foundation

// API通信を担当するクラス
class APIService {
  // 1. APIのエンドポイントURL
  private let url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune")
  
  // POSTリクエストを実行し、結果を返す
  func postUserData(userData: UserData, completion: @escaping (Result<PrefectureData, Error>) -> Void) {
    guard let url = url else {
      completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
      return
    }
    // 2. URLRequestの作成
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      // 3. 必要なパラメータの付与
      request.httpBody = try JSONEncoder().encode(userData)
      if let httpBody = String(data: try JSONEncoder().encode(userData), encoding: .utf8) {
           print("送信データ: \(httpBody)")
       }
    } catch {
      completion(.failure(error))
      print("エラーが発生しました.in 'request.httpBody = try JSONEncoder().encode(userData)'")
      return
    }
    
    // 4. 通信の実行
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//      print("response:\(response)")
      
      // レスポンスで受け取ったdata, response, errorを元に処理を行う
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        print("エラーが発生しました.in 'guard let data = data else'")
        return
      }
      
      do {
        if let dataString = String(data: data, encoding: .utf8) {
             print("受信データ: \(dataString)")
         }
        let prefectureData = try JSONDecoder().decode(PrefectureData.self, from: data)
        completion(.success(prefectureData))
      } catch {
        completion(.failure(error))
        print("エラーが発生しました.in 'let prefectureData = try JSONDecoder().decode(PrefectureData.self, from: data)'")
      }
    }
    
    task.resume()
  }
}

