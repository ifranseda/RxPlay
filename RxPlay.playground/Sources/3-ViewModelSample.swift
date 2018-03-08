import XCTest
import RxSwift

public class ViewModelSample: XCTestCase {

    var disposeBag: DisposeBag = DisposeBag()

    func test_WhenLoginIsSuccesfulProgressIsDisplayedCorrect() {
        let userViewModel: UserViewModel = UserViewModel()
        
        let loginProgresCollector = RxCollector<Bool>()
            .collect(from: userViewModel.loginProgres.asObservable())
        
        let displayAlertDialogCollector = RxCollector<Void>()
            .collect(from: userViewModel.displayAlertDialog)
        
        let reloadTableViewCollector = RxCollector<Void>()
            .collect(from: userViewModel.reloadTableView)
        
        let expection = self.expectation(description: "")
        userViewModel.login(makeFail: true)
            .subscribe(
                onNext: { _ in
                },
                onError: { _ in
                    expection.fulfill()
                },
                onCompleted: {
                    expection.fulfill()
                }
            )
            .disposed(by: disposeBag)
        
        wait(for: [expection], timeout: 10)
        
        XCTAssertEqual(loginProgresCollector.toArray, [false, true, false])
        XCTAssertEqual(displayAlertDialogCollector.toArray.count, 1)
        XCTAssertEqual(reloadTableViewCollector.toArray.count, 0)
    }
}

class UserViewModel {
    private(set) var loginProgres: Variable<Bool> = Variable<Bool>(false)
    private(set) var reloadTableView: PublishSubject<Void> = PublishSubject<Void>()
    private(set) var displayAlertDialog: PublishSubject<Void> = PublishSubject<Void>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private let apiClient: ApiClient = ApiClient()
    
    func login(makeFail: Bool) -> Observable<Void> {
        loginProgres.value = true
        return apiClient.login(makeFail: makeFail)
            .observeOn(MainScheduler.instance)
            .do(
                onNext: { [weak self] (_) in
                    self?.reloadTableView.onNext(())
                },
                onError: { [weak self] (_) in
                    self?.loginProgres.value = false
                    self?.displayAlertDialog.onNext(())
                },
                onCompleted: { [weak self] in
                    self?.loginProgres.value = false
                }
            )
    }
}

class ApiClient {
    func login(makeFail: Bool) -> Observable<Void> {
        return Observable<Void>.create { observer in
            DispatchQueue.global(qos: .background).async {
                if makeFail {
                    observer.onError(NSError(domain: "", code: 0, userInfo: nil))
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
    }
}

class RxCollector<T> {
    var deadBodies: DisposeBag = DisposeBag()
    var toArray: [T] = [T]()
    
    func collect(from observable: Observable<T>) -> RxCollector {
        observable.asObservable()
            .subscribe(onNext: { (newZombie) in
                self.toArray.append(newZombie)
            })
            .disposed(by: deadBodies)
        return self
    }
}
