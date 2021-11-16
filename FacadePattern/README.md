## 7.2 파사드 패턴
### 파사드 패턴 목적

- 클라이언트에게 복잡한 서브시스템을 쉽게 조작할 수 있는 인터페이스를 제공할 수 있습니다.
- 이때의 인터페이스는 추상화 개념으로써의 인터페이스가 아니라, 단순히 클라이언트와 서브시스템의 매개체 역할이며, 클라이언트와 서브시스템을 분리하는 목적을 갖습니다.

### 파사드 패턴 정의

>
>💡 어떤 서브시스템의 일련의 인터페이스에 대한 통합된 인터페이스를 제공합니다.
>파사드에서 고수준 인터페이스를 정의하기 때문에 서브시스템을 더 쉽게 사용할 수 있습니다.
>


### 홈씨어터 조작 리모컨 만들기

- 홈씨어터를 제대로 구성하기 위해서는 엄청 복잡한 서브시스템들이 필요합니다. 가령 이렇게 말이죠.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/253e37ac-763a-42f0-8cf6-8484f38a7409/Untitled.png)

                이미지 출처 : [http://blog.lukaszewski.it/2013/08/31/design-patterns-facade/](http://blog.lukaszewski.it/2013/08/31/design-patterns-facade/)

- 파사드 패턴을 이용해서 클라이언트가 쉽게 홈시어터를 조작할 수 있도록 해봅시다. 이렇게 말이죠.
    - 클라이언트는 위 그림처럼 복잡한 서브시스템을 직접 조작할 필요 없이 파사드 클래스를 만들어 쉽게 조작 할 수 있도록 합니다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/e3d8e1bd-f622-4891-a1a8-082148ed7463/Untitled.png)
