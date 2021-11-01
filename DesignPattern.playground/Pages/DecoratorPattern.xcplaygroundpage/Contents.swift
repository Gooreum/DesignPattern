import Foundation

protocol Beverage {
    var description: String { get }
    func getDescription() -> String
    func cost() -> Double
}

protocol CondimentDecorator: Beverage {
    func getDescription() -> String
}

struct HouseBlend: Beverage {
    internal var description: String
    init() { self.description = "HouseBlend" }
    func getDescription() -> String { description }
    func cost() -> Double { 0.99 }
}

struct Mocha: CondimentDecorator {
    internal let beverage: Beverage
    internal var description: String = "Mocha"
    init(beverage: Beverage) { self.beverage = beverage }
    func getDescription() -> String { beverage.getDescription() + " +Mocha" }
    func cost() -> Double { 0.20 + beverage.cost() }
}

struct Whip: CondimentDecorator {
    internal let beverage: Beverage
    internal var description: String = "Whip"
    init(beverage: Beverage) { self.beverage = beverage }
    func getDescription() -> String { beverage.getDescription() + " +Whip" }
    func cost() -> Double { 0.05 + beverage.cost() }
}

let houseBlend = HouseBlend()
let mocha = Mocha(beverage: houseBlend)
let whip = Whip(beverage: mocha)
let whip2 = Whip(beverage: whip)
print("\(whip2.getDescription())" + " $\(whip2.cost())")

