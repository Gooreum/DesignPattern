## 3.데코레이터 패턴

이번 장에서는 상속남용 문제를 살펴보고, 런타임에서 객체를 디자인 하는 방법을 살펴봅니다.

### 스타버즈(카페) 음료 상속문제

- 스타버즈에선 음료주문 시스템을 만들고자 합니다. 그런데 사업이 번창할수록 다양한 음료를 만들게 되었습니다.
- 현재 스타버즈는 상속을 이용하여 주문할 수 있는 음료를 관리하고 있습니다.
- 그런데 문제는 서브클래스의 특성이 조금만 달라도 수많은 서브클래스들을 만들어냅니다.
- 핵심은 커피이고, 나머지는 커피 위에 올라가는 장식인데 각각의 경우를 위한 서브클래스들을 만들어 관리하는 것은 매우 비효율적으로 보입니다. 만약 모카가 추가된 HouseBlendWithMocha 메뉴를 판매하지 않느다면 기껏 만들어 놓은 해당 클래스를 삭제해줘야 하는 번거러움이 생기겠죠.
- 그렇다면 HouseBlend 커피만 만들어 놓고, 해당 커피에 올라가는 모카, 우유, 휘핑크림등의 장식을 런타임시 추가 해줄수 있는 방법은 없을까요?

![데코레이터1](https://user-images.githubusercontent.com/48742165/139672109-57eb8650-db67-4651-84d5-3109d86b02fa.png)


### **OCP(Open-Closed Principle)**

> 📘 Note
>  
> 클래스는 확장에 대해서는 열려 있어야 하지만 코드 변경에 대해서는 닫혀 있어야 한다.
>

- OCP는 이미 2장 옵저버 패턴에서 접했습니다.
    - 옵저버를 새로 추가하면 Subject자체에 코드를 추가하지 않으면서도 언제든지 확장할 수 있었죠?
- 그럼 이번장에서 살펴보고 있는 스타버즈의 문제를 다시 정의해봅시다.
    - HouseBlend 클래스의 코드는 추가하지 않으면서 어떻게 HouseBlendWithMocha, HouseBlendWIthSteamedMilkAndMocha, HouseBlendWIthWhip 커피를 만들게 할 것인가? 로 정의해볼 수 있겠네요.

### **데코레이터 패턴**

> 📘 Note
>  
> 데코레이터 패턴에서는 객체에 추가적인 요건을 동적으로 첨가한다.
> 데코레이터는 서브클래스를 만드는 것을 통해서 기능을 유연하게 확장할 수 있는 방법을 제공한다.
> 

- 데코레이터 패턴을 사용한다는 것은 아래의 다이어그램으로 표현해볼 수 있습니다.
    
    ![데코레이터2](https://user-images.githubusercontent.com/48742165/139672138-521d50db-8374-4e89-b66f-9d280fb81c44.png)
    

**Component**

- 앞서 Beverage와 같이 우리가 실제 구현해야 할 객체의 최상위 개념(인터페이스 혹은 추상클래스) 의미합니다.

**ConcreteComponent**

- Component를 상속받은 구체 클래스입니다.
- Beverage를 상속받아 구현한 HouseBlend 클래스에 해당하겠습니다.

**Decorator**

- 드디어 Decorator가 나왔네요.
- Component(Beverage)에서 Mocha, Milk, Whip 등을 장식 개념으로 분리시켜 주기 위한 장식의 최상위 개념(인터페이스 혹은 추상클래스)이라 볼 수 있겠습니다.
- 중요한 것은 Decorator가 Component와 같은 인터페이스 혹은 추상 클래스를 구현 및 상속받아야 한다는 점입니다.

**ConcreteDecorator**

- Decorator를 상속받은 구체 클래스입니다.
- ConcreteDecorator에는 그 객체가 장식하고 있는 것(Decorator가 감싸고 있는 Component 객체)을 위한 인스턴스 변수가 있습니다.
- Decorator는 Component의 상태를 확장할 수 있습니다.
- Decorator에서 새로운 메소드를 추가할 수도 있습니다. 하지만 일반적으로 새로운 메소드를 추가하는 대신 Component에 원래 있던 메소드를 호출하기 전, 또는 후에 별도의 작업을 처리하는 방식으로 새로운 기능을 추가합니다.

### Beverage 클래스를 장식해봅시다.

![데코레이터3](https://user-images.githubusercontent.com/48742165/139672158-9e6a95d2-d85e-447e-888e-737177734ac4.png)

### **코드로 살펴봅시다**

```swift
import Foundation
//Beverage Protocol
protocol Beverage {
    var description: String { get }
    func getDescription() -> String
    func cost() -> Double
}
//Decorator Protocol
protocol CondimentDecorator: Beverage {
    func getDescription() -> String
}
//HouseBlend 커피
struct HouseBlend: Beverage {
    internal var description: String
    init() { self.description = "HouseBlend" }
    func getDescription() -> String { description }
    func cost() -> Double { 0.99 }
}
//모카 장식
struct Mocha: CondimentDecorator {
    internal let beverage: Beverage
    internal var description: String = "Mocha"
    init(beverage: Beverage) { self.beverage = beverage }
    func getDescription() -> String { beverage.getDescription() + " +Mocha" }
    func cost() -> Double { 0.20 + beverage.cost() }
}
//휘핑크림 장식
struct Whip: CondimentDecorator {
    internal let beverage: Beverage
    internal var description: String = "Whip"
    init(beverage: Beverage) { self.beverage = beverage }
    func getDescription() -> String { beverage.getDescription() + " +Whip" }
    func cost() -> Double { 0.05 + beverage.cost() }
}

//Main
let houseBlend = HouseBlend()
let mocha = Mocha(beverage: houseBlend)
let whip = Whip(beverage: mocha)
let whip2 = Whip(beverage: whip)
print("\(whip2.getDescription())" + " $\(whip2.cost())")
```

- 음료와 장식만 구성해놓으면 런타임에서 어떠한 음료와 장식을 조합할 수 있습니다.
