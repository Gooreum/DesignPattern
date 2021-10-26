# 2.옵저버 패턴

객체간의 일대다 관계, 느슨한 결합이 핵심.

### **기상 모니터링 애플리케이션을 만들자**

- 클라이언트에게 WeatherData 객체를 사용하여 현재 조건, 기상 통계, 기상 예측, 이렇게 세 항목을 디스플레이 장비에서 갱신해 가면서 보여주는 애플리케이션을 만들어달라는 요구사항을 받았습니다.

### **어떻게 만들 것인가?**

- 디자인 패턴은 처음부터 만들어진 것이 아닙니다. 반복되는 문제를 패턴화 시켜 해결해 나가는 노력의 산물입니다.
- 그럼 옵저버 패턴은 어떤 문제를 해결하고자 한 것일까요?

### **옵저버 패턴을 사용하지 않고 만들어 봅시다**

```swift
public class WeatherData { 
    //인스턴스 변수 선언
    let currentConditionsDisplay: UIView
    let statisticsDisplay: UIView
    let forecastDisplay: UIView

    init(currentConditionsDisplay: CurrentConditionsDisplay, statisticsDisplay: StatisticsDisplay, forecastDisplay: ForecastDisplay ) { 
        self.currentConditionsDisplay = currentConditionsDisplay
        self.statisticsDisplay = statisticsDisplay
        self.forecastDisplay = forecastDisplay
    }

    //기상 스테이션이 WeatherData에게 값 변경을 알려줄 때 사용되는 메서드
    public func measurementsChanged() { 
        let temp: Float = getTemperature()
        let humidity: Float = getHumidity()
        let pressure: Float = getPressure() 
    
        //1
        currentConditionsDisplay.update(temp, humidity, pressure)
        statisticsDisplay.update(temp, humidity, pressure)
        forecastDisplay.update(temp, humidity, pressure)
    }
}
```

- WeatherData는 세개의 View(디스플레이)를 가지고 있습니다.
- 기상스테이션은 변경된 값을 `WeatherData`에게 `measurementsChanged()` 메서드를 이용해서 전달합니다.
- `measurementsChanged()` 메서드가 호출되면 WeatherData는 내부에 생성된 세가지 View에게 값을 update할 것을 명령합니다.

**문제점**

- 1의 내용들은 구체적인 구현에 맞춰서 코딩했기 때문에 프로그램을 고치지 않고는 다른 디스플레이 항목을 추가/제거할 수 없습니다.
- 1장에서 소개된 세가지 디자인 원칙 모두에 위배됩니다.
    - 1의 내용들은 충분히 바뀔 수 있는 것들입니다. 1장에서 쉽게 바뀔 수 있는 부분들은 따로 빼서 캡슐화 시켜 구성해줘야 한다는 디자인 원칙에 위배됩니다.

### **옵저버 패턴이란**

옵저버 패턴에서는 한 객체의 상태가 바뀌면 그 객체에 의존하는 다른 객체들한테 연락이 가고 자동으로 내용이 갱신되는 방식으로 일대다(one - to - many)의존성을 정의합니다.

- 옵저버 패턴은 신문사와 (다수의)구독자 관계로 생각해볼 수 있습니다.
    - 신문사는 자신을 구독하고 있는 (다수의)사람들에게만 신문을 전달합니다. 그리고 구독자는 구독을 한 상태이기 때문에 별다른 행동 없이도 집에서 신문을 받아볼 수 있습니다.
    - 구독자가 신문사 구독을 종료하면, 신문사는 더 이상 해당 구독자에게 신문을 전달하지 않습니다.
- 옵저버 패턴은 신문사 비유와 같습니다.
    - 여기서 신문사 = 주제(subject), 구독자 = 옵저버(observer)가 됩니다.
    - 옵저버 객체들은 주제 객체를 구독하고 있으며 주제의 데이터가 바뀌면 갱신 내용을 전달 받습니다.
    - 주제 객체는 일부 데이터를 관리하며 주제의 데이터가 달라지면 옵저버한테 그 소식을 전달하며 해당 데이터들을 오버접들에게 전달합니다.
    - 옵저버가 주제에 대한 구독을 끊으면, 주제는 해당 옵저버에게 어떤 소식과 데이터를 전달하지 않습니다.

### 옵저버 패턴 구현 방법

- 옵저버 패턴 구현은 대부분 주제(Subject) 인터페이스와 옵저버(Observer) 인터페이스가 들어있는 클래스 디자인을 바탕으로 합니다.

![Untitled](2%20%E1%84%8B%E1%85%A9%E1%86%B8%E1%84%8C%E1%85%A5%E1%84%87%E1%85%A5%20%E1%84%91%E1%85%A2%E1%84%90%E1%85%A5%E1%86%AB%2020a35e37963d40c1833176f3a81f5129/Untitled.png)

**Subject 인터페이스** 

- 객체에서 옵저버로 등록하거나 옵저버 목록에서 탈퇴하고 싶을 때 이 인터페이스에 있는 메소드를 사용합니다.

**ConcreteSubject**

- Subject 인터페이스를 구현한 구체 클래스입니다.
- 주제 클래스에서는 등록 및 해지를 위한 메소드 외에 상태가 바뀔때마다 모든 옵저버들에게 연락을 하기 위한 notifyObservers() 메소드도 구현해야 합니다.

**Observer 인터페이스**

- 주제의 상태가 바뀌었을 때 호출되는 update() 메소드 밖에 없습니다.

**ConcreteObserver**

- Observer 인터페이스를 구현한 구체 클래스입니다.
- 각 옵저버는 특정 주제 객체에 등록을 해서 연락을 받을 수 있습니다.

**[Subject]**

```swift
import Foundation

//Subject 인터페이스
protocol Subjectable {
    var observers: [Observable] { get set }
    func registerObserver(observer: Observable)
    func removeObserver(observer: Observable)
    func notifyObservers()
}

//Subject 구현체
class WeatherData: Subjectable {
    var observers: [Observable] = []
    var temperature: Float = 0.0
    var humidity: Float = 0.0
    var pressure: Float = 0.0
    
    func registerObserver(observer: Observable) { observers.append(observer) }
    
    func removeObserver(observer: Observable) {
        if let index = self.observers.firstIndex(where: { $0.id == observer.id }) {
            self.observers.remove(at: index)
        }
    }
    
        func notifyObservers() {
        observers.forEach{
            $0.update(temperature: temperature, humidity: humidity, pressure: pressure)
        }
    }

    func measurementsChanged() {
        notifyObservers()
    }
    
    func setMeasurements(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        measurementsChanged()
    }
    
    deinit { observers.removeAll() }
}
```

**[Observer]**

```swift
//Observer 인터페이스
protocol Observable {
    var id: String { get set }
    func update(temperature: Float, humidity: Float, pressure: Float)
}

//Observer 구현체 - 현재 조건 Display
class CurrentCondtionsDisplay: Observable  {
    var id: String
    let subject: Subjectable
    private var temperature: Float = 0.0
    private var humidity: Float = 0.0
    private var pressure: Float = 0.0
    init(id: String, subject: Subjectable) {
        self.id = id
        self.subject = subject
        subject.registerObserver(observer: self)
    }
    func update(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        display()
    }
    func display() {
        print("Current conditions: \(temperature) F degrees and humidity \(humidity) ")
    }

    deinit { subject.removeObserver(observer: self) }
}

//Observer 구현체 - 기상 통계 display
class StatisticsDisplay: Observable  {
    var id: String
    let subject: Subjectable
    private var temperature: Float = 0.0
    private var humidity: Float = 0.0
    private var pressure: Float = 0.0
    init(id: String, subject: Subjectable) {
        self.id = id
        self.subject = subject
        subject.registerObserver(observer: self)
    }
    func update(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        display()
    }
    func display() {
        print("Statistics : \(temperature) F degrees and humidity \(humidity) ")
    }

    deinit { subject.removeObserver(observer: self) }
}

//Observer 구현체 - 기상예측 display
class ForecastDisplay: Observable  {
    var id: String
    let subject: Subjectable
    private var temperature: Float = 0.0
    private var humidity: Float = 0.0
    private var pressure: Float = 0.0
    init(id: String, subject: Subjectable) {
        self.id = id
        self.subject = subject
        subject.registerObserver(observer: self)
    }
    func update(temperature: Float, humidity: Float, pressure: Float) {
        self.temperature = temperature
        self.humidity = humidity
        self.pressure = pressure
        display()
    }
    func display() {
        print("Forecast : \(temperature) F degrees and humidity \(humidity) ")
    }
    
    deinit { subject.removeObserver(observer: self) }
}

//Main
let weatherData = WeatherData()
let currentCondtionsDisplay = CurrentCondtionsDisplay(id: "CurrentCondtionsDisplay", subject: weatherData)
let statisticsDisplay = StatisticsDisplay(id: "StatisticsDisplay", subject: weatherData)
let forecastDisplay = ForecastDisplay(id: "ForecastDisplay", subject: weatherData)
subject.setMeasurements(temperature: 56.1, humidity: 27.3, pressure: 22.1)
```

**[Result]**

```swift
---결과----
Current conditions: 56.1 F degrees and humidity 27.3 
Statistics : 56.1 F degrees and humidity 27.3 
Forecast : 56.1 F degrees and humidity 27.3
```

### 느슨한 결합(Loose Coupling)의 위력

**디자인 원칙**

서로 상호작용을 하는 객체 사이에서는 가능하면 느슨하게 결합하는 디자인을 사용해야 한다.

- 두 객체가 느슨하게 결합되어 있다는 것은, 그 둘이 상호작용을 하긴 하지만 서로에 대해 서로 잘 모른다는 것을 의미합니다.
- Subject는 상태변경시 Observer에게 상태 변경 및 데이터 전달을 위해 Observer를 알고 있어야 합니다.
- 그렇지만 다이어그램에서 볼수 있듯이 ConcreteSubject는 어떠한 ConcreteObserver에 의존하지 않습니다. 다만 ConcreteSubject는 Observer 인터페이스만을 참조할 뿐입니다.
- 따라서 Observer 인터페이스를 구현한 어떠한 구체 클래스든 Subject의 registerObserver() 메서드를 통해 observer를 등록할 수 있습니다. 이것은 앞장에서 살펴 보았던 구성(composition) 방식입니다.
    - WeatherData를 Subject를 구현한 구체 클래스로 만들고, 3가지 dispay를 Observer를 구현한 구체 클래스로 만들어 WeatherData에 등록해준다면 앞서 살펴 보았던 display추가/제거 문제점을 해결할 수 있습니다.
    - Subject에서 직접 display를 생성하는 것이 아니라, display에서 등록을 해주기 때문입니다.
- ConcreteSubject에서는 ConcreteObserver에 대한 참조가 없기 때문에 observer가 무엇을 하든 신경쓰지 않아도 됩니다. 단순히 등록된 Observer 인터페이스 타입의 리스트만을 이용하여 자신이 할 일만 하면 됩니다.
- 위 다이어그램에서 ConcreteObserver는 ConcreteSubject에 대한 직접적인 참조를 하고 있습니다.
    - 이를 보다 느슨하게 결합하기 위해서는 Subject 인터페이스를 참조하게 하고 ConcreteObserver 생성시 ConcreteSubject를 주입해주는 방식을 채택하면 됩니다.
