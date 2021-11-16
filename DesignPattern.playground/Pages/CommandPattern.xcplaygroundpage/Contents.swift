
protocol Command {
    func execute()
}

public class Light {
    public func on() { print("Light On") }
    public func off() { print("Light Off") }
}

public class LightOnCommand: Command {
    let light: Light
    init(light: Light) {
        self.light = light
    }

    public func execute() {
        light.on()
    }
}

public class SimpleRemoteControl {
    var slot: Command?
    
    func setCommand(command: Command) {
        slot = command
    }
    
    func buttonWasPressed() {
        slot?.execute()
    }
}

public class GarageDoor {
    func up() { print("Garage Door Open")}
    func down() { print("Garage Door down")}
    func stop() { print("Garage Door stop")}
    func lightOn() { print("Garage Door lightOn")}
    func lightOff() { print("Garage Door lightOff")}
}

public class GarageDoorOpenCommand: Command {
    let garageDoor: GarageDoor
    
    init(garageDoor: GarageDoor) {
        self.garageDoor = garageDoor
    }
    
    public func execute() {
        garageDoor.up()
    }
}

let remote = SimpleRemoteControl()
let light = Light()
let lightOn = LightOnCommand(light: light)
let garageDoor = GarageDoor()
let garageDoorOpen = GarageDoorOpenCommand(garageDoor: garageDoor)

remote.setCommand(command: lightOn)
remote.buttonWasPressed()

remote.setCommand(command: garageDoorOpen)
remote.buttonWasPressed()


