//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift

//example(of: "toArray") {
//	let bag = DisposeBag()
//
//	Observable.of("A", "B", "C")
//		.toArray()
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
//}

//example(of: "map") {
//	let bag = DisposeBag()
//
//	let formatter = NumberFormatter()
//	formatter.numberStyle = .spellOut
//
//	Observable<Int>.of(123, 4, 56)
//		.map { formatter.string(for: $0) ?? "" }
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
//}

//example(of: "enumerated and map") {
//	let bag = DisposeBag()
//
//	Observable.of(1, 2, 3, 4, 5, 6)
//		.enumerated()
//		.map { index, integer in
//			index > 2 ? integer * 2 : integer
//		}
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
//}

struct Student {
	let score: BehaviorSubject<Int>
}

//example(of: "flatMap") {
//	let bag = DisposeBag()
//
//	let laura = Student(score: BehaviorSubject(value: 80))
//	let charlotte = Student(score: BehaviorSubject(value: 90))
//
//	let student = PublishSubject<Student>()
//
//	student
//		.flatMap {
//			$0.score
//		}
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
//
//	student.onNext(laura)
//
//	laura.score.on(.next(85))
//
//	student.onNext(charlotte)
//
//	laura.score.onNext(95)
//
//	charlotte.score.onNext(100)
//
//}
//
//example(of: "flatMapLatest") {
//	let bag = DisposeBag()
//
//	let laura = Student(score: BehaviorSubject(value: 80))
//	let charlotte = Student(score: BehaviorSubject(value: 90))
//
//	let student = PublishSubject<Student>()
//
//	student
//		.flatMapLatest {
//			$0.score
//		}
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
//
//	student.onNext(laura)
//
//	laura.score.on(.next(85))
//
//	student.onNext(charlotte)
//
//	laura.score.onNext(95)
//
//	charlotte.score.onNext(100)
//
//}

example(of: "materialize and dematerialize") {
	enum MyError: Error {
		case anError
	}
	
	let bag = DisposeBag()
	
	let laura = Student(score: BehaviorSubject(value: 80))
	let charlotte = Student(score: BehaviorSubject(value: 100))
	
	let student = BehaviorSubject(value: laura)
	
	let studentScore = student
		.flatMapLatest {
			$0.score.materialize()
		}
//	studentScore
//		.subscribe(onNext: {
//			print($0)
//		})
//		.disposed(by: bag)
	
	studentScore
		.filter {
			guard $0.error == nil else {
				print($0.error!)
				return false
			}
			return true
		}
		.dematerialize()
		.subscribe(onNext: {
			print($0)
		})
		.disposed(by: bag)
	
	laura.score.onNext(85)
	laura.score.onError(MyError.anError)
	laura.score.onNext(90)
	
	student.onNext(charlotte)
	
	
}
