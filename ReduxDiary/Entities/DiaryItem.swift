//
//  Diary.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/09.
//

import Foundation
import RealmSwift
import RxDataSources

class DiaryItem: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var text = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    } 
}

extension DiaryItem: IdentifiableType {
    typealias Identity = String
    
    var identity: String {
        return id
    }
}
