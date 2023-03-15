//
//  ContentView.swift
//  SmartPix
//
//  Created by Sivakumar, Namrata on 15/03/23.
//

import SwiftUI
import PythonKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
}

