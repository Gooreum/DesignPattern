## 6.커맨드 패턴
### 핵심

- **메소드 호출을 캡슐화**하여 인보커와 리시버를 분리시켜, 인보커(리모컨 같이 계산하는 코드를 호출한 객체)는 자신이 구체적으로 어떤 작업을 하는지에 대해 전혀 신경쓰지 않도록 하는 것이 핵심입니다.

![스크린샷 2021-11-09 오후 8 47 15](https://user-images.githubusercontent.com/48742165/140918733-48a6c16f-a901-499d-9674-f5463f610cd2.png)



### 커맨드 패턴 정의

>
> 💡 커맨드 패턴을 이용하면 요구사항을 객체로 캡슐화 할 수 있으며, 매개변수를 써서 여러 가지 다른 요구사항을 집어넣을 수도 있습니다. 
>    또한 요청 내역을 큐에 저장하거나 로그로 기록할 수도 있으며, 작업 취소 기능도 지원 가능합니다.
> 


### 리모컨 API 제작

- TV, 전등 등과 같은 가전제품을 on/off 할 수 있는 리모컨 API를 커맨드 패턴을 활용하여 만들어 봅시다.
- 커맨드 패턴을 활용하기 위해 크게 4가지 주체가 필요합니다.
    - 클라이언트:  리모컨을 호출하는 주체
    - 인보커: 클라이언트와 리시버 사이의 매개체
    - 커맨드: 리시버를 가지고 있으며, 리시버가 어떤 작업을 진행해야 하는지를 명령하는 주체
        - 커맨드 인터페이스 - 커맨드 구체 클래스 구조로 이루어져 있습니다.
    - 리시버: 리모컨의 명령을 받아 실제 작업을 진행하는 TV, 전등과 같은 가전제품에 해당하는 주체

### 코드로 살펴봅시다

**1.Command 인터페이스 만들기**

```swift
protocol Command {
    func execute()
}
```

- 커맨드가 해야할 일은 execute() 기능밖에 없습니다.
- 단지 어떤 일을 실행하기만 하면 되는 역할이죠.

**2.전등을 켜기 위한 커맨드 클래스 구현**

```swift

public class Light {
    public func on() { print("Light On") }
    public func off() { print("Light Off") }
}

//1
public class LightOnCommand: Command {
        //2
    let light: Light
    init(light: Light) {
        self.light = light
    }
        //3
    public func execute() {
        light.on()
    }
}
```

- `주석 1` : 우리가 만들어야 할 리모컨은 전등을 On 할수 있어야 하므로, 클라이언트가 리모컨을 눌렀을때 전등을 on하라는 명령을 내릴 Command 인터페이스를 구현하는 LightOnCommand를 정의해주어야 합니다.
- `주석 2` : 앞서 커맨드는 리시버(전등)을 알아야 된다고 했으므로, LightOnCommand에서는 전등을 가지고 있어야 합니다.
- `주석 3`: LightOnCommand는 구체 클래스이므로 execute()에서 전등을 on 하라는 명령을 수행합니다.

**3.커맨드 객체 사용하기**

```swift
public class SimpleRemoteControl {
        //1
    var slot: Command?
    //2
    func setCommand(command: Command) {
        slot = command
    }
    //3
    func buttonWasPressed() {
        slot?.execute()
    }
}
```

- 인보커 역할을 하는 리모컨 클래스입니다. 아래 세가지 내용을 가지고 있어야 합니다.
- `주석 1` : 인보커인 리모컨은 커맨드를 통해 리시버와 통신하기 때문에 커맨드 인스턴스 변수를 가지고 있어야 합니다. 다만, 구체 커맨드 클래스를 가지는 것이 아니라 Command 인터페이스를 의존하고 사용하여 의존성 역전이 이루어진 구조이어야 합니다.
- `주석 2` : 외부에서 구체 커맨드 클래스를 주입해주기 위한 메소드가 필요합니다. 이를 통해 인보커는 단순히 무언가를 execute() 하는 역할만 하고, 자신이 구체적으로 어떤 작업을 하는지에 대해 전혀 신경쓰지 않을 수 있습니다.
- `주석 3` : 실행 명령을 내립니다.

**4.리모콘을 사용해봅시다**

```swift
let remote = SimpleRemoteControl()
let light = Light()
let lightOn = LightOnCommand(light: light)

remote.setCommand(command: lightOn)
remote.buttonWasPressed()

---result---
Light On
```

- 클라이언트는 메인 함수가 되겠습니다.
- 인보커는 `remote` 상수가 되겠습니다.
- 커맨드는 `lightOn` 상수가 되겠습니다.
- 리시버는 `light` 상수가 되겠습니다.
- 인보커 클래스 내부에는 command 인터페이스를 가지고 있기 때문에 외부에서 `remote.setCommand()`를 통해 command 구체 클래스를 주입해줍니다.
- `remote`는 이제 `lightOn`이라는 구체 커맨드 클래스에서 구현하고 있는 `execute()`를 통해 전등을 on 시킬 수 있습니다.
