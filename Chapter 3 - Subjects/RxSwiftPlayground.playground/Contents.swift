//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift

//example(of: "PublishSubject") {
//    let subject = PublishSubject<String>()
//    subject.onNext("Is anyone listening?")
//
//    let subscriptionOne = subject
//        .subscribe(onNext: { string in
//            print("1) \(string)")
//    })
//
//    subject.on(.next("1"))
//    subject.onNext("2")
//
//    let subscriptionTwo = subject.subscribe { event in
//        print("2)", event.element ?? event)
//    }
//
//    subject.onNext("3")
//    subscriptionOne.dispose()
//    subject.onNext("4")
//
//    subject.onCompleted()
//
//    subject.onNext("5")
//
//    subscriptionTwo.dispose()
//
//    let disposeBag = DisposeBag()
//
//    subject.subscribe {
//        print("3)", $0.element ?? $0)
//    }.disposed(by: disposeBag)
//
//    subject.onNext("?")
//}

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event)
}
//
//example(of: "BehaviourSubject") {
//    let subject = BehaviorSubject(value: "Initial value")
//    let disposeBag = DisposeBag()
//
//    subject.onNext("X")
//
//    subject.subscribe {
//        print(label: "1)", event: $0)
//    }.disposed(by: disposeBag)
//
//    subject.onError(MyError.anError)
//
//    subject.subscribe {
//        print(label: "2)", event: $0)
//    }.disposed(by: disposeBag)
//}
//
//example(of: "ReplaySubject") {
//    let subject = ReplaySubject<String>.create(bufferSize: 2)
//    let disposeBag = DisposeBag()
//
//    subject.onNext("1")
//    subject.onNext("2")
//    subject.onNext("3")
//
//    subject.subscribe {
//        print(label: "1)", event: $0)
//    }.disposed(by: disposeBag)
//
//    subject.subscribe {
//        print(label: "2)", event: $0)
//    }.disposed(by: disposeBag)
//
//    subject.onNext("4")
//
//    subject.onError(MyError.anError)
//    subject.dispose()
//
//    subject.subscribe {
//        print(label: "3)", event: $0)
//    }.disposed(by: disposeBag)
//}

//example(of: "Variable") {
//    let variable = Variable("Initial value")
//    let disposeBag = DisposeBag()
//
//    variable.value = "New initial value"
//
//    variable.asObservable().subscribe {
//        print(label: "1)", event: $0)
//    }.disposed(by: disposeBag)
//
//    variable.value = "1"
//
//    variable.asObservable().subscribe {
//        print(label: "2)", event: $0)
//    }.disposed(by: disposeBag)
//
//    variable.value = "2"
//
//
//}

// Challenge 1

//example(of: "PublishSubject") {
//  let disposeBag = DisposeBag()
//  let dealtHand = PublishSubject<[(String, Int)]>()
//
//  func deal(_ cardCount: UInt) {
//    var deck = cards
//    var cardsRemaining = deck.count
//    var hand = [(String, Int)]()
//
//    for _ in 0..<cardCount {
//      let randomIndex = Int.random(in: 0..<cardsRemaining)
//      hand.append(deck[randomIndex])
//      deck.remove(at: randomIndex)
//      cardsRemaining -= 1
//    }
//
//    // Add code to update dealtHand here
//    let pts = points(for: hand)
//    if pts > 21 {
//        dealtHand.onError(HandError.busted(points: pts))
//    } else {
//        dealtHand.onNext(hand)
//  }
//
//  // Add subscription to dealtHand here
//    dealtHand.subscribe(onNext: { element in
//        print(cardString(for: element), points(for: element))
//    }, onError: { error in
//        print(error)
//    }).disposed(by: disposeBag)
//
//  deal(3)
//}

// Challenge 2

example(of: "BehaviorRelay") {
    enum UserSession {
        case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    let disposeBag = DisposeBag()
    
    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    
    let userSession = BehaviorSubject<UserSession>(value: .loggedOut)
    
    // Subscribe to receive next events from userSession
    
    
    userSession.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
        guard username == "johnny@appleseed.com",
            password == "appleseed" else {
                completion(LoginError.invalidCredentials)
                return
        }
        userSession.onNext(.loggedIn)
        
    }
    
    func logOut() {
        userSession.onNext(.loggedOut)
    }
    
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
        // Ensure that userSession is loggedIn and then execute action()
        let value = try? userSession.value()
        if value == .loggedIn {
            action()
        }
    }
    
    for i in 1...2 {
        let password = i % 2 == 0 ? "appleseed" : "password"
        
        logInWith(username: "johnny@appleseed.com", password: password) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User logged in.")
        }
        
        performActionRequiringLoggedInUser {
            print("Successfully did something only a logged in user can do.")
        }
    }
}
