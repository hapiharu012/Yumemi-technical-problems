//
//  ContentView.swift
//  Regional-Compatibility-Checker
//
//  Created by k21123kk on 2024/01/04.
//
import SwiftUI



struct ContentView: View {
  @FocusState private var isNameFocused: Bool
  @FocusState private var isBirthFocused: Bool
  // 端末の環境設定を取得
  @Environment(\.colorScheme) var colorScheme
  let bloodTypes = ["a", "b", "o", "ab"]
  
  @StateObject var userPrefectureViewModel: UserPrefectureViewModel = UserPrefectureViewModel()
  var body: some View {
    NavigationView {
      ZStack {
        Color.yellow.edgesIgnoringSafeArea(.all)
        
        VStack(spacing: 30) {
          
          TextField("", text: $userPrefectureViewModel.userData.name)
            .placeholder(when: userPrefectureViewModel.userData.name.isEmpty) {
                   Text("名前").font(.system(size: 24, weight: .bold, design: .default))
           }
            .focused($isNameFocused)
            .padding()
            
            .background(Color.white) // 背景を透明に設定
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
            .onChange(of: isNameFocused) { isFocused in
                                      if !isFocused {
                                        userPrefectureViewModel.validateName()
                                      }
                                  }
            
          HStack() {
            Text("誕生日").font(.system(size: 24, weight: .bold, design: .default))
            Spacer()
            Rectangle()
              .fill(.white)
              .frame(width:120,height: 34)
              .overlay(
                DatePicker("", selection: $userPrefectureViewModel.selectedDate, displayedComponents: .date)
                  .border(userPrefectureViewModel.birthdayErrorMessage != nil ? Color.red : Color.clear)
            )
            .padding(.leading, -8)
            .padding(.trailing, -5)
            .background(.clear)
            .cornerRadius(9)
//            .frame(width: 10,alignment: .leading)
            
//            DatePicker("", selection: $userPrefectureViewModel.selectedDate, displayedComponents: .date)
//              .border(userPrefectureViewModel.birthdayErrorMessage != nil ? Color.red : Color.clear)
//              .background(Color.white) // 背景を透明に設定
//              .cornerRadius(9)
          }
          
          HStack() {
            Text("血液型").font(.system(size: 24, weight: .bold, design: .default))
            Picker("血液型", selection: $userPrefectureViewModel.userData.bloodType) {
              ForEach(bloodTypes, id: \.self) {
                Text($0)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
            .border(userPrefectureViewModel.bloodTypeErrorMessage != nil ? Color.red : Color.clear)
            .background(Color.white) // 背景を透明に設定
            .cornerRadius(9)
          }
          
          Button(action: {
            if userPrefectureViewModel.validateAllFields() {
              userPrefectureViewModel.isResultViewPresented = true
              userPrefectureViewModel.fetchPrefectureData()
            }
          }){
            Text("占う")
              .font(.system(size: 24, weight: .bold, design: .default))
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(.black)
              .cornerRadius(9)
              .foregroundColor(colorScheme == .dark ? .black : .white)
          } //: SAVE BUTTON
          
        }
        .padding()
      }
      .navigationTitle("NavigationView")
    }
  }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
//struct ContentView: View {
//  @FocusState private var isNameFocused: Bool
//  @FocusState private var isBirthFocused: Bool
//  let bloodTypes = ["a", "b", "o", "ab"]
//
//  @StateObject var userPrefectureViewModel: UserPrefectureViewModel = UserPrefectureViewModel()
//
//  var body: some View {
//    ZStack {
//      Color.yellow.edgesIgnoringSafeArea(.all) // 背景を黄色に設定
//
//      NavigationView {
//        VStack {
//          TextField("名前", text: $userPrefectureViewModel.userData.name)
//            .focused($isNameFocused)
//            .padding()
//            .background(Color.clear) // 背景を透明に設定
//            .cornerRadius(9)
//            .font(.system(size: 24, weight: .bold, design: .default))
//
//          DatePicker("誕生日", selection: $userPrefectureViewModel.selectedDate, displayedComponents: .date)
//            .border(userPrefectureViewModel.birthdayErrorMessage != nil ? Color.red : Color.clear)
//            .background(Color.clear) // 背景を透明に設定
//
//          Picker("血液型", selection: $userPrefectureViewModel.userData.bloodType) {
//            ForEach(bloodTypes, id: \.self) {
//              Text($0)
//            }
//          }
//          .pickerStyle(SegmentedPickerStyle())
//          .border(userPrefectureViewModel.bloodTypeErrorMessage != nil ? Color.red : Color.clear)
//          .background(Color.clear) // 背景を透明に設定
//
//          Button("占いを行う") {
//            if userPrefectureViewModel.validateAllFields() {
//              userPrefectureViewModel.isResultViewPresented = true
//              userPrefectureViewModel.fetchPrefectureData()
//            }
//          }
//        }
//        .navigationTitle("占いフォーム")
//        .background(Color.clear) // 背景を透明に設定
//      }
//      .navigationViewStyle(StackNavigationViewStyle()) // ナビゲーションビュースタイルの設定
//    }
//  }
//}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
