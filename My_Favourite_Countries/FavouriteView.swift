import SwiftUI

struct FavouriteView: View {
//    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: FavouriteCountry.entity(), sortDescriptors: []) var favouriteCountries: FetchedResults<FavouriteCountry>
    
    
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
            }
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
