//
//  ResultView.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/09.
//

import SwiftUI

struct ResultView: View {
  var userPrefectureViewModel: UserPrefectureViewModel?

      var body: some View {
          // ResultViewの内容
        Text(userPrefectureViewModel?.prefectureData?.name ?? "結果はここに表示されます")
//        Text(userPrefectureViewModel?.downloadedImage ?? "結果はここに表示されます")
        Text(userPrefectureViewModel?.prefectureData?.brief ?? "結果はここに表示されます")
      }
}

#Preview {
    ResultView()
}
