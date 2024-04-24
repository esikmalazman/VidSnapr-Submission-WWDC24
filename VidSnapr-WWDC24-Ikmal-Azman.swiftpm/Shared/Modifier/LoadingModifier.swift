//
//  LoadingView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 16/02/2024.
//

import SwiftUI

struct LoadingModifier : ViewModifier {
  let message : String
  @Binding var isShowing : Bool
  
  func body(content: Content) -> some View {
    ZStack {
      content
      
      progressView
    }
  }
  
  var progressView : some View {
    ProgressView() {
      Text(message)
    }
    .padding()
    .background(.regularMaterial)
    .tint(.indigo)
    .foregroundColor(.indigo)
    .clipShape(.rect(cornerRadius: 10))
    .opacity(isShowing ? 1 : 0)
  }
}

private struct LoadingViewExample : View {
  var body: some View {
    VStack {
      Text("Hello")
        .progressView(isShowing: .constant(false), "Show Loading")
      
      Text("Test")
        .progressView(isShowing: .constant(true), "Show Loading")
    }
  }
}

#Preview {
  LoadingViewExample()
}

