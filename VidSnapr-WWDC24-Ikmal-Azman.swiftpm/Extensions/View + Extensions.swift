//
//  View + Extensions.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import SwiftUI

extension View {
  /// View extension to display Toast so it can be access through View
  func toast(
    isShowing: Binding<Bool>,
    duration : TimeInterval = 3,
    kind : ToastModifier.Kind = .success,
    message : String, completion : @escaping ()->Void = {}
  ) -> some View {
    /// Return toast modifier to be apply for the View
    modifier(
      ToastModifier(
        isShowingToast: isShowing,
        duration: duration,
        kind: kind,
        message: message,
        completion: completion
      )
    )
  }
  
  /// View extension to display progress view  so it can be access through View
  func progressView(isShowing : Binding<Bool>,_ message : String) -> some View {
    modifier(LoadingModifier(message: message, isShowing: isShowing))
  }
}
