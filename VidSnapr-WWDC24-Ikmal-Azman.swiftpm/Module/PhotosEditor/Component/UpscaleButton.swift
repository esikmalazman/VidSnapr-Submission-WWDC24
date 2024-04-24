//
//  UpscaleButton.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 06/02/2024.
//

import SwiftUI

struct UpscaleButton: View {
  var action : ()-> Void = {}
  
  var body: some View {
    Button {
      action()
    } label: {
      Label("Upscale", systemImage: "wand.and.stars")
        .foregroundColor(.white)
        .padding(10)
        .background(
          RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 1.0)
            .foregroundStyle(.indigo)
        )
    }
  }
}

#Preview {
  UpscaleButton()
}
