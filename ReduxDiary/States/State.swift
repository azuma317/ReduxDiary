//
//  DiaryState.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import RealmSwift
import ReSwift
import RxDataSources

// DiaryListViewControllerのState
struct DiaryState: StateType {
    var sectionModel: [DiarySectionModel<DiaryItem>] = []
    var realm = try! Realm()
}

// DiaryDetailViewControllerのState
struct DiaryDetailState: StateType {
    var diary = DiaryItem()
    var realm = try! Realm()
}
