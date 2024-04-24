//
//  Carousell.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 06/02/2024.
//

import SwiftUI

/// https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-a-scroll-view-move-to-a-location-using-scrollviewreader
struct CarousellView: View {
  let thumbnails : [Thumbnail]
  var action : (Thumbnail)-> Void = {_ in}
  
    var body: some View {
      /// ScrollViewReader allow to programmatically scrolling in SwiftUI
      /// It has ScrollViewProxy which has a proxy value to scroll towards item in view hierarchy
      ScrollViewReader { value in
        ScrollView(.horizontal) {
          HStack {
            ForEach(thumbnails.indices, id: \.self) {  index in
              let image = thumbnails[index]
              ThumbnailPreview(thumbnail: image) {
                /// Reader scan all items in scroll view and scrolls to that view
                value.scrollTo(index, anchor: .center)
                action(image)
             
              }
            }
          }
          .padding(.horizontal)
          .frame(maxHeight: 100)
        }
        .scrollIndicators(.hidden)
      }
    }
}

#Preview {
  CarousellView(thumbnails: .samples)
}
