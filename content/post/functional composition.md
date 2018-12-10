---
title: "[Functional Programming]  Java Functional Composition"
slug: -java-functional-composition
date: 2018-12-10
categories:
- Java
- Functional Programming
tags:
- Java
- Functional
- Programming
- Composition
keywords:
- Java
- functional
- programming
- composition
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542691153/java_logo.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
`Function composition` là một khái niệm về việc nhiều function có thể lồng nhau để làm param của một function khác. Bạn có thể tự compose nhiều function (dùng Lambda Expression) vào trong một function của riêng bạn, nhưng Java cũng cung cấp những cách compose riêng giúp bạn làm việc đó dễ hơn. Trong bài viết này chúng ta cùng tìm hiểu làm thế nào để compose các function bằng các feature có sẵn của Java.

# 1. Ví dụ về Java Functional Composition
Để bắt đầu, hãy xem một ví dụ nhỏ về Java Functional Compostion:
```java
Predicate<String> startsWithA = (text) -> text.startsWith("A");
Predicate<String> endsWithX   = (text) -> text.endsWith("x");

Predicate<String> startsWithAAndEndsWithX =
        (text) -> startsWithA.test(text) && endsWithX.test(text);

String  input  = "A hardworking person must relax";
boolean result = startsWithAAndEndsWithX.test(input);
System.out.println(result);
```
Trên đây là ví dụ về một function được compose từ hai implementation của interface `Predicate`. Predicate đầu tiên trả về `true` nếu như parameter truyền vào bắt đầu bằng chữ `A`. Predicate thứ hai sẽ trả về `true` nếu parameter truyền vào kết thúc bằng chữ `x`. Chú ý rằng, một interface Predicate còn có một method chưa được implement là `test()` trả về giá trị boolean. Đây chính là method mà các biểu thức lambda implement.

Sau khi  tạo ra 2 function cơ bản, một Predicate thứ ba được compose và gọi đến method `test()` của hai function đầu tiên. Function thứ ba này sẽ trả về `true` nếu cả hai function đầu trả về `true`, và nó sẽ trả về `false` trong các trường hợp còn lại.

# 2. Java Functional Composition Support
Ví dụ ở phần đầu đã chỉ cho các bạn thấy làm thế nào để compose một function mới từ hai function khác. Có một vài `Functional Interface` trong Java cũng đã support sẵn các `functional composition` thông qua các method `default` và `static`.

## 2.1 Predicate Composition
Interface `Predicate` chứa một vài method giúp bạn compose một instance Predicate mới từ những instance Predicate khác. Chúng là những method sau:

- and()

Đây là một method `default`. Method này được sử dụng để hợp hai Predicate function khác như trong ví dụ ở phần đầu.

- or()

Method `or()` cũng được sử dụng tương tự như `and()`, tuy nhiên thì nó sẽ có kết quả trả về là `false` khi và chỉ khi cả 2 function được hợp lại đều trả về `false`.
```java
Predicate<String> startsWithA = (text) -> text.startsWith("A");
Predicate<String> endsWithX   = (text) -> text.endsWith("x");

Predicate<String> composed = startsWithA.or(endsWithX);

String input = "A hardworking person must relax sometimes";
boolean result = composed.test(input);
System.out.println(result);
```
Kết quả của đoạn code trên sẽ trả về `true` vì function con đầu tiên trả về true.

## 2.2 Function Composition
Interface `Function` cũng có một vài method được sử dụng để compose một Function mới từ những cái có sẵn.

- compose()

```java
Function<Integer, Integer> multiply = (value) -> value * 2;
Function<Integer, Integer> add      = (value) -> value + 3;

Function<Integer, Integer> addThenMultiply = multiply.compose(add);

Integer result1 = addThenMultiply.apply(3);
System.out.println(result1);
```
Cách compose này khiến chúng ta tư duy theo kiểu các hàm toán học, khi mà muốn tính f(g(x)) thì chúng ta phải tính g(x) trước rồi mới tính đến hàm ở ngoài là f(g(x)).
Ta có instance `multiply` và instance `add`, kết quả khi `add` compose với `multiply` là một instance Function `addThenMultiply`. Ở đây, chúng ta thực hiện phép cộng trước nên instance `add` được tính trước và trở thành paramter cho method compose của instance `multiply`.

Trong ví dụ trên, kết quả sẽ trả về (3+3) * 2 = 12.

- andThen()

```java
Function<Integer, Integer> multiply = (value) -> value * 2;
Function<Integer, Integer> add      = (value) -> value + 3;

Function<Integer, Integer> multiplyThenAdd = multiply.andThen(add);

Integer result2 = multiplyThenAdd.apply(3);
System.out.println(result2);
```
Method `andThen()` hoạt động hơi ngược lại so với method `compose()`. Nó có vẻ thuận với tư duy tự nhiên từ trái sang phải hơn, khi mà bạn muốn dùng phép nhân trước thì sẽ để nó đứng trước, sau đó phép cộng sẽ được thêm vào như một parameter.

Kết quả của đoạn code trên là 3 * 2 + 3 = 9.

# Nguồn
http://tutorials.jenkov.com/java-functional-programming/functional-composition.html
