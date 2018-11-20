

---
title: "[Magical Java] Tại sao 1000 == 1000 là sai, nhưng 100 == 100 lại đúng?"
slug: -magical-1000-vs-100
date: 2018-11-20
categories:
- Java
- Magical Java
tags:
- Java
- Tutorial
- Trick
keywords:
- Java
- Cache
- Integer
- Magic
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542691153/java_logo.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Cùng xem đoạn code sau và dự đoán kết quá:
```java
Integer a = 1000, b = 1000;

 System.out.println(a == b);//1

 Integer c = 100, d = 100;

 System.out.println(c == d);//2
```
Nếu các bạn đưa ra đáp án là **false, false** thì xin chúc mừng, các bạn nắm lý thuyết rất tốt. Ở đây chúng ta đang so sánh 2 object với nhau, và khi dùng toán tử "==" thì kết quả sẽ trả về _false_ nếu 2 tham chiếu không cùng trỏ đến cùng một đối tượng. Tuy nhiên nếu bạn chạy thử đoạn code trên thì thực tế nó không được như dự đoán làm. Kết quả sẽ trả về là :
```java
false
true
```
Suy luận một chút, nếu ở bước so sánh đầu tiên đúng như dự đoán, tức là _a_ và _b_ đang trỏ đến 2 object khác nhau. Vậy thì ở bước thứ 2, phải chăng cả _c_ và _d_ đang trỏ đến cùng một object?

Muốn hiểu rõ vấn đề này, chúng ta cần tìm kiếm thêm thông tin trong lớp `Integer.java`.  Trong class này, hãy để ý đến một lớp _private static_ trong nó, đó là `IntegerCache`. Theo như mô tả thì nhiệm vụ của class này là:

> Cache to support the object identity semantics of autoboxing for values between  -128 and 127 (inclusive) as required by JLS.

Điều đó có nghĩ là tất các số nguyên từ -128 đến 127 sẽ được lưu trong cache, và khi chúng ta khai báo:
```java
Integer c = 100;
```
thì thực tế nó sẽ như thế này:
```java
Integer c = Integer.valueOf(100);
```
Bây giờ nhìn vào phương thức `valueOf()`:
```java
public static Integer valueOf(int i) {  
    if (i >= IntegerCache.low && i <= IntegerCache.high)  
        return IntegerCache.cache[i + (-IntegerCache.low)];  
    return new Integer(i);  
}
```
Như vậy là tất cả các số nguyên Integer mà nằm trong vùng cache thì sẽ trả về cùng một đối tượng. Và đó là lí do tại sao biểu thức số #2 lại trả về `true`.

Câu hỏi đặt ra là, tại sao chúng ta lại phải `cache`? Câu trả lời là do những số trong khoảng cache này được sử dụng nhiều hơn các số integer khác, do đó việc tạo ra một vùng cache sẽ là một chiến thuật tốt để cân bằng bộ nhớ. Bởi nếu không cache thì việc sử dụng nhiều lần cùng một số integer là không tốt, và nếu cache toàn bộ thì bộ nhớ phải sử dụng là quá nhiều. Vì vậy chỉ cache một khoảng data được sử dụng nhiều sẽ là hợp lý.

Dựa vào lý thuyết bên trên, chúng ta có thể lợi dụng để tạo ra một số tính năng _dị thường_:

```java
public static void main(String[] args) throws NoSuchFieldException, IllegalAccessException {

 Class cache = Integer.class.getDeclaredClasses()[0]; //1

 Field myCache = cache.getDeclaredField("cache"); //2

 myCache.setAccessible(true);//3

 Integer[] newCache = (Integer[]) myCache.get(cache); //4

 newCache[132] = newCache[133]; //5

 int a = 2;

 int b = a + a;

 System.out.printf("%d + %d = %d", a, a, b); //

 }
 ```
Chạy đoạn code trên và bạn sẽ nhận được kết quả như sau:

```
2 + 2 = 5
```
Giải thích đoạn code trên như sau:

#1. Sử dụng reflection API để lấy ra class được khai báo bên trong class `Integer`. Điều đó có nghĩa là reference `cache` trỏ đến chính là class `IntegerCache`. Nội dung class này như sau:

```java
private static class IntegerCache {  
    static final int low = -128;  
    static final int high;  
    static final Integer cache[];  

    static {  
        // high value may be configured by property  
  int h = 127;  
        String integerCacheHighPropValue =  
            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");  
        if (integerCacheHighPropValue != null) {  
            try {  
                int i = parseInt(integerCacheHighPropValue);  
                i = Math.max(i, 127);  
                // Maximum array size is Integer.MAX_VALUE  
  h = Math.min(i, Integer.MAX_VALUE - (-low) -1);  
            } catch( NumberFormatException nfe) {  
                // If the property cannot be parsed into an int, ignore it.  
  }  
        }  
        high = h;  

        cache = new Integer[(high - low) + 1];  
        int j = low;  
        for(int k = 0; k < cache.length; k++)  
            cache[k] = new Integer(j++);  

        // range [-128, 127] must be interned (JLS7 5.1.7)  
  assert IntegerCache.high >= 127;  
    }  

    private IntegerCache() {}  
}
```

#2. Tạo một Field để trỏ đến field `Integer cache[]` trong class `IntegerCache`,  đặt tên là `myCache`.

#3. Set quyền truy cập cho field `myCache`.

#4. Lấy ra mảng các số integer được cache, chính là mảng gồm các số từ -128 đến 127.

#5. Thay đổi giá trị của phần tử có index = 132 (ở đây chính là phần tử có giá trị bằng 4) bằng phần tử có index = 133 (có giá trị bằng 5).

Như vậy, khi thực hiện phép cộng 2 + 2 thì kết quả được trả về là phần tử có index = 132 trong mảng cache, và có giá trị đã được sửa đổi là bằng 5.

### Tham khảo:
https://dzone.com/articles/why-1000-1000-returns-false-but-100-100-returns-tr
