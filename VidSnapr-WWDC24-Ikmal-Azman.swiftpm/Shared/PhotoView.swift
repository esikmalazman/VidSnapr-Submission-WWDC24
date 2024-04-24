//
//  Photo.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 02/02/2024.
//

import SwiftUI

struct PhotoView : View {
  @Binding var image : UIImage?
  var height : CGFloat
  var width : CGFloat
  
  ///  @GestureState, allow updates a property while the user performs a gesture and resets the property back to its initial state when the gesture ends.
  /// - Maximum zoom user able to scale
  /// - Value that will be used to update the views
  @State private var totalZoom : CGFloat = 1.0
  
  var body: some View {
    VStack {
      if let image = image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(
            maxWidth: width,
            maxHeight: height,
            alignment: .center
          )
          .scaleEffect(totalZoom)
          .gesture(pinchToZoom)
      }
    }
  }
  
  private var pinchToZoom : some Gesture {
    /// Allow to recognize a magnification motion and tracks the amount.
    MagnificationGesture()
    /// - value : return value assign to the scale in updating(:_) modifier
      .onChanged { value in
        /// Place to start magnifying
        withAnimation {
          /// Limit zoom scale by use min to get comparable value that less than 10
          let value = min(max(value.magnitude, 0.5), 10.0)
          totalZoom = value
        }
      }
      .onEnded { value in
        withAnimation {
          /// Reset the scale when it ends
          totalZoom = 1.0
        }
      }
  }
}

#Preview {
  PhotoView(image: .constant(UIImage(systemName: "photo")), height: .infinity, width: .infinity)
}
