

---
title: "[Java 8] Lambda Expression trong Java 8"
slug: java-lambda-expression
date: 2018-11-07
categories:
- Java
- Lambda expression
tags:
- Java
- Java 8
- Lambda expression
keywords:
- Java
- Java 8
- Lambda
- Expression
- Functional Interface
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541576734/eer0Pfq.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
# 1. Lambda expresstion là gì?
`Lambda expression` là một feature mới và nổi bật nhất của java 8 giúp số lượng code được giảm và là bước đầu khiến Java bước vào thế giới `functional programming`. Một lamba expression là một function được tạo mà không thuộc bất kì một class nào. Nó là một hàm không tên (unamed function) với các tham số (parameters) và phần body chứa khối lệnh được tách biệt với các tham số bằng dấu `->`. Ví dụ:

```

(int x) -> x + 1 // Có một tham số kiểu int và trả về giá trị tham số tăng lên 1
---
(int x, int y) // Có 2 tham số kiểu int và trả về tổng của chúng
---
(String msg) -> {System.out.printl(msg);} // Có một tham số kiểu String và in ra console
---
msg -> System.out.println(msg) // Có một tham số không cần xác định kiểu và in ra console
---
() -> "Hi" // Không có tham số và trả về một chuỗi
---
(int x, int y) -> {
	int max = x > y ? x:y;
	return max;
} // 2 tham số và trả về số lớn hơn.

```

Lambda expression thường được sử dụng để implement những `event listeners/callback` đơn giản hoặc trong `functional programming` cùng với `Java Streams API`.

# 2. Functional interface là gì?
Một interface chỉ chứa duy nhất một method trừu tượng được gọi là `function interface`. Nó cũng có thể được gọi là `Single Abstract Interface`(SAM). Functional interface sử dụng annotation `@FunctionalInterface` để khai báo. Tuy nhiên việc này là không bắt buộc, nó chỉ đảm bảo cho quá trình complile, giúp chương trình báo lỗi khi có từ 2 method trừu tượng trở lên.

Để sử dụng biểu thức Lambda thì đầu tiên cần phải có một _functional interface_ chứa một phương thức cần overide lại trong biểu thức lambda. Ví dụ interface `Runnable` là một _functional interface_:

```java

	@FunctionalInterface
	public interface Runnable {
		public abstract void run();
	}

```

Trước java 8 thì có vài cách để implement method trong một interface:

-	Cách 1: Tạo một class mới:

```java

	public class MyRunnable implements Runnable {
		@Override
		public void run() {
			System.out.println("I have implemented Runnable!");
		}

		public static void main(String args[]) {
			MyRunnable runnable = new MyRunnable();
			runnable.run();
		}
	}

```

- Cách 2: Tạo một class Annonymous:

```java

	Runnable runnable = new Runnable() {
		@Override
		public void run() {
			System.out.println("I have implemented Runnable!");
		}
	};
	runnable.run();

```

Còn nếu chúng ta sử dụng biểu thức lambda thì chỉ cần code đơn giản như sau:

```java

	Runnable runnable = () -> System.out.println("I have implemented Runnable!");
	runnable.run();

```

# 3. Funtional Interface API trong Java 8
Java 8 xây dựng sẵn một số functional interface được sử dụng trong các biểu thức lambda:
#### 3.1 java.util.function.Consumer
```java

	package java.util.function;

	import java.util.Objects;

	@FunctionalInterface
	public  interface Consumer<T> {
		// Phương thức chấp nhận một tham số đầu vào
		// và không trả về gì cả.
		void  accept(T t);
	}

```

**Sử dụng khi:** Consumer thường được dùng với list, stream để xử lý các phần tử bên trong.

Ví dụ đoạn code sau in ra tất cả các giá trị của 1 list:
```java

	List<String> list = Arrays.asList("tu", "bean", "tubean.github.io");

	// Sử dụng List.forEach(Consumer) để in ra giá trị của các phần tử trong list
	list.forEach(new Consumer<String>()  {
		@Override
		public  void  accept(String t)  {
			System.out.println(t);
		}
	});
	System.out.println("----------------");

	// Sử dụng List.forEach(Consumer) với cú pháp lambda expression:
	list.forEach(t -> System.out.println(t));

```

#### 3.2 java.util.function.Predicate

```java

	package java.util.function;
	import java.util.Objects;

	@FunctionalInterface
	public  interface Predicate<T> {
		// Kiểm tra một tham số đầu vào và trả về true hoặc false.
		boolean  test(T t);
	}

```
** Sử dụng khi: ** Kiểm tra từng phần tử  lúc xoá, lọc,... dùng với list, stream...
Ví dụ:
```java

	List<Integer> list = new ArrayList<>();
	list.add(-1);
	list.add(1);
	list.add(0);
	list.add(-2);
	list.add(3);

	// lệnh removeIf sẽ thực hiện duyệt từng phần tử,
	// nếu method test của Predicate trả về true thì sẽ remove phần tử đó khỏi list
	list.removeIf(new Predicate<Integer>()  {
		@Override
		public  boolean  test(Integer t)  {
			return t < 0;
		}
	});
	list.forEach(t -> System.out.println(t));
	System.out.println("-----------------------------");

	// Sử dụng Predicate với cú pháp Lambda Expression
	// loại bỏ các phần tử lớn hơn 1
	list.removeIf(t -> t > 1);
	list.forEach(t -> System.out.println(t));

```

#### 3.3 java.util.function.Function
```java

	package java.util.function;

	import java.util.Objects;

	@FunctionalInterface
	public  interface Function<T, R> {

		// Method này nhận đầu vào là 1 tham số và trả về một giá trị.
		R apply(T t);

	}

```
** Sử dụng khi: ** Function thường được dùng với Stream khi muốn thay đổi giá trị cho từng phần tử trong stream.
Ví dụ:

```java

	List<String> list = Arrays.asList("tubean", "JAVA", "demo", "Function");
	Stream<String> stream = list.stream();

	// chuyển tất cả các phần tử của stream thành chữ in hoa
	stream.map(new Function<String, String>()  {
		@Override
		public  String  apply(String t)  {
			return t.toUpperCase();
		}
	}).forEach(t -> System.out.println(t));
	System.out.println("---------------");
	// Function với cú pháp Lambda Expression
	// chuyển tất cả các phần tử của stream thành chữ thường

	stream = list.stream();// lưu ý là stream ko thể dùng lại nên phải khởi tạo lại
	stream.map(t -> t.toLowerCase()).forEach(t -> System.out.println(t))

```

Một số Function interface tương tự:

-   java.util.function.IntFunction<R>: dữ liệu chuyển về kiểu Integer
-   java.util.function.DoubleFunction<R>: dữ liệu chuyển về kiểu Double
-   java.util.function.LongFunction<R>: dữ liệu chuyển về kiểu Long

#### 3.4 java.util.function.Supplier
```java

	package java.util.function;

	@FunctionalInterface
	public  interface Supplier<T> {

		// method này không có tham số nhưng trả về một kết quả.
		T get();

	}

```

Ví dụ:

```java

	Random random = new  Random();
	Stream<Integer> stream = Stream.generate(new Supplier<Integer>()  {
		@Override
		public Integer get()  {
			return random.nextInt(10);
		}
	}).limit(5);

	stream.forEach(t -> System.out.print(t +" "));
	System.out.println("\n--------------------");

	// Sử dụng Supplier với cú pháp Lambda Expression:
	stream = Stream.generate(() -> random.nextInt(10)).limit(5);
	stream.forEach(t -> System.out.print(t +" "));

```

# 4. Interface có default và static method
Từ phiên bản java 8 thì các `Interface` còn có thể có `default methods` và `static method`. Cả 2 loại method này đều được định nghĩa implementation ngay trong interface. Điều đó có nghĩa là, một lambda expression có thể implement một interface với nhiều hơn một method. Hay nói cách khác, nếu một interface có chứa cả _default method_ và _static method_ thì nó vẫn được coi là một **functional interface**, miễn là nó chỉ có duy nhất một _abtract method_.
Ví dụ:

```java

	import java.io.IOException;
	import java.io.OutputStream;

	public interface MyInterface {

		void printIt(String text);

		default public void printUtf8To(String text, OutputStream outputStream){
			try {
				outputStream.write(text.getBytes("UTF-8"));
			} catch (IOException e) {
				throw new RuntimeException("Error writing String as UTF-8 to OutputStream", e);
			}
		}

		static void printItToSystemOut(String text){
			System.out.println(text);
		}
	}

```
và lambda sẽ trông như sau:

```java

	MyInterface myInterface = (String text) -> {
		System.out.print(text);
	};

```

# 5. Lambda Expression và Anonymous Interface Implementations
Ngay cả khi _lambda expression_ trông có vẻ giống _anonymous interface implementations (AII)_ thì chúng cũng có vài điều khác biệt. Trong đó, điểm khác biệt lớn nhất chính là một AII có thể có các biến local trong khi đó một lambda expression thì không có. Cùng xem ví dụ dưới đây:
```java

	public interface MyEventConsumer {
		// interface MyEventConsumner có một abtract method 1 parameter
		public void consume(Object event);
	}

```

Interface `MyEventConsumer` được implement từ một AII như sau:

```java

	MyEventConsumer consumer = new MyEventConsumer() {
		public void consume(Object event){
			System.out.println(event.toString() + " consumed");
		}
	};

```

AII `MyeventConsumer` có thể có khai báo thêm biến local của riêng nó như sau:

```java

	MyEventConsumer myEventConsumer = new MyEventConsumer() {
		private int eventCount = 0; // biến khai báo trong AII, không thể khai báo như này nếu dùng lambda
		public void consume(Object event) {
			System.out.println(event.toString() + " consumed " + this.eventCount++ + " times.");
		}
	};

```
# 6: Variable Capture
Tuy rằng không thể khai báo biến bên trong biểu thức lambda, nhưng nó vẫn cho phép các biến được khai báo bên ngoài được sử dụng bình thường trong phần body. Lambda có thể _capture_ được các loại biến như sau:
1. Local Variable Capture
```java

	// Chúng ta có một interface MyFactory
	public interface MyFactory {
		public String create(char[] chars);
	}

	// Lambda như này
	MyFactory myFactory = (chars) -> {
		return new String(chars);
	};

	// Capture local variable
	String myString = "Test";
	MyFactory myFactory = (chars) -> {
		return myString + ":" + new String(chars);
	};

```

2. Instance Variable Capture

```java

	public class EventConsumerImpl {

		private String name = "MyConsumer";

		public void attach(MyEventProducer eventProducer){
			eventProducer.listen(e -> {
				System.out.println(this.name);
			});
		}
	}

```

3. Static Variable Capture

```java

	public class EventConsumerImpl {
		private static String someStaticVar = "Some text";

		public void attach(MyEventProducer eventProducer){
			eventProducer.listen(e -> {
				System.out.println(someStaticVar);
			});
		}
	}

```

# 7. Sử dụng các phương thức tham chiếu (Method Referencees) là Lambda

Giả sử chúng ta có một interface `MyPrinter` với  một method trừu tượng truyền vào một parameter s:

```java

	public interface MyPrinter{
		public void print(String s);
	}

```

Thông thường chúng ta sẽ dùng lambda như sau:

```java

	MyPrinter myPrinter = (s) -> { System.out.println(s); };

```

Tuy nhiên, do biểu thức lambda chỉ có một câu lệnh, nên dấu `{}` có thể bỏ qua. Ta rút gọn lại thành:

```java

	MyPrinter myPrinter = s -> System.out.println(s);

```

Bởi vì tham số truyền vào là `s` và được sử dụng để làm tham số trong biểu thức lambda luôn nên java cho phép chúng ta rút gọn lại nữa như sau:

```java

	MyPrinter myPrinter = System.out::println;

```

Dấu `::` cho _Java compiler_ biết đây là một _method reference_.

Chúng ta có các loại _method reference_ sau:

- Static method references

```java

	// khai báo interface
	public interface Finder {
		public int find(String s1, String s2);
	}

	// khai báo class MyClass có một phương thức static có cùng signature với Interface
	public class MyClass{
		public static int doFind(String s1, String s2){
			return s1.lastIndexOf(s2);
		}
	}

	// biểu thức lambda như sau:
	Finder finder = MyClass::doFind;

```

- Parameter Method Reference

```java
	public interface Finder {
		public int find(String s1, String s2);
	}

	// Biểu thức lambda
	Finder finder = String::indexOf;
	// Dòng code trên có thể được viết dễ hiểu hơn như sau:
	Finder finder = (s1, s2) -> s1.indexOf(s2);

```

- Instance Method References

```java

	// Interface
	public interface Deserializer {
		public int deserialize(String v1);
	}
	// Class StringConverter nào đó có method converToInt cùng signature với method trong interface
	public class StringConverter {
		public int convertToInt(String v1){
			return Integer.valueOf(v1);
		}
	}
	// Tạo một instance của class StringConverter
	StringConverter stringConverter = new StringConverter();
	// Biểu thức lambda implement interface
	Deserializer des = stringConverter::convertToInt;

```

- Constructor References

```java

	// Interface
	public interface Factory {
		public String create(char[] val);
	}

	// Thay vì viết như này:
	Factory factory = chars -> new String(chars);
	// Ta viết như này:
	Factory factory = String::new;

```

*Tham khảo* :

-	http://tutorials.jenkov.com/java/lambda-expressions.html

-	https://viblo.asia/p/gioi-thieu-lambda-expression-trong-java-8-EyORkbklGqB

-	https://stackjava.com/java8/functional-interface-la-gi-functional-interface-trong-java-8.html
