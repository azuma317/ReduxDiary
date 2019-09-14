//
//  RxStore.swift
//  ReduxDiary
//
//  Created by Azuma on 2019/09/07.
//

import Foundation
import ReSwift
import RxSwift
import RxCocoa

class RxStore<AnyStateType>: StoreSubscriber where AnyStateType: StateType {
    
    private let store: Store<AnyStateType>
    private let stateRelay: BehaviorRelay<AnyStateType>
    
    var state: AnyStateType { return stateRelay.value }
    lazy var stateObservable: Observable<AnyStateType> = {
        return self.stateRelay.asObservable()
    }()
    
    init(store: Store<AnyStateType>) {
        self.store = store
        self.stateRelay = BehaviorRelay(value: store.state)
        self.store.subscribe(self)
    }
    
    deinit {
        self.store.unsubscribe(self)
    }
    
    func newState(state: AnyStateType) {
        stateRelay.accept(state)
    }
    
    func dispatch(_ action: Action) {
        store.dispatch(action)
    }
    
}
