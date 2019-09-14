//
//  DiarySectionModel.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/10.
//

import Foundation
import RealmSwift
import RxDataSources

struct DiarySectionModel<ItemType: IdentifiableType> {
    var header: String
    var items: [ItemType]
    
    init(header: String, items: [Item]) {
        self.header = header
        self.items = items
    }
}

extension DiarySectionModel: SectionModelType {
    typealias Item = ItemType
    
    init(original: DiarySectionModel<ItemType>, items: [ItemType]) {
        self.header = original.header
        self.items = items
    }
}
