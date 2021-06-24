//
//  Memo+CoreDataProperties.swift
//  jmcMemo
//
//  Created by myeongcheol jeong on 2021/06/23.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?

}

extension Memo : Identifiable {

}
