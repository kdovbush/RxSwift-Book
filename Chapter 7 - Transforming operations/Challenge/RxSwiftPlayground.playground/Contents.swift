import Foundation
import RxSwift

example(of: "Challenge 1") {
	let disposeBag = DisposeBag()
	
	let contacts = [
		"603-555-1212": "Florent",
		"212-555-1212": "Junior",
		"408-555-1212": "Marin",
		"617-555-1212": "Scott"
	]
	
	func phoneNumber(from inputs: [Int]) -> String {
		var phone = inputs.map(String.init).joined()
		
		phone.insert("-", at: phone.index(
			phone.startIndex,
			offsetBy: 3)
		)
		
		phone.insert("-", at: phone.index(
			phone.startIndex,
			offsetBy: 7)
		)
		
		return phone
	}
	
	let convert: (String) -> Int? = { value in
		if let number = Int(value),
			number < 10 {
			return number
		}
		
		let convert: [String: Int] = [
			"abc": 2, "def": 3, "ghi": 4,
			"jkl": 5, "mno": 6, "pqrs": 7,
			"tuv": 8, "wxyz": 9
		]
		
		let converted = convert
			.filter { $0.key.contains(value.lowercased()) }
			.map { $0.value }
			.first
		
		return converted
	}
	
	let format: ([Int]) -> String = {
		var phone = $0.map(String.init).joined()
		
		phone.insert("-", at: phone.index(
			phone.startIndex,
			offsetBy: 3)
		)
		
		phone.insert("-", at: phone.index(
			phone.startIndex,
			offsetBy: 7)
		)
		
		return phone
	}
	
	
	let dial: (String) -> String = {
		if let contact = contacts[$0] {
			return "Dialing \(contact) (\($0))..."
		} else {
			return "Contact not found"
		}
	}
	
	let input = PublishSubject<Int>()
	
	
	input
		.map { String($0) }
		.map { convert($0) }
		.filter { $0 != nil }
		.map { $0! }
		.skipWhile { $0 == 0 }
		.filter { $0 < 10 }
		.take(10)
		.toArray()
		.subscribe(onNext: {
			let phone = phoneNumber(from: $0)
			let answer = dial(phone)
			print(answer)
		})
		.disposed(by: disposeBag)
	
	input.onNext(0)
	input.onNext(603)
	
	input.onNext(2)
	input.onNext(1)
	
	// Confirm that 7 results in "Contact not found", and then change to 2 and confirm that Junior is found
	input.onNext(7)
	
	"5551212".forEach {
		if let number = (Int("\($0)")) {
			input.onNext(number)
		}
	}
	
	input.onNext(9)
}
