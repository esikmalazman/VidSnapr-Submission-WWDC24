//
//  Double + Extensions.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import Foundation

extension Double {
  /// Format double to minutes and second for media playback
  var toMinuteAndSecond : String {
    let minutes = Int(self) / 60
    let seconds = Int(self) % 60
    return String(format: "%02d:%02d", minutes,seconds)
  }
}
