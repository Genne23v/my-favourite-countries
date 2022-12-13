//
//  MainView.swift
//  My_Favourite_Countries
//
//  Created by Wonkeun No on 2022-12-13.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Countries", systemImage: "flag")
            }
            FavouriteView()
                .tabItem {
                    Label("Favourite", systemImage: "star")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
