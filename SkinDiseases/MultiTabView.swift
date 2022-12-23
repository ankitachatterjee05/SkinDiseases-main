//
//  MultiTabView.swift
//  SkinDiseases
//
//  Created by Ankita Chatterjee on 4/16/22.
//

import SwiftUI
struct MultiTabView: View {
    var body: some View {
        TabView{
            WebView(url:URL(string:"https://dermrecog.weebly.com")!)
                .tabItem{
                    Label("Web page",systemImage: "camera.circle")
                }
            CallAIView()
                .tabItem{
                    Label("Use AI",systemImage: "list.number")
                }
            FormView()
                .tabItem{
                    Label("Settings",systemImage: "keyboard")
                }
        }
    }
}
struct Tab1View: View {
    var body: some View {
        Text("Page 1")
    }
}
struct Tab2View: View {
    var body: some View {
        Text("Page 2")
    }
}
struct Tab3View: View {
    var body: some View {
        Text("Page 3")
    }
}
struct MultiTabView_Previews: PreviewProvider {
    static var previews: some View {
        MultiTabView()
    }
}
