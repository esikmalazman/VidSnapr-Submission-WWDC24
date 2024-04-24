//
//  Thumbnail.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 06/02/2024.
//

import Foundation
import UIKit.UIImage

struct Thumbnail : Identifiable, Hashable {
  let id = UUID()
  var originalImage : UIImage
  var isUpscaled : Bool = false
}

extension Array<Thumbnail> {
  static var samples : [Thumbnail] = [
    Thumbnail(originalImage: UIImage(named:"mockImage1")!),
    Thumbnail(originalImage: UIImage(named:"mockImage2")!, isUpscaled: true),
    Thumbnail(originalImage: UIImage(named:"mockImage3")!),
    Thumbnail(originalImage: UIImage(named:"mockImage1")!),
    Thumbnail(originalImage: UIImage(named:"mockImage1")!),
  ]
}
