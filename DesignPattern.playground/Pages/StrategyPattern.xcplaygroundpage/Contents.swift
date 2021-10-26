import Foundation


protocol FlyBehavior {
    func fly()
}

protocol QuackBehavior {
    func quack()
}

class FlyWithWings: FlyBehavior {
    func fly() {
        print("나는 날고 있다.")
    }
}

class FlyNoWay: FlyBehavior {
    func fly() {
        print("나는 날 수 없어요.")
    }
}

class Quack: QuackBehavior {
    func quack() {
        print("꽥꽥!!")
    }
}

class Quick: QuackBehavior {
    func quack() {
        print("뀍뀍!!")
    }
}

class Duck {
    var quackBehavior: QuackBehavior
    var flyBeahvior: FlyBehavior
    
    init(quackBehavior: QuackBehavior, flyBehavior: FlyBehavior) {
        self.quackBehavior = quackBehavior
        self.flyBeahvior = flyBehavior
    }
    
    func swim() { print("수영을 합니다.")}
    func display() {}
    func performQuack() {
        quackBehavior.quack()
    }
    func performFly() {
        flyBeahvior.fly()
    }
}

class MallardDuck: Duck {
    init() {
        super.init(quackBehavior: Quack(), flyBehavior: FlyWithWings())
    }
    
    override func display() {
        print("저는 물오리입니다.")
    }
}

class ModelDuck: Duck {
    init() {
        super.init(quackBehavior: Quick(), flyBehavior: FlyNoWay())
    }
    
    override func display() {
        print("저는 고무오리입니다.")
    }
}

let mallardDuck = MallardDuck()
mallardDuck.performFly()
mallardDuck.performQuack()

let modelDuck = ModelDuck()
modelDuck.performFly()
modelDuck.performQuack()
