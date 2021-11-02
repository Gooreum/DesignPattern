import Foundation

enum PizzaType: String {
    case Cheese = "Cheese"
    case Bakon = "Bakon"
    case Photato = "Photato"
}


protocol Dough { var ingredient: String {get set} }
protocol Sauce { var ingredient: String {get set} }
protocol Cheese { var ingredient: String {get set} }
protocol Veggies { var ingredient: String {get set} }
protocol Pepperoni { var ingredient: String {get set} }
protocol Clams { var ingredient: String {get set} }

class ThinCrustDough: Dough { var ingredient: String = "ThinCrustDough" }
class MarianaraSauce: Sauce { var ingredient: String = "MarianaraSauce" }
class ReggianoCheese: Cheese { var ingredient: String = "ReggianoCheese" }
class Garlic: Veggies { var ingredient: String = "Garlic" }
class Onion: Veggies { var ingredient: String = "Onion" }
class MushRoom: Veggies { var ingredient: String = "MushRoom" }
class RedPepper: Veggies { var ingredient: String = "RedPepper" }
class SlicedPepperoni: Pepperoni { var ingredient: String = "SlicedPepperoni" }
class FreshClams: Clams { var ingredient: String = "FreshClams" }

protocol PizzaIngredientFactory {
    func createDough() -> Dough
    func createSauce() -> Sauce
    func createCheese() -> Cheese
    func createVeggies() -> [Veggies]
    func createPepperoni() -> Pepperoni
    func createClam() -> Clams
}

public class NYPizzaIngredientFactory: PizzaIngredientFactory {
    func createDough() -> Dough { ThinCrustDough() }
    func createSauce() -> Sauce { MarianaraSauce() }
    func createCheese() -> Cheese { ReggianoCheese() }
    func createVeggies() -> [Veggies] {
        let garlic = Garlic()
        let onion = Onion()
        let mushroom = MushRoom()
        let redpepper = RedPepper()
        let veggies: [Veggies] = [garlic, onion, mushroom, redpepper]
        return veggies
    }
    func createPepperoni() -> Pepperoni { SlicedPepperoni() }
    func createClam() -> Clams { FreshClams() }
}

protocol Pizza {
    var name: String? {get set}
    var dough: Dough? {get set}
    var sauce: Sauce? {get set}
    var cheese: Cheese? {get set}
    var veggies: [Veggies]? {get set}
    var pepperoni: Pepperoni? {get set}
    var clam: Clams? {get set}
    
    func prepare()
    func getName() -> String
}

extension Pizza {
    func bake() { print("Bake for 25 minutes at 350") }
    func cut() { print("Cutting the pizza into diagonal slices")}
    func box() { print("Place pizza in official pizzastore box")}
    mutating func setName(name: String) {
        self.name = name
    }
    func getName() -> String { name! }
    func toString() -> String {
        let doughIngredient = dough?.ingredient ?? "No"
        let cheeseIngredient = cheese?.ingredient ?? "No"
        let pepperoniIngredient = pepperoni?.ingredient ?? "No"
        var veggiesIngredient: String = ""
        if let veggies = veggies {
            veggies.forEach{
                veggiesIngredient += "\($0.ingredient) "
            }
        }
        let clamIngredient = clam?.ingredient ?? "No"
        
        return "Dough-\(doughIngredient), Cheese-\(cheeseIngredient), Veggy-\(veggiesIngredient), Pepperoni-\(pepperoniIngredient), Clam-\(clamIngredient)"
    }
}

class CheesePiza: Pizza {
    var name: String?
    var dough: Dough?
    var sauce: Sauce?
    var cheese: Cheese?
    var veggies: [Veggies]?
    var pepperoni: Pepperoni?
    var clam: Clams?
    
    let ingredientFactory: PizzaIngredientFactory
    
    init(ingredientFactory: PizzaIngredientFactory) {
        self.ingredientFactory = ingredientFactory
    }
    
    func prepare() {
        print("Preparing " + name!)
        dough = ingredientFactory.createDough()
        sauce = ingredientFactory.createSauce()
        cheese = ingredientFactory.createCheese()
        veggies = ingredientFactory.createVeggies()
        
        print("Ingredient: \(toString())")
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
        var pizza: Pizza
        let ingredientFactory = NYPizzaIngredientFactory()
        
        switch(type) {
        case .Cheese:
            pizza = CheesePiza(ingredientFactory: ingredientFactory)
            pizza.setName(name: "New York Style Cheese Pizza")
        case .Bakon:
            pizza = CheesePiza(ingredientFactory: ingredientFactory)
            pizza.setName(name: "New York Style Cheese Pizza")
        case .Photato:
            pizza = CheesePiza(ingredientFactory: ingredientFactory)
            pizza.setName(name: "New York Style Cheese Pizza")
        }
        return pizza
    }
}

let nyPizzaStore = NYPizzaStore()
let orderPizza = nyPizzaStore.orderPizza(type: PizzaType.Cheese)



