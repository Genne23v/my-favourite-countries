import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: FavouriteCountry.entity(), 
        sortDescriptors: [NSSortDescriptor(keyPath: \FavouriteCountry.name, ascending: true)],
        animation: .default)
    private var favouriteCountries: FetchedResults<FavouriteCountry>
    @State var countries:[Country] = []
    @State private var isShowingAlert = false
    @State private var viewDidLoad = false
    @State private var isExsitingId = false
    @State private var userMessage = ""
    
    var body: some View {
        List(countries, id: \.id) { country in
            VStack{
                HStack{
                    AsyncImage(url: URL(string: country.flagLink ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 24)
                        case .failure(let error):
                            Image(systemName: "photo")
                        case .empty:
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                    }
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
            }.onTapGesture {
                print("\(country.id) - \(country.name)")
                
                for favouriteCountry in favouriteCountries {
                    if favouriteCountry.name == country.name {
                        print("CoreData: \(favouriteCountry.name) vs. Selected ID: \(country.name)")
                        isExsitingId = true
                    }
                }
                
                if isExsitingId == false {
                    let addToFavourite:FavouriteCountry = FavouriteCountry(context: viewContext)
                    addToFavourite.id = country.id
                    addToFavourite.name = country.name
                    addToFavourite.countryCode = country.countryCode
                    addToFavourite.capital = country.capital
                    addToFavourite.population = Int32(country.population)
                    addToFavourite.flagLink = country.flagLink
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print("Could not save it to CoreData")
                        print(error)
                    }
                    print("\(country.name) added to favourite")
                    userMessage = "\(country.name) added to favourite list!"
                } else {
                    userMessage = "\(country.name) is already in favourite list"
                }
                isShowingAlert = true
                isExsitingId = false
            }
            .alert(userMessage, isPresented: $isShowingAlert) { }
        }
        .onAppear{
            if viewDidLoad == false {
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
                            print("\(countries.count) countries are fetched")
                        }
                        viewDidLoad = true
                    } catch let error {
                        print("An error occurred during JSON decoding")
                        print(error)
                    }
                }.resume()
            }
        }
    }

    private func addToFavourite(country:Country) {
        withAnimation {
            let addToFavourite:FavouriteCountry = FavouriteCountry(context: viewContext)
            addToFavourite.id = country.id
            addToFavourite.name = country.name
            addToFavourite.countryCode = country.countryCode
            addToFavourite.capital = country.capital
            addToFavourite.population = Int32(country.population)
            
            do {
                try viewContext.save()
                isShowingAlert = true
                print("\(country.name) added to favourite")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                print("Could not save it to CoreData")
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
