import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavouriteCountry.name, ascending: true)],
        animation: .default)
    private var favouriteCountries: FetchedResults<FavouriteCountry>
    @State private var viewDidLoad = false
    @State var countries:[Country] = []

    var body: some View {
        List(countries, id: \.id) { country in
            VStack{
                HStack{
                    Text("\(country.name)").fontWeight(.bold)
                    Spacer()
                    Text("\(country.countryCode)").fontWeight(.bold)
                }
                HStack{
                    Text("Capital: \(country.capital)")
                        .font(.subheadline)
                        .fontWeight(.thin)
                    Spacer()
                    Text("Population: \(country.population)")
                        .font(.subheadline)
                        .fontWeight(.thin)
                }
            }
        }
        .onAppear{
            let restCountryApiEndpoint = "https://restcountries.com/v2/all"
            
            guard let apiUrl = URL(string: restCountryApiEndpoint) else {
                print("Could not convert the string endpoint to an URL object")
                return
            }
            
            URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
                if let err = error {
                    print("Error occurred while fetching data from API")
                    print(err)
                    return
                }
                
                guard let data = data else {
                    print("Error occurred while fetching data from API")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedItem:[Country] = try decoder.decode([Country].self, from: data)
                    
                    DispatchQueue.main.async {
                        countries = decodedItem
                        print(countries.count)
                    }
                } catch let error {
                    print("An error occurred during JSON decoding")
                    print(error)
                }
            }.resume()
        }
    }

    private func addToFavourite() {
        withAnimation {
//            let newCountry = Country(context: viewContext)
            

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { countries[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
