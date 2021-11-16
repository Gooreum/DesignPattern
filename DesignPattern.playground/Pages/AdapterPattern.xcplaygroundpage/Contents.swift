protocol Duckable {
    func quack()
    func fly()
}

protocol Turkeyable {
    func gobble()
    func fly()
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

class Client {
    func testDuck(duck: Duckable) {
        duck.quack()
        duck.fly()
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
