---
title: "[Functional Programming] Java Higher Order Functions"
slug: -java-higher-order-function
date: 2018-12-10
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
- higher order
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542691153/java_logo.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Một `higher order function` là một function nhận một function (method) khác làm parameter, hoặc nó có kết quả trả về là một function. Bài viết này sẽ giới thiệu một vài ví dụ về higher order function.
# 1. Sorting Collections
Ví dụ đầu tiên về `higher order function` là method `Collections.sort()` nhận một Comparator như một tham số:
```java
List<String> list = new ArrayList<>();
list.add("One");
list.add("Abc");
list.add("BCD");

Collections.sort(list, (String a, String b) -> {
    return a.compareTo(b);
});

System.out.println(list);
```
Trong ví dụ trên, method `sort()` nhận 2 parameter. Param thứ nhất là một `List` và param thứ hai là một lambda. Chính param thứ hai đã khiến method `sort()` trở thành một `higher order collection`.

# 2. Sorting in Reverse Order
Dưới đây là một ví dụ khác về `higher order function`. Lần này là một function có kết quả trả về là một function khác:
```java
Comparator<String> comparator = (String a, String b) -> {
    return a.compareTo(b);
};

Comparator<String> comparatorReversed = comparator.reversed();

Collections.sort(list, );

System.out.println(list);
```
Trong ví dụ này thì method `reversed()` được gọi bởi Comparator và trả về một  biểu thức lamda là một Comparator mới.

# Nguồn:
http://tutorials.jenkov.com/java-functional-programming/higher-order-functions.html
