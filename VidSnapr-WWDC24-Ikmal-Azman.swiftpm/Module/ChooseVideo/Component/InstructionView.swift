//
//  InstructionView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 16/02/2024.
//

import SwiftUI

struct InstructionView: View {
  
  var body: some View {
    VStack {
      Image(systemName: "play.tv.fill")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 200 , maxHeight : 200)
        .padding(80)
        .foregroundStyle(.indigo)
        .background(
          Color.indigo.opacity(0.5)
        )
        .clipShape(.rect(cornerRadius: 10))
        .overlay(
          alignment : .bottomTrailing
        ) { overlayIcons }
      
      stepsLabel
    }
    .frame(maxHeight: .infinity, alignment: .center)
  }
  
  private var overlayIcons : some View {
    VStack {
      Image(systemName: "fireworks")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 55 , maxHeight : 55)
        .padding(.trailing, 30)
      
      Image(systemName: "photo.on.rectangle.angled")
        .resizable()
        .scaledToFit()
        .frame(maxWidth: 30 , maxHeight : 30)
        .padding(.vertical)
        .padding(.leading)
    }
    .foregroundStyle(.indigo)
  }
  
  private var stepsLabel : some View {
    VStack(alignment: .leading, spacing: 10){
      Text("Make Memorable Images from Video Moments")
        .font(.title)
        .fontWeight(.semibold)
        .foregroundStyle(.indigo)
      
      Text("You can select video from your Album or Record new ones to capture special pictures")
        .foregroundStyle(.indigo.opacity(0.7))
    }
    .padding(.horizontal)
    .padding(.vertical)
  }
}

#Preview {
  InstructionView()
}
