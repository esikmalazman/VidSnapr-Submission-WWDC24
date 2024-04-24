//
//  BottomActionView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 06/02/2024.
//

import SwiftUI

struct BottomActionView: View {
  var removeAction : () -> Void = {}
  var doneAction : () -> Void = {}
  
  var body: some View {
    HStack {
      Button {
        removeAction()
        
      } label: {
        Label("Remove", systemImage: "trash")
          .padding(5)
          .foregroundStyle(.red.opacity(0.8))
      }
      
      Spacer()
      
      Button {
        doneAction()
        
      } label: {
        Label("Done", systemImage: "square.and.arrow.down")
          .padding(5)
      }
      .buttonStyle(.borderedProminent)
      .tint(.indigo)
    }
    .padding()
  }
}

#Preview {
  BottomActionView()
}
