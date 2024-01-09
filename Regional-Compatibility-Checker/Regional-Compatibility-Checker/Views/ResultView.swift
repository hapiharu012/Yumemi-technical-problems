//
//  ResultView.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/09.
//

import SwiftUI

struct ResultView: View {
  @ObservedObject var  userPrefectureViewModel: UserPrefectureViewModel
  
  var body: some View {
    // ResultViewの内容
    
    ZStack {
      Color("back").edgesIgnoringSafeArea(.all)
      ScrollView {
        VStack(spacing: 20) {
          Text("占い結果")
            .font(.largeTitle)
            .foregroundColor(Color("text"))
            .bold()
          if let image = userPrefectureViewModel.downloadedImage {
            Image(uiImage: image)
              .resizable()
              .scaledToFit()
              .frame(width: 200, height: 200)
          } else {
            // 画像がない場合はプレースホルダーを表示
            Image(systemName: "photo")
              .resizable()
              .scaledToFit()
              .frame(width: 200, height: 200)
              .foregroundColor(.gray)
          }
          if let data = userPrefectureViewModel.prefectureData {
            VStack(alignment: .leading, spacing: 10) {
              Text("都道府県: \(data.name)")
              Text("県庁所在地: \(data.capital)")
              if let citizenDay = data.citizenDay {
                Text("県民の日: \(citizenDay.month)月\(citizenDay.date)日")
              }
              Text("海沿い: \(data.formattedHasCoastLine)")
              Text("詳細: \(data.brief)")
            }
            .foregroundColor(Color("text"))
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
          } else {
            Text("結果がありません")
              .foregroundColor(.gray)
          }
        }
        .padding()
      }
    }
  }
  
}
