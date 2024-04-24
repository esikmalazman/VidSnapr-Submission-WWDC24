//
//  URL + Extensions.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 09/02/2024.
//

import Foundation

extension URL {
  static var sampleVideoURL : URL {
    Bundle.main.url(forResource: "sony", withExtension: "mp4")!
  }
}
