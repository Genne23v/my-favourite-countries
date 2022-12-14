//
//  FavouriteCountry+CoreDataProperties.swift
//  My_Favourite_Countries
//
//  Created by Wonkeun No on 2022-12-14.
//
//

import Foundation
import CoreData


extension FavouriteCountry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteCountry> {
        return NSFetchRequest<FavouriteCountry>(entityName: "FavouriteCountry")
    }

    @NSManaged public var capital: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var population: Int32

}

extension FavouriteCountry : Identifiable {

}
