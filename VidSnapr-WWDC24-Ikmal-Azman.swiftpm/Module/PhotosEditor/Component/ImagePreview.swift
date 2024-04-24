//
//  ImagePreview.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 16/02/2024.
//

import SwiftUI

struct ImagePreview: View {
  @Binding var selectedThumbnail : Thumbnail?
  var body: some View {
    Group {
      // Unwrapping Binding<UIImage?> to Binding<UIImage> type
      // https://stackoverflow.com/a/69681693/12528747
      if let selectedThumbnail = selectedThumbnail {
        PhotoView(
          image: Binding(
            get: {selectedThumbnail.originalImage},
            set: { newValue in
                self.selectedThumbnail?.originalImage = newValue ?? UIImage(systemName: "photo")!
            }
          ),
          height: .infinity,
          width:.infinity
        )
      } else {
        Text("No images available")
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
}

#Preview {
  ImagePreview(selectedThumbnail: .constant(.none))
}
