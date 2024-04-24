//
//  ThumbnailPreview.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 06/02/2024.
//

import SwiftUI

struct ThumbnailPreview : View {
  let thumbnail : Thumbnail
  var action : () -> () = {}
  
  var body: some View {
    Image(uiImage: thumbnail.originalImage)
      .resizable()
      .scaledToFill()
      .frame(maxWidth: 100, maxHeight: 100)
      .cornerRadius(10)
    /// Assign ID to view to scroll to let reader know, which view to scroll to
      .id(thumbnail.id)
      .onTapGesture {
        withAnimation(.snappy) {
          action()
        }
      }
  }
}


#Preview {
    ThumbnailPreview(thumbnail: .init(originalImage: UIImage(systemName: "photo")!))
}
