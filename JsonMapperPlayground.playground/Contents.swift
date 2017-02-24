//: Playground - noun: a place where people can play

import Foundation

extension String {
    subscript(i: Int) -> String? {
        get {
            guard i >= 0 && i < characters.count else {
                return nil
            }
            return String(self[index(startIndex, offsetBy: i)])
        }
        
        set (newValue) {
            if let value = newValue, i >= 0 && i < characters.count {
                replaceSubrange(index(startIndex, offsetBy: i)...index(startIndex, offsetBy: i), with: value)
            }
        }
    }
}

var string:String = "0987654321"
string[2]
string[3] = "A"
string

//////////////////////////////////////////////////////

precedencegroup Equivalence {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}
infix operator ~ : Equivalence
func ~(left:Int,right:Int) -> Int {
    return left * right
}

1 + 2 ~ 3    // 7
1 * 2 ~ 3    // 6
1 < 2 ~ 3    // true

//////////////////////////////////////////////////////

class Animal {
    
}

class Cat:Animal {
    
}

let animal:Animal = Cat()
if let cat = animal as? Cat{
    print("cat is not nil")
} else {
    print("cat is nil")
}

/////////////////////////////////////////////////////

class testMapper {
    var currentValue = "222"
    
    func value<T>() -> T? {
        return currentValue as? T
    }
    
    class func optionalBasicType<FieldType>(_ field: inout FieldType!, object: FieldType?) {
        field = object
    }
}

var testVal:String!
var testObj = testMapper()
testMapper.optionalBasicType(&testVal, object: testObj.value())


