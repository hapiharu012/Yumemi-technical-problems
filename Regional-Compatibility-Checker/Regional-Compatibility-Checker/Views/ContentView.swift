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
        Color("back").edgesIgnoringSafeArea(.all)
        
        VStack {
          
          TextField("", text: $userPrefectureViewModel.userData.name)
            .placeholder(when: userPrefectureViewModel.userData.name.isEmpty) {
                   Text("名前").font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(Color("button"))
           }
            .focused($isNameFocused)
            .padding()
            
            .background(userPrefectureViewModel.nameErrorMessage != nil ? Color("error") : Color("text")) // 背景を透明に設定
            .cornerRadius(9)
            .font(.system(size: 24, weight: .bold, design: .default))
            .onChange(of: isNameFocused) { isFocused in
                                      if !isFocused {
                                        userPrefectureViewModel.validateName()
                                      }
                                  }
            .padding(.bottom,30)
          HStack() {
            Text("誕生日").font(.system(size: 24, weight: .bold, design: .default))
              .foregroundColor(Color("button"))
            Spacer()
            Rectangle()
              .fill(userPrefectureViewModel.birthdayErrorMessage != nil ? Color("error") : Color("text"))
              .frame(width:105,height: 31)
              .overlay(
                DatePicker("", selection: $userPrefectureViewModel.selectedDate, displayedComponents: .date)
                  .environment(\.locale, Locale(identifier: "ja_JP"))
            )
            .padding(.leading, -8)
            .padding(.trailing, -5)
            .background(.clear)
            .cornerRadius(9)
          }
          .padding(.bottom,30)
          HStack() {
            Text("血液型").font(.system(size: 24, weight: .bold, design: .default))
              .foregroundColor(Color("button"))
            Picker("血液型", selection: $userPrefectureViewModel.userData.bloodType) {
              ForEach(bloodTypes, id: \.self) {
                Text($0)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(userPrefectureViewModel.bloodTypeErrorMessage != nil ? Color("error") : Color("text")) // 背景を透明に設定
            .cornerRadius(9)
          }
          .padding(.bottom,30)
          
          VStack(spacing: 10) {
                      if userPrefectureViewModel.nameErrorMessage != nil {
                        Text(userPrefectureViewModel.nameErrorMessage!)
                          .foregroundColor(Color("error"))
                          .font(.system(size: 15, weight:  .light, design: .default))
                      }
                      if userPrefectureViewModel.birthdayErrorMessage != nil {
                        Text(userPrefectureViewModel.birthdayErrorMessage!)
                          .foregroundColor(Color("error"))
                          .font(.system(size: 15, weight:  .light, design: .default))
                      }
                      if userPrefectureViewModel.bloodTypeErrorMessage != nil {
                        Text(userPrefectureViewModel.bloodTypeErrorMessage!)
                          .foregroundColor(Color("error"))
                          .font(.system(size: 15, weight:  .light, design: .default))
                      }
                    }
          .padding(.bottom,30)
          
          
          NavigationLink(destination: ResultView(userPrefectureViewModel: userPrefectureViewModel),
                         isActive: $userPrefectureViewModel.isResultViewPresented) {
                                  EmptyView()
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
              .background(Color("button"))
              .cornerRadius(9)
              .foregroundColor(.white)
          }
          
          
        }
        .padding()
      }
      .navigationTitle("都道府県占い")
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
