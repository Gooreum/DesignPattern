## 7.1 어댑터 패턴
### 어댑터 패턴 목적
- 어떤 클래스의 인터페이스를 클라이언트에서 원하는 인터페이스로 변환하는 방법을 제공합니다.
- 클라이언트 코드와 호환이 안되던 클래스의 인터페이스를 클라이언트가 원하는 인터페이스로 전환하여 `클라이언트 코드 수정 없이` 기존에 호환 안되던 클래스를 어댑터를 통해 클라이언트가 사용할 수 있도록 합니다.<br/><br/>

### 어댑터 패턴 정의
>
>💡 한 클래스의 인터페이스를 클라이언트에서 사용하고자 하는 다른 인터페이스로 변환합니다. 
>어댑터를 이용하면 인터페이스 호환성 문제 때문에 같이 쓸 수 없는 클래스들을 연결해서 쓸 수 있습니다.
>
<br/><br/>

### 어댑터 현실예제
- 한국은 220V를 사용하지만 유럽 많은 지역은 110V를 사용합니다. 그런 경우 핸드폰 충전을 할 수 없기 때문에 220V 플러그를 110V 전원 소켓에서 사용할 수 있도록 해주는 '**어댑터**'가 필요합니다.
- 객체지향에서의 어댑터 역할도 이와 똑같습니다.
- 어떤 인터페이스를 클라이언트에서 요구하는 형태의 인터페이스에 적응시켜주는 역할을 하죠.<br/><br/>

### 어댑터 패턴 구현방법
![어댑터](https://user-images.githubusercontent.com/48742165/141969619-53089956-bd61-488f-ae7a-466a75720567.png)

1. 클라이언트에서 타겟 인터페이스를 사용하여 메소드를 호출함으로써 어댑터에 요청을 합니다.
2. 어댑터에서는 어댑티 인터페이스를 사용하여 그 요청을 어댑터에 대한 (하나 이상의) 메소드 호출로 변환합니다.
3. 클라이언트에서는 호출 결과를 받긴 하지만 중간에 어댑터가 껴 있는지는 전혀 알지 못합니다. <br/><br/>

### 간단한 예제코드
```swift
protocol Duckable {
    func quack()
    func fly()
}

protocol Turkeyable {
    func gobble()
    func fly()
}

class Client {
    func testDuck(duck: Duckable) {
        duck.quack()
        duck.fly()
    }
}

class MallardDuck: Duckable {
    func quack() {
        print("꿱꿱")
    }
    func fly() {
        print("날고 있어요.")
    }
}

class WildTurkey: Turkeyable {
    func gobble() {
        print("고블 고블")
    }
    func fly() {
        print("짧게 날고 있어요")
    }
}

class TurkeyAdapter: Duckable {
    let turkey: Turkeyable
    
    init(turkey: Turkeyable) {
        self.turkey = turkey
    }
    
    func quack() {
        turkey.gobble()
    }
    func fly() {
        turkey.fly()
    }
}

let client = Client()
let duck = MallardDuck()
let turkey = WildTurkey()
let turkeyAdapter = TurkeyAdapter(turkey: turkey)

print("터키가 말하기를 ...")
turkey.gobble()
turkey.fly()

print("오리가 말하기를...")
client.testDuck(duck: duck)

print("터키 어뎁터가 말하기를 ...")
client.testDuck(duck: turkeyAdapter)
```

- `클라이언트`(Client)에서 `타겟 인터페이스`(Duckable)를 사용하여 메소드를 호출함으로써 `어댑터`(TurkeyAdapter)에 요청을 합니다.
- `어댑터`(TurkeyAdapter)에서는 `어댑티 인터페이스`(Turkeyable)를 사용하여 그 요청을 `어댑터`(TurkeyAdapter)에 대한 (하나 이상의) 메소드 호출로 변환합니다.
- `클라이언트`(Client)에서는 호출 결과를 받긴 하지만 중간에 어댑터가 껴 있는지는 전혀 알지 못합니다.<br/><br/>

### 어댑터 패턴 장단점
**장점**

- 기존의 코드를 재활용 할 수 있으며, 기존 class의 수정이 아니고 Adapter를 통한 확장의 개념이므로 OCP를 위배하지 않아 코드의 유지보수가 용이합니다.
- 인터페이스가 바뀌더라도 그 변경 내역은 어댑터에 캡슐화되기 때문에 클라이언트는 바뀔 필요가 없습니다.

**단점**

- 기존의 class를 이용해서 새로운 인터페이스를 구현하는 Adapter 클래스를 만드는 것이기 때문에, 기존의 클래스가 어느정도 새로운 인터페이스와 연관이 있어야 어댑터 패턴을 구현 하는게 의미가 있습니다.
- 즉, 추상적인 관점에서 신규 인터페이스와 하는 일이 비슷하나 인터페이스의 정의가 달라서 사용하지 못하는 라이브러리의 경우만 어댑터 패턴을 적용하는 것이 의미가 있습니다.


