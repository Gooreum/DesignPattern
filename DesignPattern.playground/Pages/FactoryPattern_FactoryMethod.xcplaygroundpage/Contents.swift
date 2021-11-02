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
    func cut() { print("Cutting the pizza into diagonal slices")}
    func box() { print("Place pizza in official pizzastore box")}
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
    func createPizza(type: PizzaType) -> Pizza
}

extension PizzaStore {
    func orderPizza(type: PizzaType) -> Pizza {
        let pizza = createPizza(type: type)
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
            return NYStyleCheesePizza()
        case .Photato :
            return NYStyleCheesePizza()
        }
    }
}

let nyStore = NYPizzaStore()
let pizza = nyStore.orderPizza(type: PizzaType.Cheese)
print("Ethan ordered a \(pizza.getName())")
