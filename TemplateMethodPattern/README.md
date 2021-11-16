## 8.템플릿 메소드 패턴
### 템플릿 메소드 목적

- 템플릿 메소드의 목적은 고수준 요소에서 메소드 안에 공통 알고리즘을 만들어 코드의 재사용성을 높이는 것입니다.<br/><br/>

### 템플릿 메소드 패턴 정의

>
>💡 메소드에서 알고리즘의 골격을 정의합니다.
> 알고리즘의 여러 단계 중 일부는 서브클래스에서 구현할 수 있습니다.
> 템플릿 메소드를 이용하면 알고리즘의 구조는 그대로 유지하면서 서브클래스에서 특정 단계를 재정의 할 수 있습니다.
>

- 템플릿 메소드는 알고리즘의 틀을 만들기 위한 것입니다.
- 틀(템플릿)이란 단순히 메소드에 불과하지만 일련의 단계들로 알고리즘을 정의한 메소드입니다.
- 여러 단계 가운데 하나 이상이 추상 메소드로 정의되며, 그 추상 메소드는 서브클래스에서 구현됩니다.
- 이렇게 하면 서브클래스에서 일부분을 구현할 수 있도록 하면서도 알고리즘의 구조는 바뀌지 않아도 되도록 할 수 있습니다.

![템플릿](https://user-images.githubusercontent.com/48742165/141970169-fe2c888e-157b-44da-8354-ab79bcfcf94c.png)

<br/>

### 템플릿 메소드 코드구현

```swift
//1
protocol CaffeineBeverage {
    func prepareRecipe()
    func brew()
    func addCondiments()
}
//2
extension CaffeineBeverage {
    func prepareRecipe() {
        boilWater()
        brew()
        pourInCup()
        addCondiments()
    }
    func boilWater() {
        print("물을 끓입니다.")
    }
    func pourInCup() {
        print("컵에 따릅니다.")
    }
}
//3
class Coffee: CaffeineBeverage {
    func brew() {
        print("커피를 우렵냅니다.")
    }
    func addCondiments() {
        print("우유를 추가합니다.")
    }
}

let coffee = Coffee()
coffee.prepareRecipe()

---result---
물을 끓입니다.
커피를 우렵냅니다.
컵에 따릅니다.
우유를 추가합니다.
```

- 책에서는 추상클래스를 이용한 예제를 보여주지만, Swift 특성상 추상클래스가 없으므로 Protocol을 이용하여 구현해보았습니다.
- `주석1`
    - `CaffeineBeverage` 프로토콜을 채택한 타입들이 `prepareRecipe()`, `brew()`, `addCondiments()`를 구현할 수 있도록 강제합니다.
    - `prepareRecipe()`는 음료를 생성하도록 하는 **템플릿 메서드** 입니다.
    - `brew()`는 무언가를 우려내는 기능을 하는 메서드로써, 음료 특성상 다양한 종류의 추출물을 낼 수 있기 때문에 `CaffeineBeverage`를 채택하는 타입의 특성에 따라 구현할 수 있도록 하기 위해 선언만 해놓습니다.
    - `addCondiments()`도 `brew()`와 마찬가지로 음료 특성상 다양한 첨가물이 추가될 수 있기 때문에 `CaffeineBeverage`를 채택하는 타입이 스스로 결정하도록 선언만 해놓습니다.
- `주석2`
    - `extension`을 통해 프로토콜울  확장하면 구체 메서드를 작성할 수 있습니다.
    - 템플릿 메서드를 구현하기 위해 `CaffeineBeverage`를 extension 하였습니다.
    - `CaffeineBeverage`의 `prepareRecipe()`를 사용하게 되면 해당 메서드에 정의된 과정에 따라 음료를 제조할 수 있게 됩니다.
    - `boilWater()`, `pourInCup()` 은 음료 제조시 공통적으로 진행되는 과정이므로 `CaffeineBeverage` 프로토콜에서 구체 메서드로 생성해줍니다.
- `주석3`
    - 템플릿 메소드 패턴 정의에 따르면 '*알고리즘의 구조는 그대로 유지하면서 **서브클래스에서 특정 단계를 재정의** 할 수 있습니다.*' 라고 했습니다.
    - brew()와 addCondiments()는 템플릿 메서드인 prepareRecipe()에 들어가는 제조 과정입니다. `CaffeineBeveragef`를 채택하는 타입에 따라 종류가 달라질 수 있으므로, coffee 클래스에서 직접 정의합니다.
