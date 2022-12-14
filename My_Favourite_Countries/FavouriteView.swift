import SwiftUI

struct FavouriteView: View {
//    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: FavouriteCountry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavouriteCountry.name, ascending: true)], animation: .default) var favouriteCountries: FetchedResults<FavouriteCountry>
    @State private var isShowingAlert = false
    @State private var removingCountry = ""
    
    var body: some View {
        List(favouriteCountries, id: \.id) { country in
            VStack{
                HStack{
                    Text("\(country.name ?? "n/a")").fontWeight(.bold)
                    Spacer()
                    Text("\(country.countryCode ?? "n/a")").fontWeight(.bold)
                }
                HStack{
                    Text("Capital: \(country.capital ?? "n/a")")
                        .font(.subheadline)
                        .fontWeight(.thin)
                    Spacer()
                    Text("Population: \(country.population)")
                        .font(.subheadline)
                        .fontWeight(.thin)
                }
            }.onTapGesture {
                print(country)
                guard let removingCountryName = country.name else {
                    print("Removing country name is empty")
                    return
                }
                removingCountry = removingCountryName
                
                do {
                    viewContext.delete(country)
                    try viewContext.save()
                    isShowingAlert = true
                } catch {
                    print("Could not delete request country in CoreData")
                    print(error)
                }
            }.alert("\(removingCountry) removed in favourite list", isPresented: $isShowingAlert) { }
        }
        .onAppear {
            for country in favouriteCountries {
                print("\(country.id) - \(country.name ?? "n/a")")
            }
        }
    }
    
    func fetchFavouriteCountries() {

    }
    
    struct FavouriteView_Previews: PreviewProvider {
        static var previews: some View {
            FavouriteView()
        }
    }
}
