//
//  My_Favourite_CountriesApp.swift
//  My_Favourite_Countries
//
//  Created by Wonkeun No on 2022-12-12.
//

import SwiftUI

@main
struct My_Favourite_CountriesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
