//
//  VideoRecorderView.swift
//  SwiftUI-VideoPlayer
//
//  Created by esikmalazman on 27/01/2024.
//

import SwiftUI

struct VideoRecorderScreen : View {
  @EnvironmentObject var router : Router<Path>
  @StateObject var recorder = VideoRecordingEngine()
  
  var body: some View {
    ZStack {
      CameraPreview(session: $recorder.session)
        .ignoresSafeArea()
      
      VStack {
        Spacer()
        
        HStack {
          Image(systemName: "camera.rotate")
            .frame(maxWidth: 65, maxHeight: 65, alignment : .leading)
            .hidden()
          

          Button {
            _ = recorder.isRecording ? recorder.stopRecording() : recorder.startRecording()
          } label: {
            
            Image(systemName: recorder.isRecording ? "stop.circle" : "circle.fill")
              .resizable()
              .scaledToFit()
              .frame(maxWidth: 65, maxHeight: 65, alignment : .center)
              .foregroundStyle(.red)
          }
          Spacer()
          
          
          Button {
            recorder.toggleCamera()
          } label: {
            
            Image(systemName: "camera.rotate")
              .resizable()
              .scaledToFit()
              .frame(maxWidth:30, maxHeight: 30 , alignment : .trailing)
              .padding(10)
              .background(.gray.opacity(0.5))
              .clipShape(.circle)
              .padding(.trailing)
              .foregroundStyle(.white)
              .opacity(recorder.isRecording ? 0 : 1)
          }
        }
      }
      
      Label("Recording ...", systemImage: "circle.fill" )
        .font(.caption2)
        .padding(10)
        .background(.red)
        .clipShape(.capsule)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topTrailing)
        .padding(.trailing)
        .opacity(recorder.isRecording ? 1 : 0)
    }
    .safeAreaInset(edge: .leading, alignment: .top) {
      Button {
        router.pop()
      } label: {
        Label("", systemImage: "xmark" )
          .font(.caption2)
          .padding(10)
          .background(.gray.opacity(0.5))
          .clipShape(.capsule)
          .foregroundStyle(.white)
          .frame(maxWidth: 60, maxHeight: 60,alignment: .topLeading)
          .padding(.leading)
          .labelStyle(.iconOnly)
          .opacity(recorder.isRecording ? 0 : 1)
      }
    }
    .onChange(of: recorder.outputFileURL, perform: { outputURL in
      guard let url = outputURL else {return}
      router.push(.videoSlider(url: url))
    })
    .navigationBarBackButtonHidden()
    .statusBarHidden()
  }
  
  var recordingLabelView : some View {
    Label("Recording ...", systemImage: "circle.fill" )
      .font(.caption2)
      .padding(10)
      .background(.red)
      .clipShape(.capsule)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .topTrailing)
      .padding(.trailing)
      .opacity(recorder.isRecording ? 1 : 0)
  }
}

#Preview {
  VideoRecorderScreen()
}

struct Platform {
  static var isSimulator : Bool {
    TARGET_OS_SIMULATOR != 0
  }
}
