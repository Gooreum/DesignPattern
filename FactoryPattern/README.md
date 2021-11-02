## 4.팩토리 패턴
객체의 인스턴스 생성 작업을 외부에 위임하여 슈퍼클래스의 불필요한 의존성을 없앤다. 

### 바뀌는 부분 찾기

- 피자 가게에서 피자를 만들기 위해선 크게 3가지가 필요합니다.
    - `orderPizza()`: 고객이 피자를 주문할 수 있어야 합니다.
    - `createPizza()` : 피자가게는 주문받은 피자를 만들 수 있어야 합니다.
    - `Pizza` : 주문과 생성 과정후 고객에게 전달될 최종 결과물인 피자가 필요합니다.
- 위 내용을 코드로 작성해보면 아래와 같습니다.
    
    ```swift
    public class PizzaStore {         
            func orderPizza(type: String) -> Pizza { 
                var pizza: Pizza
                switch(type) {
                    case .cheese : 
                        pizza = CheesePizza()
                    case .greek: 
                        pizza = GreekPizza()
                    }
                pizza.prepare()
                pizza.bake()
                pizza.cut()
                pizza.box()
                return pizza
            }
    }
    ```
    
- `orderPizza()` 메서드의 문제
    
    **의존성 문제**
    
    - PizzaStore 클래스 안에 N개의 피자 구상클래스를 의존하고 있습니다.
        - 의존성 문제는 조금 있다가 다시 살펴보도록 하겠습니다.
    
    **바뀌는 부분 존재**
    
    - 피자를 추가할 경우 매번 switch(type) 블록 안에 피자 구상클래스 생성하는 코드를 추가해줘야 합니다.
    - orderPizza() 메서드에서는 상황에 따라 필요한 인스턴스를 만들 구상 클래스가 변동될 수 있기 때문에그럴때마다 코드 추가 및 수정작업이 매번 이루어져야 할 것입니다.
    - 그렇다면 어떤 부분이 바뀌는지를 확인했으니 캡슐화를 해보도록 하겠습니다.

### 간단한 팩토리 만들기

- 객체 생성을 처리하는 클래스를 **팩토리**라고 부릅니다.
    
    (아래 살펴볼 SimplePIzzaFactory같이 간단한 팩토리(Simple Factory)는 디자인 패턴이라고 할 수는 없다)
    
- orderPizza() 메서드의 객체 생성 코드만 따로 빼서 피자 객체를 만드는 일만 전담하는 `SimplePizzaFactory` 클래스를 생성합니다.
    - orderPizza() 메소드에선 더이상 어떤 피자를 만들어야 하는지 고민하지 않아도 됩니다.
    - 이로써 orderPizza() 메소드 내의 바뀌는 부분을 분리 및 캡슐화 처리하게 되었습니다.
    
    ```swift
    public class PizzaStore {         
            let pizzaFactory: SimplePizzaFactory
            init(pizzaFactory: SimplePizzaFactory) { 
                self.pizzaFactory = pizzaFactory    
            }
            
            func orderPizza(type: String) -> Pizza { 
                let pizza = pizzaFactory.createPizza(type)
                pizza.prepare()
                pizza.bake()
                pizza.cut()
                pizza.box()
                return pizza
            }
    }
    
    public class SimplePizzaFactory { 
            public createPizza(type: String) { 
                var pizza: Pizza
                switch(type) {
                    case .cheese : 
                        pizza = CheesePizza()
                    case .greek: 
                        pizza = GreekPizza()
                    }
                return pizza
            }
    }
    ```
    

### 간단한 팩토리 → 팩토리 메서드 선언

- PizzaStore가 번창하여 NewYorkPizzaStore, ChicagoPizzaStore 등등의 분점이 생긴다면  각 분점의 특색에 맞는 피자를 만들 PizzaFactory가 필요해집니다.
- 또한 PizzaStore의 모든 분점들은 피자 퀄리티 보장을 위한 '**피자 만드는 활동**'(pizza.prepare() pizza.bake() pizza.cut() pizza.box())을 통일해야 합니다.
    
    ```swift
    import Foundation
    
    enum PizzaType: String {
        case Cheese = "Cheese"
        case Bakon = "Bakon"
        case Photato = "Photato"
    }
    
    protocol Pizza {
        var name: String {get set}
        var dough: String {get set}
        var sauce: String {get set}
        var toppings: [String] {get set}
        
        func prepare()
        func bake()
        func cut()
        func box()
        func getName() -> String
    }
    
    extension Pizza {
        func prepare() {
            print("Preparing " + name)
            print("Tossing dough...")
            print("Adding Sauce...")
            print("Adding toppings: ")
            for i in 0..<toppings.count {
                print("   " + toppings[i])
            }
        }
        func bake() { print("Bake for 25 minutes at 350") }
        func cut() { print("Cutting the pizza into diagonal slices") }
        func box() { print("Place pizza in official pizzastore box") }
        func getName() -> String { name }
    }
    
    public class NYStyleCheesePizza: Pizza {
        var name: String
        var dough: String
        var sauce: String
        var toppings: [String] = []
        
        init() {
            name = "NY Style Sauce and Cheese Pizza"
            dough = "Thin Crust Dough"
            sauce = "Mariana Sauce"
            toppings.append("Grated REggiano Cheese")
        }
    }
    
    protocol PizzaStore {
            //각 분점의 특성에 맞는 피자 생성은 PizzaStore를 구현하는 클래스에서 담당하게 됩니다.
        **func createPizza(type: PizzaType) -> Pizza**
    }
    
    extension PizzaStore {
        func orderPizza(type: PizzaType) -> Pizza {
            let pizza = createPizza(type: type)
                    //피자 만드는 활동(준비, 굽기, 자르기, 포장)
            pizza.prepare()
            pizza.bake()
            pizza.cut()
            pizza.box()
            return pizza
        }
    }
    
    class NYPizzaStore: PizzaStore {
        func createPizza(type: PizzaType) -> Pizza {
            switch(type) {
            case .Cheese :
                return NYStyleCheesePizza()
            case .Bakon :
                return NYStyleBakonPizza()
            case .Photato :
                return NYStylePhotatoPizza()
            }
        }
    }
    
    **//Main**
    let nyStore = NYPizzaStore()
    let pizza = nyStore.orderPizza(type: PizzaType.Cheese)
    print("Ethan ordered a \(pizza.getName())")
    
    **//result**
    Preparing NY Style Sauce and Cheese Pizza
    Tossing dough...
    Adding Sauce...
    Adding toppings: 
       Grated REggiano Cheese
    Bake for 25 minutes at 350
    Cutting the pizza into diagonal slices
    Place pizza in official pizzastore box
    Ethan ordered a NY Style Sauce and Cheese Pizza
    ```
    
    - 기존 PizzaStore 클래스를 프로토콜 타입으로 변경합니다.
    - `SimplePizzaFactory` 에 있던 createPizza() 메서드를  `PizzaStore` 프로토콜에서 선언만 합니다.
    - 이제 `createPizza()` 메서드는 PizzaStore 구현 클래스에서 각 지역마다 고유의 스타일에 맞게 만들도록 할 것입니다.
    - PizzaStore는 orderPizza()에서 어떤 종류의 피자를 만드는지 전혀 알수 없기 때문에 단지 피자를 준비하고 굽고 자르고 포장하는 작업을 처리하게 됩니다. 즉 어떤 지점에서든 피자 만드는 활동 과정의 통일성이 보장됩니다.
- **간단한 팩토리 만들기와의 차이점**
    - PizzaStore에서 필요한 객체 생성을 SimpleFactoryClass로 캡슐화 시켜 위임하는 것이 아니라, PizzaStore 내부에서 createPizza() 메서드를 선언하고 실제 객체 구현은 자신을 구현하는 구체 클래스에게 위임하여 캡슐화 시킵니다.
    - 이렇게 하면 여러 팩토리가 필요한 경우 훨씬 유연하게 대응할 수 있습니다. PizzaStore의 OCP가 훨씬 쉬워지겠쬬.

### **팩토리 메소드 패턴 정의**

- 위에서 살펴본 팩토리 메소드 패턴을 정리하자면 아래와 같습니다.

팩토리 메소드 패턴에서는 객체를 생성하기 위한 인터페이스를 정의하는데, 어떤 클래스의 인스턴스를 만들지는 서브클래스에서 결정하게 한다.
팩토리 메소드 패턴을 이용하면 클래스의 인스턴스를 만드는 일을 서브클래스에게 맡기는 것이다.

### 의존성 역전 원칙(Dependency Inversion Principle)

> 📘 Note
> 
> 추상화된 것에 의존하도록 만들어라. 
> 구상 클래스에 의존하도록 만들지 않도록 한다.
>

- 처음 PizzaStore와 Pizza 관계를 다이어그램으로 보면 고수준 구성요소인 PizzaStore가 저수준 구성요소 NYCheeseStylePizza를 향해 아래로 향하는 의존성 방향이 생겼습니다.
- 그런데 PizzaStore가 Pizza 인터페이스를 향해 의존하게 함으로써 의존방향이 아래보다 위로 향하게 됩니다. 이러한 방향의 변화를 보면 왜 의존성이 역전되었다고 말하는지 이해할 수 있을것 같습니다. (물론 NYCheeseStylePizza는 Pizza를 구현하는 구상 클래스이어야 합니다.)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/465ee1b7-1239-4222-90b5-ae3192012f92/Untitled.png)

- 또한 제일 처음 작성한 PizzaStore 코드에 의존성 문제가 있다고 언급했습니다.
- 의존성 역전 원칙에 따르면 고수준 구성요소인 PizzaStore는 저수준 구성요소인 NYCheesStylePizza에 의존해서는 안됩니다. 그런데 처음 PizzaStore는 이러한 원칙에 완전히 위배된 코드입니다.
- Pizza가 인터페이스라 하더라도 PizzaStore가 피자 구상 클래스를 직접 의존하기 때문에 추상화를 사용한 이점이 없습니다. 즉, 피자를 추가 및 수정하기 위해 항상 PizzaStore 코드를 수정해야하는 확장에는 닫혀있어 반드시 변경해야만 하는 구조가 되어버립니다.

### **의존성 역전 원칙 가이드라인**

- 어떤 변수에도 구상 클래스에 대한 레퍼런스를 저장하지 않습니다.
- 구상 클래스에서 유도된 클래스를 만들지 않습니다.
- 베이스 클래스에 이미 구현되어 있던 메소드를 오버라이드하지 않습니다.
    - 오버라이드 한다는 것 자체가 이미 추상화가 제대로 이루어져 있지 않다는 뜻이기 때문입니다.

### **추상 팩토리**

> 📘 Note
> 
> 추상 팩토리 패턴에서는 인터페이스를 이용하여 서로 연관된, 또는 의존하는 객체를 구상 클래스를 지정하지 않고도 생성할 수 있습니다.
> 

- 지금까지 Pizza의 dough, sauce, topping 들과 같은 원재료들은 PizzaStore의 분점들에서 직접 생산했습니다. PizzaStore에서는 원재료들 까지도 본점에서 직접 생산하여 분점들에게 전달 하고 싶어합니다.
    - 원재료를 생산하는 추상 팩토리를 생성합니다. 각 피자가게 지점들에서 직접 생성했던 재료들과의 결합을 분리시켜주기 위한 작업입니다.
