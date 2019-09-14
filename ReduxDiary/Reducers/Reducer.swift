//
//  DiaryReducer.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import Foundation
import ReSwift
import RealmSwift

// DiaryListViewControllerのReducer
struct DiaryReducer {
    static func reduce(_ action: Action, state: DiaryState?) -> DiaryState {
        var state = state ?? DiaryState()
        guard let action = action as? DiaryAction else { return state }
        state.realm.beginWrite()
        switch action {
        case .reload: break
        case .delete(let diary):
            state.realm.delete(diary)
        }
        try! state.realm.commitWrite()
        let diaries = state.realm.objects(DiaryItem.self).sorted(byKeyPath: "updatedAt", ascending: false)
        state.sectionModel = [DiarySectionModel(header: "header", items: diaries.map({ $0 }))]
        return state
    }
}

// DiaryDetailViewControllerのReducer
struct DiaryDetailReducer {
    static func reduce(_ action: Action, state: DiaryDetailState?) -> DiaryDetailState {
        var state = state ?? DiaryDetailState()
        guard let action = action as? DiaryDetailAction else { return state }
        state.realm.beginWrite()
        switch action {
        case .create:
            state.realm.add(state.diary)
        case .set(let diary):
            state.diary = diary
        case .update(let text):
            state.diary.text = text
            state.diary.updatedAt = Date()
        }
        try! state.realm.commitWrite()
        return state
    }
}
