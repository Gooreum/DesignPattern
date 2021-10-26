import Foundation

protocol Subjectable {
    var observers: [Observable] { get set }
    func registerObserver(observer: Observable)
    func removeObserver(observer: Observable)
    func notifyObservers()
}

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
weatherData.setMeasurements(temperature: 56.1, humidity: 27.3, pressure: 22.1)
