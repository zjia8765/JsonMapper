# JsonMapper

###JSONModel和ObjectMapper代码解析
---

开发中我们经常用到一些将JSON转化为model对象的第三方库，
OC的比较多，`YYModel`,`JSONModel`,`Mantle`,`MJExtension`等。
Swift的相对较少，目前只用过`ObjectMapper`
本文将主要通过分析`JSONModel` 和`ObjectMapper`来展示OC和Swift在JSON映射成对象的不同及主要涉及的知识点。

####JSONModel主要函数及知识点
1. 初始化函数
`-(id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err`
<br>
2.  找出model对应的属性列表
`-(void)__inspectProperties`

1) 通过**runtime**的`class_copyPropertyList`方法获取model除`JSONModel`父类的所有的property列表

2)通过`property_getName`获取到属性名和`property_getAttributes`获取到的**`encode string`**，来分析出每个属性各的类型，名称等，并保存到JSONModel的`JSONModelClassProperty`对象里。

	**encode string**如下，T代表类型，@表示Cocoa对象类型，没有@则为基本类型，q表示long long，后面的表示Propert的属性，&为retain,N为nonatomic,之后的为变量名。参考[Declared Properties](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html),[Type Encodings](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html)
> imageId T@"NSString",&,N,V_imageId
timestamp Tq,N,V_timestamp
<br>
3. 通过**NSSet**判断需解析的dictionary里所有key是否包含刚解析出model的所有属性名，即为保证model中的property都能被赋值
`-(BOOL)__doesDictionary:(NSDictionary*)dict matchModelWithKeyMapper:(JSONKeyMapper*)keyMapper error:(NSError**)err`
**keyMapper**为用户自定义的映射表，如果不为空，则根据用户定义的进行转换
<br>
4. 各种情况的判断及赋值
`-(BOOL)__importDictionary:(NSDictionary*)dict withKeyMapper:(JSONKeyMapper*)keyMapper validation:(BOOL)validation error:(NSError**)err`
主要进行的判断:
	- value是否为空
	- 是否为标准JSON数据
	- 是否自定义setter方法，基本类型kvc赋值
	- JSONMode子类递归解析
	- 获取值类型和属性类型不一致时的转换

总结运用的主要知识点:**Runtime,NSet,KVC**
参看链接:
[JSONModel源码解析](https://satanwoo.github.io/2015/09/17/code-of-JSONModel/)
[JSONMOdel源代码解析](http://www.jianshu.com/p/64ce3927eb62)

####ObjectMapper
由于Swift是强类型语言，本身不具备动态性，所以不能再通过**Runtime**来进行model映射，可在Demo中查看，获取的property列表为空。
**`注:`**Swift可通过`dynamic`关键字使属性，方法获得动态性，但Swift特有类型(如Character、Tuple)，该属性，方法无法添加dynamic修饰，会报错。可查看[swift Runtime](https://mp.weixin.qq.com/s?__biz=MzA3ODg4MDk0Ng==&mid=403153173&idx=1&sn=c631f95b28a0eb4b842a9494e43a30e5&scene=0&key=d36a7cd042cf3c6c4d1b4a323ca9625bfca90e32df2151720ddc61f027affe50eea04afd592e3446135b2628e0a12cf5af214bc8d38d76ff503e3406b2cd779c392d4bea7240174bc9cdafd625bd7bcd&ascene=0&uin=MTkzNzYxNjk1&devicetype=iMac+MacBookPro11%2C1+OSX+OSX+10.12.1+build(16B2555)&version=12010310&nettype=WIFI&fontScale=100&pass_ticket=ji1tPwp6tA%2FU%2BKdmZUBrp1wn%2B0PTnORZfvKuogesPjc%3D)

在分析源码前先说一下`ObjectMapper`主要用到的知识点
- **下标**
下标可以定义在类、结构体和枚举中，是访问集合，列表或序列中元素的快捷方式。可以使用下标的索引，设置和获取值。一个类型可以定义多个下标，通过不同索引类型进行重载。
下标可以设定为读写或只读。这种行为由 getter 和 setter 实现，如只有只读属性，可省略只读get关键字

```
extension String {
    subscript(i: Int) -> String? {
        get {
            guard i >= 0 && i < characters.count        
            else {
                return nil
            }
            return String(self[index(startIndex,  
            offsetBy: i)])
        }

        set (newValue) {
            if let value = newValue, i >= 0 && i <
            characters.count {
                replaceSubrange(index(startIndex,
                offsetBy: i)...index(startIndex,
                offsetBy: i), with: value)
            }
        }
    }
}
```

> var string:String = "0987654321"
> string[2]   //"8"
> string[3] = "A" //"098A654321"

- **自定义运算符**

	新的运算符声明需在全局域使用`operator`关键字声明，可  以声明为前缀，中缀或后缀的，分别用`prefix`、`infix`和`postfix`修饰。
运算符定义格式如下，优先级组决定它的优先级和结合性，优先级组可省略，若没指定优先级组则其属于 DefaultPrecedence，这个组的优先级仅高于三目运算符，且没有结合性，即它不能和同组运算符写在一起。结合性默认为left

```
precedencegroup Equivalence {
    associativity: left //结合性
    higherThan: AdditionPrecedence //优先级
    lowerThan: MultiplicationPrecedence
}
infix operator ~ : Equivalence
func ~(left:Int,right:Int) -> Int {
    return left * right
}

1 + 2 ~ 3    // 7
1 * 2 ~ 3    // 6
1 < 2 ~ 3    // true

```

- **as?**

	as? 类型转换时使用，如果转换不成功的时候便会返回一个 nil 对象。成功的话返回可选类型值（optional），需要我们拆包使用。如果不能确保100%能成功的转换则可使用 as?

```
class Animal {}
class Cat:Animal {}

let animal:Animal = Cat()
if let cat = animal as? Cat{
    print("cat is not nil")
} else {
    print("cat is nil")
}
```

了解这几个知识点后，再去看`ObjectMapper`源码就很简单了，按调用顺序简单说下

1. Mapper初始化函数
初始化函数很多， 可支持多种格式数据的解析，本文主要分析传入`[String: Any]`格式数据
> public func map(JSONObject: Any?) -> N?
> public func map(JSON: [String: Any]) -> N?
> public func mapArray(JSONString: String) -> [N]?
> ....

2. model的`func mapping(map: Map)`函数
3. [] subscript下标函数，取出当前key对应的值
4. <- 自定义运算函数
5. `FromJSON`的`class func basicType<FieldType>(_ field: inout FieldType, object: FieldType?) `函数(其他属性(?,!)调用对应函数)，通过传入的值即可确认 `FieldType`类型
6. `Map`的`public func value<T>() -> T?`函数，此处通过**as?**来确认最终value

参考链接：
[Improved operator declarations](https://github.com/apple/swift-evolution/blob/master/proposals/0077-operator-precedence.md#improved-operator-declarations)
