//
//  DiaryDetailViewController.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import UIKit
import RxSwift
import ReSwift

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet private weak var diaryTextView: UITextView!
    
    // DiaryListViewControllerから渡されるパラメータ
    var diary: DiaryItem?
    
    // Store
    private let store = RxStore(store: Store<DiaryDetailState>(reducer: DiaryDetailReducer.reduce, state: nil))
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        diaryTextView.text = store.state.diary.text
        bind()
    }
    
    private func setup() {
        if let diary = diary {
            // diaryがある場合はdiaryをDiaryDetailStateにセット
            store.dispatch(DiaryDetailAction.set(diary: diary))
        } else {
            // diaryがない場合はDiaryを作成
            store.dispatch(DiaryDetailAction.create)
        }
    }
    
    private func bind() {
        // TextViewを記述するたびにRealmに保存
        diaryTextView.rx.text
            .subscribe({ [unowned self] event in
                self.store.dispatch(DiaryDetailAction.update(text: event.element! ?? ""))
            })
            .disposed(by: disposeBag)
    }

}
