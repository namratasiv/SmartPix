//
//  ContentView.swift
//  SmartPix
//
//  Created by Sivakumar, Namrata on 15/03/23.
//

import SwiftUI
import PhotosUI
struct ContentView: View {
    @State private var isShowPhotoLibrary = false
    @State private var isDone = true
    @State private var showForm = false
    
        @State private var image = UIImage()
        var body: some View {
            
            VStack {
                Image(uiImage: self.image)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    //.overlay(ImageOverlay(), alignment: .top)
     
                Button(action: {
                    self.isShowPhotoLibrary = true
                    self.isDone = false
                    
                }) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
     
                        Text("Upload a photo")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                Button("Done") {
                    self.showForm = true
                    }
                .disabled(self.isDone)
                .sheet(isPresented: $showForm) {
                    Color.white
                            .presentationDetents([.fraction(0.4)])
                    NavigationView{
                        SecondView()
                    }.navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
                
            }.sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(selectedImage: self.$image,sourceType: .photoLibrary )
                
            }
    }
}

struct SecondView: View {
    @State var question: String = ""
    @State private var showAnswer = false
    var body: some View {
        Form{
            
            Section(header: Text("Ask Anything")){
                TextField("Question", text: $question)
            }
                Button(action: {
                    print("Replicate called here")
                    self.showAnswer = true
                    }) {
                        Text("Submit Question")
                    }.sheet(isPresented: $showAnswer) {
                        Color.white
                                .presentationDetents([.fraction(0.4)])
                        Text("Print Answer Here").foregroundColor(.primary).font(.title)
                        
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

