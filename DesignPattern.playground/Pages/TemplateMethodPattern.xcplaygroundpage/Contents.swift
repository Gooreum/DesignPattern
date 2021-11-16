protocol CaffeineBeverage {
    func prepareRecipe()
    func brew()
    func addCondiments()
}

extension CaffeineBeverage {
    func prepareRecipe() {
        boilWater()
        brew()
        pourInCup()
        addCondiments()
        hook()
    }
    func boilWater() {
        print("물을 끓입니다.")
    }
    func pourInCup() {
        print("컵에 따릅니다.")
    }
}

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

