

---
title: "[Java 8] Stream trong Java 8 (Phần 1)"
slug: java-stream
date: 2018-11-08
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
 `Lambda expression` kể từ trở thành một phần của Java thì đã làm thay đổi đáng kể thói quen sử dụng các Collection như chúng ta đã từng dùng ở các phiên bản trước Java 8. Mặc dù có thể xây dựng lại một bộ API Collections thay thế, nhưng nó sẽ ảnh hưởng rất lớn đến toàn bộ hệ sinh thái Java. Vì vậy mà những nhà phát triển Java đã có một chiến lược tốt hơn, đó là thêm các phương thức mở rộng vào các interface có sẵn (như là Collection, List, Iterable,...) cùng các lớp abstraction như Stream để thực hiện các phép toán tổng hợp trên tập dữ liệu, cung cấp thêm cho các lớp hiện có các phương thức để có thể làm việc với Stream mà không ảnh hưởng với các cách làm việc cũ.
Trong bài viết này, chúng ta cùng tìm hiểu Stream là gì và các đặc điểm của nó.
# 1. Stream là gì?

Stream là một tính năng mới được giới thiệu trong Java 8, được đặt trong package `java.util.stream`. Xem trong package này ta có thể thấy vài loại stream như `Stream<T>`đại diện cho một stream của các đối tượng tham chiếu, hoặc dành riêng cho các kiểu nguyên thuỷ (primitives) như `IntStream`, `LongStream`, `DoubleStream`. Một stream đại diện cho một chuỗi giá trị và cho phép dùng các phép toán để thao tác với các giá trị đó một cách dễ dàng và rõ ràng. Các thư viện cung cấp tính năng làm việc với stream là collections, arrays và các data sources khác.
Ví dụ để thay màu xanh bằng màu đỏ cho một tập hợp các hình dạng, ta có thể viết như sau:
```java
shapes.stream()
	.filter(s -> s.getColor() == BLUE)
	.forEach(s -> s.setColor(RED));
```
Để dễ hiểu hơn, chúng ta cùng đi vào so sánh stream và collection.

# 2. Streams vs Collections
Vài điểm khác biệt giữa 2 khái niệm này có thể kể đến như sau:

- **Không lưu trữ:** Mục đích của các collection là lưu trữ, quản lý và truy cập vào các element. Trong khi đó thì stream không phải một kiểu cấu trúc dữ liệu để lưu trữ các element. Chúng chỉ đem các giá trị từ một source nào đó ( có thể là một cấu trúc dữ liệu, một mảng hay I/O channel nào đó) qua một loạt các bước tính toán. ( _a pipeline of computational steps_)
- **Không chỉnh sửa:** Các phép tính trong một stream sẽ tạo ra một kết quả riêng mà không làm thay đổi giá trị của data source đầu vào.
- **Laziness-seeking:** Có nhiều phép toán trong stream, như là _filtering_, _mapping_, _sorting_, _duplicate removal_ có thể thực hiện một cách lazy.
- **Giới hạn không bắt buộc:** Sẽ thật không may nếu số lượng các phép toán trong một stream bị giới hạn, như để tìm số nguyên tố trong một tập cho trước, chúng ta phải sử dụng rất nhiều phép toán trên một element để xem nó có phù hợp không. Vì vậy stream cho phép chúng ta tính toán không giới hạn trong một thời gian hữu hạn.
- **Tiêu hao (Consumable):** Các thành phần của một stream chỉ được duyệt 1 lần trong vòng đời của 1 stream. Để duyệt lại các đối tượng thì stream cần được sinh lại.

Như một API, Stream hoàn toàn độc lập với Collections, mặc dù phần nhiều chúng ta sẽ dùng collection như một datasource để tạo ra một stream (Collection sử dụng 2 phương thức `stream()` và `parallelStream()`). Sự thật thì bất kì thứ gì có thể miêu tả với một `Iterator` thì đều có thể là một nguồn để tạo stream, như là BufferedReader, Random, BitSet hay Array,...

# 3. Tính lười biếng (Laziness)
Các phép toán như lọc hay mapping bình thường (nói chung không tính riêng trong Stream) đều có thể thực hiện một cách `eagerly` (tức là thực hiện việc lọc trước khi cần lấy kết quả của việc lọc), hoặc là `lazily` (tức là Stream sẽ khai báo một phương thức lọc và chỉ thực hiện lọc khi cần). Chúng ta hiểu đơn giản như là đi ăn ở nhà hàng, chúng ta gọi món thì sẽ có những món đã được làm sẵn trước đó (eagerly), hoặc là những món khi chúng ta gọi mới bắt đầu được làm (lazily).
Trong thực tế thì việc tính toán một cách lazy sẽ đem lại nhiều hiệu quả hơn. Cùng xem một ví dụ:
```java
int sum = shapes.stream()
	.filter(s -> s.getColor() == BLUE)
	.mapToInt(s -> s.getWeight())
	.sum();
```
Trong ví dụ trên thì `filter` và `mapping` được coi là lazy. Có nghĩa là chúng ta sẽ không thực hiện việc lọc, map cho tới khi chúng ta thực hiện phép tính tổng. Và khi chúng ta thực hiện phép tính tổng, chúng ta đã hợp nhất các phép lọc, mapping và truyền nó qua một stream duy nhất. Điều này làm giảm chi phí lưu trữ các thứ trung gian. (Ví dụ nếu thực hiện một cách `eagerly` thì sau khi thực hiện filter() sẽ phải lưu tạm đâu đó để chờ được gọi, tiếp đến khi nào mapping thì mới lấy kết quả của filter rồi lại lưu tiếp đâu đó chờ tính tổng).

# 4. Các loại toán tử của Stream
Có thể chia toán tử trong Stream ra làm 2 loại:

-	Intermediate operation: toán tử trung gian trả về một stream mới. Chúng luôn là lazy. Ví dụ là như filter(), mapping(),... Stream được tạo từ intermediate sẽ không được thực hiện cho đến khi có một toán tử terminal hay Final Operation được thực hiện.
-  Terminal/Final operation: toán tử đầu cuối, sẽ duyệt (thực thi) 1 stream để trả về 1 kết quả. Sau khi toán tử terminal được thực hiện, stream sẽ được xét như là đã được tiêu thụ, dùng (consumed), không còn được sử dụng nữa. Trong trường hợp bạn vẫn muốn duyệt cùng kiểu tập hợp dữ liệu đó, bạn cần phải quay lại data source và tạo ra stream mới.

```java
List<Person> result = new ArrayList<>();
List<Person> people = new ArrayList<>();
people.stream()
  .peek(System.out::println)
  .filter(p -> p.getAge() > 20)
  .peek(result::add);
```

_peek() là một method tương tự như forEach() nhưng thay vì không trả về gì như forEach thì nó trả về một Stream như filter()._

Thử chạy đoạn code trên bạn sẽ thấy chẳng có gì được in ra màn hình cũng như chẳng có gì được add vào result. Thay đổi đoạn code trên thành như sau:
```java
people.stream()
  .peek(System.out:println)
  .filter(p -> p.getAge() > 20)
  .forEach(result::add);
```
Bạn sẽ thấy trên màn hình xuất ra list Person. Ở đây, forEach() đóng vai trò là một Terminal Operator, và nó sẽ kích hoạt quá trình xử lý Stream.

Toán tử intermediate có thể chia làm 2 loại: stateless và stateful operation:

- Toán tử stateless như filter và map: không giữ lại trạng thái của phần tử trước đó khi đang xử lý hay tương tác với một đối tượng mới.
- Toán tử statefull như distinct và sorted: có thể sử dụng trạng thái của đối tượng trước để xử lý hay tương tác đối tượng mới. Stateful thường đòi hỏi duyệt toàn bộ data source trước khi tạo ra kết quả.	Đặc điểm này cũng là yếu tố cần cân nhắc khi quyết định sử dụng đơn stream hay song song stream.

# 5. Paralleism

Stream pipeline có thể được xử lý tuần tự hoặc song song, lựa chọn này là một phần thuộc tính của stream. JVM thực thi stream mặc định là theo tuần tự và chỉ thực hiện song song khi được khai báo chính xác.

Trong một Collection thì để tạo một stream tuần tự, ta dùng method `stream()`, còn muốn tạo stream sông song thì dùng method `parallelStream`.

 Để xác định mode của stream thì sử dụng method `isParallel()`
 ```Java
studentList.stream().filter(st -> st.getPoint() > 5).filter(st -> st.getName().equals("Bean")).isParallel();

```

 Để thay đổi mode của stream, ta sử dụng 2 method sequential() và parallel(). Ví dụ:
 ```Java
studentList.stream().filter(st -> st.getPoint() > 5).filter(st -> st.getName().equals("Bean")).parallel();

```

Phần tiếp theo của bài viết, tôi sẽ trình bày cách sử dụng Stream cũng như khi nào thì sử dụng nó.


_Tham khảo:_

- https://viblo.asia/p/cac-khai-niem-va-dac-diem-cua-stream-trong-java-8-WApGxNnoR06y
- http://www.drdobbs.com/jvm/lambdas-and-streams-in-java-8-libraries/240166818?pgno=2
- https://kipalog.com/posts/Java-nhung-dieu-co-the-ban-da-biet--Co-gi-moi-trong-Java-8--Phan-1
