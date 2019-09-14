//
//  DiaryListViewController.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import UIKit
import RxSwift
import RxCocoa
import ReSwift
import RxDataSources
import RealmSwift

class DiaryListViewController: UIViewController {

    @IBOutlet private weak var diaryListView: UITableView!
    @IBOutlet private weak var addDiaryButton: UIBarButtonItem!
    
    // Store
    private let store = RxStore(store: Store<DiaryState>(reducer: DiaryReducer.reduce, state: nil))
    private let disposeBag = DisposeBag()
    
    // diaryListViewのdataSource
    private let dataSource = RxTableViewSectionedReloadDataSource<DiarySectionModel<DiaryItem>>(configureCell: { (_, tableView, indexPath, result) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        cell.configure(result)
        return cell
    }, canEditRowAtIndexPath: { _, _ in
        return true
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // realmの更新を確認
        store.dispatch(DiaryAction.reload)
    }
    
    private func bind() {
        // diaryListViewにdataSourceを適用
        store.sectionModel
            .bind(to: diaryListView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // Cellがスワイプで削除されたときの処理
        diaryListView.rx.itemDeleted
            .subscribe({ [unowned self] event in
                guard let indexPath = event.element else { return }
                self.store.dispatch(DiaryAction.delete(diary: self.dataSource.sectionModels[indexPath.section].items[indexPath.item]))
            })
            .disposed(by: disposeBag)
        
        // Cell押下時の画面遷移の処理
        diaryListView.rx.itemSelected
            .subscribe({ [unowned self] event in
                guard let indexPath = event.element else { return }
                self.performSegue(withIdentifier: "UpdateDiarySegue", sender: self.dataSource.sectionModels[indexPath.section].items[indexPath.item])
            })
            .disposed(by: disposeBag)
        
        diaryListView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 右上の追加ボタン押下時の処理
        addDiaryButton.rx.tap
            .subscribe({ [unowned self] _ in
                self.performSegue(withIdentifier: "CreateDiarySegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DiaryDetailViewController else { return }
        if segue.identifier == "CreateDiarySegue" {
            vc.diary = nil
        } else if segue.identifier == "UpdateDiarySegue" {
            guard let diary = sender as? DiaryItem else { return }
            vc.diary = diary
        }
    }

}

extension DiaryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
}

extension RxStore where AnyStateType == DiaryState {
    // stateのsectionModelをObservableに変更
    var sectionModel: Observable<[DiarySectionModel<DiaryItem>]> {
        return stateObservable.map({ $0.sectionModel })
    }
}
