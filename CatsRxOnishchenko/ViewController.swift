//
//  ViewController.swift
//  CatsRxOnishchenko
//
//  Created by lera on 24.02.2023.
//

import UIKit
import RxSwift

final class ViewController: UIViewController {
    // MARK: - Private properties
    private let vm = ViewModel()
    
    private let disposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var catFact: UILabel!
    @IBOutlet private weak var catImage: UIImageView!
    
    // MARK: - IBActions
    @IBAction func generateStory(_ sender: Any) {
        vm.inClick.onNext(())
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureRx()
    }
    
    private func configureRx(){
        vm.outSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] in
                    self?.catImage.image = $0.img
                    self?.catFact.text = $0.fact
                }).disposed(by: disposeBag)
        vm.outUrlAlert.observe(on: MainScheduler.instance)
            .subscribe(
            onNext: {[weak self] in
                if $0 == false{
                    let alert = UIAlertController(title: "Alert", message: "Sorry, internal Error", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
                    self!.present(alert, animated: true, completion: nil)
                }
            }
        )
        .disposed(by: disposeBag)
    }
}

