//
//  ToastView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 07/02/2024.
//

import SwiftUI

// https://www.youtube.com/watch?v=ya9zDZJmaqo
/// Create modifier toaster
struct ToastModifier : ViewModifier {
  enum Kind {
    case success, failure
  }
  
  /// Variable that will keep track either the toast should show or not
  @Binding var isShowingToast : Bool
  let duration : TimeInterval
  let kind : Kind
  let message : String
  var completion : ()->Void = {}
  
  func body(content: Content) -> some View {
    /// content is something that we want to overlay
    ZStack {
      content
      
      if isShowingToast {
        toast
          .onAppear {
            /// Dismiss the toast after certain duration of time
            DispatchQueue.main.asyncAfter(
              deadline: .now() + duration
            ) {
              withAnimation {
                isShowingToast = false
                completion()
              }
            }
          }
      }
    }
  }
  
  private var systemImage : String {
    switch kind {
    case .success:
      return "checkmark.circle.fill"
    case .failure:
      return "xmark.circle.fill"
    }
  }
  
  private var toastColor : Color {
    switch kind {
    case .success:
      return .green
    case .failure:
      return .red
    }
  }
  
  private var toast : some View {
    VStack {
      HStack {
        Label(message, systemImage: systemImage)
          .fontWeight(.semibold)
          .font(.footnote)
          .foregroundStyle(.white)
        Spacer()
      }
      .frame(minWidth: 0, maxWidth: .infinity)
      .padding()
      .background(toastColor)
      .clipShape(.rect(cornerRadius: 10))
      .shadow(
        color: toastColor.opacity(0.3),
        radius: 24,
        x: 0,
        y: 8
      )
      
      Spacer()
    }
  }
}


private struct ToastViewExample: View {
  @State private var isShowingToast : Bool = false
  
  var body: some View {
    ZStack {
      Text("Create a Toast View")
        .onTapGesture {
          withAnimation(.snappy) {
            isShowingToast = true
          }
          
        }
    }
    .toast(isShowing: $isShowingToast, kind: .failure,message: "Post Saved Successfully")
  }
}

#Preview {
  ToastViewExample()
}
