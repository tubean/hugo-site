

---
title: "[Java 8] Stream trong Java 8 (Phần 2)"
slug: java-stream-part2
date: 2018-11-12
categories:
- Java
tags:
- Java
- Java 8
- Stream
keywords:
- Java
- Java 8
- Stream
- Collection
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541576734/eer0Pfq.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Tiếp theo bài viết [trước](https://tubean.github.io/2018/11/java-stream/), bài viết này sẽ đi vào tìm hiểu cách sử dụng Stream trong Java.

# 1. Tạo một stream
Có nhiều cách tạo một `stream instance` từ các source khác nhau. Mỗi khi được tạo thì instance sẽ không làm thay đổi source cũ, vì vậy chúng ta có thể thoải mái tạo nhiều instance stream khác nhau từ một source.

-	Stream rỗng (Empty stream)

Khi muốn tạo một stream rỗng, ta dùng method `empty()`:
```java
Stream<String> streamEmpty = Stream.empty();
```
Chúng ta thường sử dụng stream rỗng nếu muốn trả về một stream không có element khi check null collection.

```java
public Stream<String> streamOf(List<String> list) {
	return list == null || list.isEmpty() ? Stream.empty() : list.stream();
}
```
- Stream từ Collection

Stream có thể được tạo từ bất kì loại Collection nào (Collection, List, Set):

```java
Collection<String> collection = Arrays.asList("a", "b", "c");
Stream<String> streamOfCollection = collection.stream();
```

- Stream từ Array

Array có thể là một source của Stream:
```java
Stream<String> streamOfArray = Stream.of("a", "b", "c");
```
Stream cũng có thể được tạo từ một array có sẵn hoặc một phần của Array
```java
String[] arr = new String[]{"a", "b", "c"};
Stream<String> streamOfArrayFull = Arrays.stream(arr);
Stream<String> streamOfArrayPart = Arrays.stream(arr, 1, 3);
```
- Stream.builder()

Phương thức builder() tạo ra một builder của Stream.
```java
//Sử dụng Stream builder()
Stream.Builder<String> builder = Stream.builder();

// Thêm một element vào trong stream
Stream<String> stream = builder.add("Bean").build();

// Xuất thông tin ra màn hình
stream.forEach(System.out::println);
```

- Stream.generate()

Phương thức generate() cho phép truyền một Supplier<T> vào để tự động generate ra element. Nếu như kết quả của stream là vô hạn, chúng ta cần chỉ định rõ giới hạn size.
```java
// Dòng code sau tạo ra 1 stream trong đó có 10 phần tử "element"
Stream<String> streamGenerated = Stream.generate(() -> "element").limit(10);
```

- Stream.iterate()

Một cách khác để tạo ra một stream vô hạn là sử dụng iterate()
```java
Stream<Integer> streamIterated = Stream.iterate(40, n -> n + 2).limit(20);
```
Phần tử đầu tiên của stream được tạo sẽ là param đầu tiên được truyền vào iterate(). Như vậy trong đoạn code trên, stream sau khi tạo sẽ có các phần tử 40,42,44,...

- Stream của kiểu dữ liệu nguyên thuỷ

Java 8 cho phép tạo stream từ 3 kiểu dữ liệu nguyên thuỷ: _int_, _long_ và _double_ tương ứng với 3 interface `IntStream`, `LongStream`, `DoubleStream`.
```java
IntStream intStream = IntStream.range(1,3);
LongStream longStream = LongStream.rangeClosed(1,3);
```
Phương thức `range(int startInclusive, int endExclusive)` tạo ra một stream có chứa các phần tử được sắp xếp liên tiếp từ _startInclusive_ đến _endExclusive_

Phương thức `rangeClosed(int startInclusive, int endExclusive)` tương tự nhưng bao gồm cả phần tử _endExclusive_.

Ngoài ra Java 8 còn có class `Random` cung cấp các method để tạo ra một stream kiểu nguyên thuỷ và các phần tử ngẫu nhiên:

```java
Random random = new Random();
DoubleStream doubleStream = random.doubles(3);
```
- Stream từ một String.

String cũng có thể là một nguồn tạo ra stream.
Vì không có interface _CharStream_ trong JDK nên _IntStream_ được dùng để đại diện cho một stream gồm các phần tử kiểu char.
```java
IntStream streamOfChars = "abc".chars();
// hoặc dùng RegEx
Stream<String> streamOfString = Pattern.compile(",").splitAsStream("a","b","c");
```
- Stream từ một File
 Lớp `Files` trong Java NIO cho phép tạo ra một `Stream<String>` của một file văn bản bằng phương thức `line()`. Mỗi dòng của file text này sẽ trở thành một phần tử của stream.

```java
Path path = Paths.get("C:\\file.txt");
Stream<String> streamOfStrings = Files.lines(path);
Stream<String> streamWithCharset = Files.lines(path, Charset.forName("UTF-8"));
```
# 3. Tham chiếu đến một Stream
Có một điểm cần chú ý như đã nhắc trong bài viết trước, đó là sau khi sử dụng phép toán terminal thì stream sẽ coi như đã bị huỷ, muốn dùng lại thì phải tạo một stream mới. Ví dụ:
```java
Stream<String> stream = Stream.of("a","b", "c")
	.filter(element -> element.contains("b"));
Optional<String> anyElement = stream.finAny();
```
Đến đây thì đoạn code vẫn đúng. Nhưng nếu ta sử dụng biến stream để tiếp tục một phép toán terminal nữa thì một IllegalStateException sẽ được throw ra trong lúc chạy runtime.
```java
Optional<String> firstElement = stream.findFirst(); // IllegalStateException when runtime.
```
Để sửa lại đoạn code trên, ta có thể viết lại như sau:

```java
List<String> elements =
	Stream.of("a","b","c").filter(element -> element.contains("b")
	.collect(Collector.toList());
Optional<String> anyElement = elements.stream().findAny();
Optional<String> firstElement = elements.stream().findFirst();
```

# 4. Thứ tự thực thi
Để đảm bảo hiệu suất tốt nhất thì thứ tự thực thi các phép toán trong một stream pineline là điều quan trọng.
```java
long size = list.stream().map(element -> {
	wasCalled();
	return element.substring(0, 3);
}).skip(2).count();
```
trong đoạn code trên, stream có 3 phần tử -> method `map()` sẽ được gọi đến 3 lần. (chạy  Đổi vị trí `skip()` và `method`, phương thức `map()` sẽ chỉ phải gọi 1 lần, do đó hiệu suất hơn hẳn vì không cần phải `subtring()` 2 phần tử bị loại bỏ.
```java
long size = list.stream().skip(2).map(element -> {
	wasCalled();
	return element.substring(0, 3);
}).count();
```
Bài học rút ra là đối với các _intermediate operation_ làm giảm kích cỡ của stream thì nó nên được đặt trước các phép toán được sử dụng trên mỗi phần tử của stream. Vì vậy, luôn đặt các `skip()`, `filter()`, `distinct()` lên đầu của stream pineline.

# 5. Các phương thức reduction
Có nhiều phép toán terminal cho phép stream trả về một kết quả cụ thể như count(), max(), min(), sum()... Nhưng nếu ta không chỉ muốn trả về theo một công thức như tính tích của tất cả các phần tử, hay in tổng của chúng ra kèm với các số lẻ,... Chúng ta gọi chúng là các _reduction_ (làm giảm kích cỡ của stream thông qua một số thao tác nào đó.)
Có 2 loại `reduction` trong Stream API là `Aggregation` và `Collection`.

- Aggregation

Bao gồm các phép toán như sum, max, min,...
```java
List<Integer> ages = new ArrayList<>();
Stream<Integer> stream = ages.stream();
Integer sum = stream.reduce(0, (age1, age2) -> age1 + age2));
```
Tham số thứ nhất là `identity element` để xác định giá trị gốc của kết quả trả về, tham số thứ hai là `reduce operation` _(một reduce operation là một BinaryOperator, BinaryOperator là một Java Interface tương tự như Consumer, Predicate hay Function.)_

```java
List<Integer> list1 = Arrays.asList(10, 10);
Stream<Integer> stream1 = list1.stream();
BinaryOperation<Integer> sum = (i1, i2) -> i1 + i2;
Integer id1 = 0;

Integer reduce1 = stream1.reduce(id1, sum);

Stream<Integer> stream2 = Stream.empty();
// result is 0
Integer reduce2 = stream2.reduce(id1, sum);

Integer id2 = 100;
// result is 120
Integer reduce3 = stream1.reduce(id2, sum);

Integer id3 = 0;
List<Integer> list2 = Arrays.asList(10);
// resut is 10
Integer reduce4 = list2.stream.reduce(id3, Integer::max);

Integer id4 = 0;
List<Integer> list3 = Arrays.asList(-10);
// resut is 0
Integer reduce5 = list3.stream.reduce(id4, Integer::max);
```

- Collection

Collection hay còn gọi là mutable reduction, là việc gom hết tất cả các phần tử trả về từ stream sau khi mapping, filtering vào một container.
```Java
List<Person> people = new ArrayList<>();
String result = people.stream()
	.filter(p -> p.getAge() > 20)
	.map(Person::getLastname)
	.collect(Collectors.joining(","));

List<String> list = people.stream()
	.filter(p -> p.getAge() > 20)
	.map(Person::getLastname)
	.collect(Collectors.toList());

Map<Integer, List<Person>> map = people.stream()
	.filter(p -> p.getAge() > 20)
	.collect(Collectors.groupingBy(Person::getAge));
```

# 6. Mapping

Stream API cung cấp method map(), flatMap() thể thực hiện việc bước mapping, method này trả về một stream, vì thế nó chính là một intermediary operation.

Ngoài ra cũng như forEach() sử dụng Consumer hay filter() sử dụng Predicate, map() hay flatMap() sử dụng một thứ gọi là Function để quy định việc mapping, và Function cũng là một Functional Inteface.

```java
<R> Stream<R> flatMap(Function<T, Stream<R>> flatMapper);

<R> Stream<R> map(Function<T, R> mapper);
```

Cách dùng:

```java
Stream<String> names = Stream.of("tu", "bean", "tubean.github.io");
System.out.println(names.map(s -> {
    return s.toUpperCase();
  }).collect(Collectors.toList()));
//prints [TU, BEAN, TUBEAN.GITHUB.IO]
```

- Tham khảo:
https://www.baeldung.com/java-8-streams
https://codeaholicguy.com/2015/12/20/java-nhung-dieu-co-the-ban-da-biet-co-gi-moi-trong-java-8-phan-2/
