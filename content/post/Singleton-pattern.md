﻿---
title: "[Design Pattern] Singleton Design Pattern"
slug: singleton-pattern
date: 2018-12-09
categories:
- design pattern
tags:
- design pattern
- singleton
keywords:
- design
- pattern
- java
- singleton
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543156961/design-pattern-logo.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
# 1. Singleton là gì?
Đã khi nào bạn viết một class mà chỉ muốn nó chỉ có duy nhất một instance? Trong lập trình, chúng ta sẽ đôi lần thấy rằng một số class chỉ nên có duy nhất một instance, vì nếu có nhiều hơn một, chúng ta sẽ gặp phải một vài vấn đề như hành vi chương trình không chính xác, lãng phí tài nguyên hay kết quả không nhất quán. Ví dụ như các class tạo context của chương trình (thường thấy trong các framework), hay class quản lý các thread, registry, driver,...

`Singleton Pattern` là mẫu thiết kế giúp đảm bảo rằng class chỉ có duy nhất một instance và nó sẽ cung cấp cách để truy cập vào instace đó từ bất kỳ đâu trong project. Trong bài viết này, chúng ta cùng tìm hiểu những cách khác nhau để tạo ra một class chỉ có duy nhất một instance cũng như sự khác nhau giữa chúng.

![img1](https://res.cloudinary.com/deop9ytsv/image/upload/v1544327130/800px-Singleton_UML_class_diagram.svg.png)

# 2. Các cách để tạo class bằng Singleton Pattern
Hãy bắt đầu với một ví dụ đơn giản.
```java
public class SingletonEager {  
    private static SingletonEager sc = new SingletonEager();
}
```
Như chúng ta đã biết, chỉ có một bản copy của biến static cho một class và chúng ta có thể áp dụng nó. Trong ví dụ trên thì điều đó có nghĩa là các class client sẽ sử dụng biến _sc_ như một instance của class SingletonEager. Tuy nhiên nếu chỉ vậy thì khi client vẫn có thể tạo thêm instance bằng cách cách dùng từ khóa `new`. Vậy thì chúng ta cần chặn cách khởi tạo bằng contructor của class SingletonEager bằng từ khóa private:
```java
public class SingletonEager {  
   private static SingletonEager sc = new SingletonEager();  
   private SingletonEager(){}
}
```
Đến đây đã đủ chưa? Tôi nghĩ là cũng ổn. Nhưng chúng ta đều biết là cung cấp một cách gọi trực tiếp đến class member không phải ý tưởng hay trong java. Vì vậy chúng ta sẽ tạo thêm một method để truy cập đến biến sc:
```java
public class SingletonEager {  
    private static SingletonEager sc = new SingletonEager();  
   private SingletonEager(){}  
   public static SingletonEager getInstance(){  
      return sc;  
   }  
}
```
Đến đây thì class của chúng ta đã đảm bảo chỉ có duy nhất một instance được tạo và mỗi khi có request cần đến thì cũng chỉ có một instance duy nhất được trả về.

Nhược điểm của cách làm này chính là instance static luôn được tạo bất kể bạn có dùng nó hay không. Vì vậy nếu trong trường hợp không có request đến thì nó sẽ làm lãng phí tài nguyên bộ nhớ. Để khắc phục thì chúng ta sẽ chỉ tạo instace trong lần request đầu tiên và những lần sau sẽ trả về đúng instance đó:
```java
public class SingletonLazy {  
  
    private static SingletonLazy sc = null;  
   private SingletonLazy(){}  
   public static SingletonLazy getInstance(){  
      if(sc==null){  
         sc = new SingletonLazy();  
      }  
      return sc;  
   }  
}
```
Với cách trên thì khi chưa có request nào dùng đến method `getInstance()` thì sc luôn là null. Nó chỉ được tạo trong lần đầu request và những lần gọi sau luôn trả về cùng instance trước đó. Tuy vậy java là ngôn ngữ cho phép xử lý đa luồng. Điều đó có nghĩa là nếu cùng lúc có 2 request đến thì sẽ có thể xảy ra trường hợp tạo ra 2 instance. Để tránh điều này thì chúng ta sẽ sử dụng từ khóa `synchronized` cho method `getInstance()`:
```java
public class SingletonLazyMultithreaded {  
  
   private static SingletonLazyMultithreaded sc = null;  
  
    private SingletonLazyMultithreaded(){}  
   public static synchronized SingletonLazyMultithreaded getInstance(){  
      if(sc==null){  
         sc = new SingletonLazyMultithreaded();  
      }  
      return sc;  
   }  
}
```
Bằng cách này thì với với multi-thread, các thread phải lần lượt truy cập, thread này phải chờ thread kia kết thúc truy cập thì mới được vào. Bởi vậy nên sẽ không có trường hợp cả 2 cùng có điều kiện sc là null và tạo ra 2 instance mới. Tuy nhiên thì dùng từ khóa `synchronized` không phải là không phải trả giá, bởi nó sẽ làm cho performance của chương trình bị giảm. Bởi vậy nếu trong điều kiện chương trình của bạn không cần quan tâm đến multi-thread hoặc nó đã được handle ở client thì có thể không cần dùng đến từ khóa này. 

Nhưng nếu bạn vẫn muốn sử dụng từ khóa `synchronized` thì bạn nên sử dụng nó theo một best practice là `double-checked-locking`:
```java
public class SingletonLazyDoubleCheck {  
  
   private volatile static SingletonLazyDoubleCheck sc = null;  
  
    private SingletonLazyDoubleCheck(){}  
   public static SingletonLazyDoubleCheck getInstance(){  
      if(sc==null){  
         synchronized(SingletonLazyDoubleCheck.class){  
            if(sc==null){  
               sc = new SingletonLazyDoubleCheck();  
            }    
         }  
      }  
      return sc;  
   }  
}
```
Với `double-checked-locking`, chúng ta sẽ kiểm tra nếu instance được tạo chưa trước, nếu chưa thì chúng ta mới dùng `synchronized`. Bởi vì chúng ta chỉ cần quan tâm đến lần request đầu tiên và đảm bảo nó không tạo 2 instance khác nhau.

Ví dụ trên có thể là đã tạm đủ với nhiều chương trình đơn giản. Tuy nhiên thì vẫn còn vài cách để phá bỏ nguyên tắc của class được tạo bằng Singleton Pattern:

-	Nếu đó là một class Serializable.
-	Nếu nó có thể clone.
-	Nó có thể bị phá bởi Reflection.
-	Và nếu nó được tải bởi nhiều class loader.

Ví dụ dưới đây sẽ đảm bảo hơn cho một class chỉ có duy nhất một instance:

```java
public class Singleton implements Serializable {  
  
    private static final long serialVersionUID = -1093810940935189395L;  
    private static Singleton sc = new Singleton();  
    private Singleton(){  
        if(sc!=null){  
            throw new IllegalStateException("Already created.");  
        }  
    }  
    public static Singleton getInstance(){  
        return sc;  
    }  
  
    private Object readResolve() throws ObjectStreamException {  
        return sc;  
    }  
  
    private Object writeReplace() throws ObjectStreamException{  
        return sc;  
    }  
  
    public Object clone() throws CloneNotSupportedException{  
        throw new CloneNotSupportedException("Singleton, cannot be clonned");  
    }  
  
    private static Class getClass(String classname) throws ClassNotFoundException {  
        ClassLoader classLoader = Thread.currentThread().getContextClassLoader();  
        if(classLoader == null)  
            classLoader = Singleton.class.getClassLoader();  
        return (classLoader.loadClass(classname));  
    }  
  
}
```
Trong ví dụ trên thì:

- Chúng ta cần implement method `readResolve()` và `writeReplace()` để chúng luôn trả về cùng một instance.
- Method `clone()` cần được khóa lại không cho phép sử dụng bằng cách throw một Exception nếu dùng method này.
- Một điều kiện if trong constructor để ngăn chặn việc tạo thêm instance từ reflection.
- Method `getClass()` kiểm tra ClassLoader để đảm bảo khi class được tải bởi nhiều ClassLoader đi nữa thì nó vẫn chỉ có duy nhất một instance được tạo.

Để biết chi tiết hơn về lí do cũng như hiểu tại sao lại có các giải pháp như vậy thì bạn có thể đọc thêm tại [đây](https://www.geeksforgeeks.org/prevent-singleton-pattern-reflection-serialization-cloning/).

Các giải pháp trên đều có thể sử dụng tùy từng trường hợp, nhưng có một cách đơn giản và dễ hơn để tạo một singleton class. Từ JDK 1.5, bạn có thể tạo singleton class bằng enum. Các Enum là những đối tượng tồn tại duy nhất trong project và bạn không thể thay đổi giá trị của chúng một khi chúng đã được tạo.

```java
public class SingletoneEnum {  
  
   public enum SingleEnum{  
        SINGLETON_ENUM;  
   }  
}
```
Bạn có thể sẽ gặp lỗi trong lúc compile nếu bạn cố gắng khởi tạo một Enum bằng từ khóa new. Enum cũng được tải một cách static nên nó là thread-safe. Method `clone()` trong Enum là final nên nó cũng không bao giờ tạo thêm instance. Nó cũng đảm bảo luôn trong trường hợp có Serializable và Reflection rằng chỉ có duy nhất một `enum constants` được tạo.

# 3. Trường hợp sử dụng:
Chúng ta sử dụng Singleton Pattern khi:

- Chương trình cần có duy nhất một instance cho một class nào đó, và nó phải được truy cập từ những client class khác.
- Khi một instance cụ thể nào đó cần được mở rộng bằng class con, và client cần sử dụng instance được mở rộng đó mà không cần chỉnh sửa lại code.

# 4. Source code
https://github.com/tubean/design-pattern/
