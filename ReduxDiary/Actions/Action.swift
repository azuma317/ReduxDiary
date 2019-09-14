//
//  DiaryAction.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import ReSwift

// DiaryListViewControllerで使うAction
enum DiaryAction: Action {
    case reload
    case delete(diary: DiaryItem)
}

// DiaryDetailViewControllerで使うAction
enum DiaryDetailAction: Action {
    case create
    case set(diary: DiaryItem)
    case update(text: String)
}
