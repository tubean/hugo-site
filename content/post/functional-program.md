---
title: "[Functional Programming]  Functional Programing trong Java"
slug: -java-functional-programming
date: 2018-12-09
categories:
- Java
- Functional Programming
tags:
- Java
- Functional
- Programming
keywords:
- Java
- functional
- programming
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542691153/java_logo.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
# 1. Functional Programming là gì?
`Functional Programming` hay lập trình chức năng là kiểu lập trình mà function được chọn làm đơn vị thao tác cơ bản. Functional programming tập trung vào sử dụng tính năng của các hàm và tránh sử dụng các biến cũng như thay đổi giá trị của chúng. Nó hơi ngược với `procedure programming` như chúng ta vẫn thường sử dụng (OOP tập trung vào chi tiết hoạt động của chương trình và thường sử dụng các biến và thay đổi trạng thái của chương trình). Nó cũng không bắt buộc chương trình phải chạy các hàm theo một thứ tự xác định và chúng ta có thể thay đổi trật tự của các hàm mà không ảnh hưởng tới chương trình.

Trong java, function programming được Oracle cố gắng đưa vào từ java 8, tuy nhiên nó cũng không hoàn toàn đầy đủ các khía cạnh của kiểu lập trình này. Trong bài viết này, chúng ta sẽ tìm hiểu các kiến thức cơ bản về functional programming và những phần nào có thể có trong Java.

# 2. Các khái niệm cơ bản
`Functional Programming` có các khái niệm quan trọng sau:

- Các function được coi như các object, đơn vị thao tác cơ bản.
- Các function có tính purity.
- Higher order functions.

Lập trình chức năng cơ bản có các quy tắc sau:

- Không trạng thái (no state).
- Không có hiệu ứng phụ (no side effect).
- Các biến là cố định. (Immutable variables).
- Ưu tiên đệ quy để thay thế vòng lặp.

Các khái niệm và quy tắc này sẽ được giải thích trong bài viết.
Ngay cả khi bạn không tuân theo các quy tắc này mọi lúc mọi nơi thì bạn vẫn có thể có những lợi ích từ các ý tưởng lập trình chức năng trong các ứng dụng của mình. Việc học cả 2 loại lập trình sẽ giúp bạn giải quyết các vấn đề khi lập trình một cách thông minh và hiệu quả hơn.

## 2.1 Đơn vị Function
Trong Functional Programming nói một cách lý tưởng thì nó chỉ có function, function và function. Nói không với các lệnh gán (assignment statements), nói không với các biến toàn cục (global variables), không lưu giữ trạng thái toàn cục (global state). Chúng ta tạo nên chương trình bằng cách phối hợp các function lại với nhau, biến hóa chúng theo mọi cách có thể nghĩ ra. Đó gọi là không gian `first-class functions`, nơi các function được coi như `first-class-citizens`.

Trong java thì điều đó đồng nghĩa với việc bạn có thể tạo các instance cho một function, có một biến reference đến instance đó giống như String, Map hay bất kì object nào. Function cũng có thể được truyền như một parameter vào một function khác.
Tuy nhiên thì các methods trong Java không hẳn là những function như vậy. Khái niệm gần nhất với function chúng ta có trong Java chính là [Java Lambda Expressions](https://tubean.github.io/2018/11/java-lambda-expression/).

## 2.2 Function thuần khiết (Pure Functions)

Một function được coi là thuần khiết nếu:

- Phần thực thi của function không tạo ra hiệu ứng phụ (no side effect).
- Phần trả về của function chỉ phụ thuộc vào các parameter truyền vào.
Ví dụ:

```java
public class ObjectWithPureFunction{

    public int sum(int a, int b) {
        return a + b;
    }
}
```

Trong ví dụ trên thì hàm `sum()` có giá trị trả về chỉ phụ thuộc vào 2 parameter truyền vào là `a` và `b`. Hàm `sum()` cũng không có hiệu ứng phụ, có nghĩa là nó không thay đổi bất kì giá trị hay trạng thái của các parameter được truyền vào.
Một ví dụ khác về function không thuần khiết:
```java
public class ObjectWithNonPureFunction{
    private int value = 0;

    public int add(int nextValue) {
        this.value += nextValue;
        return this.value;
    }
}
```
Trong ví dụ trên thì kết quả trả về phụ thuộc vào một biến khác ngoài parameter và hàm này cũng làm thay đổi state của biến `value`, vì thế nó cũng có hiệu ứng phụ.

## 2.3 Higher Order Functions
Một function được coi là `higher order function` nếu nó thỏa mãn một trong các điều kiện sau:

- Function đó có một hoặc nhiều function khác làm parameter.
- Function đó trả về kết quả là một function.

Trong Java, `Higher Order Function` có thể thấy được qua việc một function nhận một hay nhiều biểu thức lambda làm parameter và trả về một biểu thức lambda khác. Ví dụ như:
```java
public class HigherOrderFunctionClass {

    public <T> IFactory<T> createFactory(IProducer<T> producer, IConfigurator<T> configurator) {
        return () -> {
           T instance = producer.produce();
           configurator.configure(instance);
           return instance;
        }
    }
}
```
Trong ví dụ trên thì method `createFactory` có kết quả trả về là một biểu thức lambda. Do đó nó thỏa mãn điều kiện của một `higher order function`. Ngoài ra thì method này cũng nhận 2 instance làm parameter và cả 2 instance đều là implementation của các interface `IProducer` và `IConfigurator`. Hãy tưởng tượng các interface đó như sau:
```java
public interface IFactory<T> {
   T create();
}
```
```java
public interface IProducer<T> {
   T produce();
}
```
```java
public interface IConfigurator<T> {
   void configure(T t);
}
```
Chúng ta có thể nhận thấy các interface này đều là các `functional interface`. Do đó chúng có thể được implement từ các biểu thức lambda và đó cũng là điều kiện để method `createFactory()` trở thành một `higher order function`.

## 2.4 Không trạng thái ( No state)
Như đã nhắc ở trên thì một nguyên tắc của functional programming là không có trạng thái. Điều đó có nghĩa là một function có thể có các biến local để lưu giữ các trạng thái nội tại của function, nhưng nó sẽ không thể tham chiếu đến bất kỳ một biến nào khác của class hay object chứa function đó.
Ví dụ một function không sử dụng trạng thái ngoại lai (external state) nào:
```java
public class Calculator {
    public int sum(int a, int b) {
       return a + b;
    }
}
```
Ngược lại, ví dụ dưới đây cho thấy một function sử dụng trạng thái ngoại lai:
```java
public class Calculator {
    private int initVal = 5;
    public int sum(int a) {
       return initVal + a;
    }
}
```

## 2.5 Không hiệu ứng phụ (No side effects)
Một nguyên tắc của FP là nó các function không có hiệu ứng phụ. Điều đó nghĩa là một function không thể thay đổi bất kỳ trạng thái của bất cứ thứ gì ngoài phạm vi của function. Thay đổi các state ngoài phạm vi function được gọi là `side effect`.

## 2.6 Biến không thể thay đổi (Immutable variables)
Nguyên tắc thứ ba của FP là các biến trong function đều không được thay đổi. Điều đó có nghĩa nó nên là các `constant`. Nguyên tắc này sẽ giúp tránh các hiệu ứng phụ dễ dàng hơn.

## 2.7 Ưu tiên đệ quy
Nguyên tắc thứ tư của FP là các function sẽ ưu tiên sử dụng đệ quy để thay thế các phép tính loop, hạn chế for, for-each, while, do-while,... Một cách khác để sử dụng loop chính là `API Java Streams`. API này được lấy cảm hứng từ FP.

## 2.8 Funtional Interfaces
Một functional interface trong Java là một function chỉ có một method trừu tượng. Ví dụ:
```java
public interface MyInterface {
    public void run();
}
```
Ngoài ra trong interface có thể các method khác như `default method`, `static method` thì nó vẫn được coi là functional interface nếu chỉ có duy nhất một abtract method:
```java
public interface MyInterface2 {
    public void run();

    public default void doIt() {
        System.out.println("doing it");
    }

    public static void doItStatically() {
        System.out.println("doing it statically");
    }
}
```

# Nguồn:
http://tutorials.jenkov.com/java-functional-programming/index.html
