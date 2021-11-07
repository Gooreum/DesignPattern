## 5.싱글턴 패턴
### 핵심

- 애플리케이션에서 단 하나의 인스턴스만 만들수 있도록 하고, 멀티 스레드 환경에서도 안전한 싱글턴 패턴 구성 방법을 살펴봅니다.

### 싱글톤 패턴의 정의

> 💡 
> 
> 싱글톤 패턴은 해당 클래스의 인스턴스가 하나만 만들어지고, 어디서든지 그 인스턴스에 접근할 수 있도록 하기 위한 패턴입니다. 
>

**구현 원리**

- 클래스에서 자신의 단 하나뿐인 인스턴스를 관리하도록 만들어야 합니다.
- 다른 어떤 클래스에서도 자신의 인스턴스를 추가로 만들지 못하도록 해야 합니다.
- 인스턴스가 필요하면 반드시 클래스 자신을 거치도록 해야 합니다.
- 어디서든 그 인스턴스에 접근할 수 있도록 만들어야 합니다.
- 싱글톤 클래스의 객체가 자원을 많이 잡아먹는 경우 게으른 생성 기법을 활용할 수 있습니다.

### 멀티스레드를 고려하지 않은 싱글톤 패턴 구현법(Java)

```java
public class Singleton { 
    //1
    private static Singleton uniqueInstance;

    //2
    private Singleton() {}
    
    //3
    public static Singleton getInstance() { 
        if ( uniqueInstance == null ) { 
                uniqueInstance = new Singleton();
        }
        return uniqueInstance;
    }
}
```

1. Singleton 클래스의 유일한 인스턴스를 저장하기 위한 정적 변수입니다.
2. 생성자를 private으로 선언했기 때문에 Singleton에서만 클래스의 인스턴스를 만들 수 있습니다.
3. getInstance() 메소드에서는 클래스의 인스턴스를 만들어서 리턴해줍니다. 
    
    uniqueInstance가 null이면 아직 인스턴스가 생성되지 않았다는 것을 의미합니다. 
    
    아직 인스턴스가 만들어지지 않았다면 private으로 선언된 생성자를 이용해서 Single 객체를 만든 다음 uniqueInstance에 그 객체를 대입합니다. 이렇게 하면 인스턴스가 필요한 상황이 닥치기 전에는 아예 인스턴스를 생성하지 않게 됩니다. 이런 방법을 "게으른 인스턴스 생성(lazy instantiatioin)"이라고 부릅니다.
    

**문제점**

- 위 방식은 싱글톤 인스턴스 객체가 되도록 의도했지만 멀티스레드 환경에서  두 개의 객체가 생성될 수 있습니다.
- 스레드1과 스레드2에서 new Singleton을 동시에 접근하게 된다면 두 개의 싱글톤 인스턴스 객체가 생성될 수 있는 것입니다.

### 멀티스레드를 고려한 싱글톤 패턴 3가지 구현법(Java)

**(1) 인스턴스를 필요할 때 생성하지 말고, 처음부터 만들어 버립니다.**

- 애플리케이션에서 반드시 Singleton의 인스턴스를 생성하고, 그 인스턴스를 항상 사용한다면, 또는 인스턴스를 실행중에 수시로 만들고 관리하기가 성가시다면 다음과 같은 식으로 처음부터 Singleton 인스턴스를 만들어버리는 것도 괜찮은 방법입니다.
- 이 접근법을 사용하면 클래스가 로딩될 때 JVM에서 Singleton의 유일한 인스턴스를 생성해줍니다. JVM에서 유일한 인스턴스를 생성하기 전에는 그 어떤 스레드도 uniqueInstance 정적 변수에 접근할 수 없습니다.

```java
public class Singleton { 
    //1
    private static Singleton uniqueInstance = new Singleton()

    //2
    private Singleton() {}
    
    //3
    public static Singleton getInstance() { 
        return uniqueInstance;
    }
}
```

**(2) getInstance()를 동기화시켜줍니다.**

```java
public class Singleton { 
    private static Singleton uniqueInstance;

    private Singleton() {}
    
    //1
    public static **synchronized** Singleton getInstance() { 
        if ( uniqueInstance == null ) { 
                uniqueInstance = new Singleton();
        }
        return uniqueInstance;
    }
}
```

1. getInstance()에 synchronized 키워드만 추가하면 한 스레드가 메소드 사용을 끝내기 전까지 다른 스레드는 기다려야 합니다. 즉, 두 세르다가 이 메소드를 동시에 실행시키는 일은 일어나지 않게 되죠.

- 동기화가 필요한 시점은 getInstance()가 시작되는 때 뿐입니다. 즉, uniqueInstance 변수가 Singleton()으로 초기화되고 나면 굳이 getInstance()를 동기화된 상태로 유지시킬 필요가 없어지게 됩니다. 따라서 첫번째 과정을 제외하면 동기화는 불필요한 오버헤드만 증가시킬 뿐입니다.
    - 이 문제는 아래 방법으로 해결할 수 있습니다.

**(3)DCL(Double-Checing Locking)을 써서 getInstance()에서 동기화되는 부분을 줄입니다.** 

- 인스턴스가 생성되어 있는지 확인한 다음, 생성되어 있지 않을 때만 동기화를 할 수 있습니다.
- 처음에만 동기화를 하고 나주에는 동기화를 하지 않게 됩니다.

```java
public class Singleton { 
    //1
    private static volatile Singleton uniqueInstance;

    private Singleton() {}
    

    public static Singleton getInstance() { 
        //2
        if ( uniqueInstance == null ) { 
                //3
                synchronized (Singleton.class) { 
                    if (uniqueInstance == null) { 
                            //4
                            uniqueInstance = new Singleton();
                    }
                }
        }
        return uniqueInstance;
    }
}
```

1. volatile 키워드를 사용하면 멀티스레딩을 사용하더라도 uniqueInstance 변수가 Singleton 인스턴스로 초기화되는 과정이 올바르게 진행되도록 할 수 있습니다. 
2. 인스턴스가 있는지 확인하고, 없으면 동기화된 블록으로 들어갑니다.
3. 이렇게 하면 처음에만 동기화가 됩니다.
4. 블록으로 들어온 후에도 다시 한번 변수가 null인지 확인한 다음 인스턴스를 생성합니다. 

### Swift로 Multi-Thread-Safety Singleton 구성해보기

```swift
public class Singleton {
        //1
    private static let shared = Singleton()
    //2
    private init() {}
    //3
    public static func getInstance() -> Singleton {
        return shared
    }

    public func toString() {
        print("Singleton")
    }
}

Singleton.getInstance().toString()

---result---
Singleton
```


1. Singleton 클래스의 객체를 보관할 전역 변수를 private으로 선언 및 생성합니다.
    1. 이 전역 변수 네이밍은 보통 shared로 지정합니다.
2. 외부 객체에서 Singleton 클래스를 생성할 수 없도록 private으로 생성자를 만듭니다.
3. 어떤 객체에서든 Singleton클래스에 접근하여 Singleton 객체를 가져갈 수 있도록 public 정적 메서드 getInstance()를 정의해줍니다.
