import SwiftUI

@main
struct My_Favourite_CountriesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            MainView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            TabView {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Countries", systemImage: "flag")
                }
                FavouriteView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .tabItem {
                        Label("Favourite", systemImage: "star")
                    }
            }
        }
    }
}
