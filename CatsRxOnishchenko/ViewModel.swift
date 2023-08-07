//
//  ViewModel.swift
//  CatsRxOnishchenko
//
//  Created by lera on 24.02.2023.
//

import Foundation
import RxSwift

final class ViewModel{
    private static let defStr = "Loading, please wait..."
    private static let defUIImg = UIImage(named: "cat")
    private let disposeBag = DisposeBag()
    
    let inClick = PublishSubject<Void>()
    let outSubject = BehaviorSubject<(fact: String, img: UIImage?)>(value:
                                                                        (fact: "Fun cats fact",
                                                                         img: defUIImg))
    let outUrlAlert = PublishSubject<Bool>()
    init() {
        
        inClick
            .subscribe(
                onNext: {[weak self] in
                    self?.outSubject.onNext((ViewModel.defStr,ViewModel.defUIImg))
                    guard let self else {return}
                    guard let singleImage = NetworkTaskFactory.getNewTask(
                        url: "https://cataas.com/c",
                        type: Data.self
                    ) else {
                        self.outUrlAlert.onNext(false)
                        return
                    }
                    guard let singleFact = NetworkTaskFactory.getNewTask(
                        url: "https://catfact.ninja/fact",
                        type: CatFact.self
                    ) else {
                        self.outUrlAlert.onNext(false)
                        return
                    }
                    Single.zip(
                        singleImage,
                        singleFact
                    ).subscribe(onSuccess: { [weak self] (Data, CatFact) in
                        guard let self else { return }
                        self.outSubject.onNext((CatFact.fact,UIImage(data: Data)))
                    },
                                onFailure: { error in
                        self.outUrlAlert.onNext(false)
                    })
                    .disposed(by: self.disposeBag)
                    
                }).disposed(by: disposeBag)
    }
}

