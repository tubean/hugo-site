---
title: "[Java] Unit Test với JUnit 5x"
slug: junix-5x
date: 2018-12-01
categories:
- Java
- Testing
tags:
- Java
- Test
- JUnit
keywords:
- java
- test
- testcase
- junit
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543633941/junit.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Phiên bản hiện tại của JUnit là JUnit 5 và nó bao gồm các component khác nhau:

-	`JUnit Platform`: layer nền tảng cho phép những testing framework có thể chạy trên máy ảo JVM.
-	`JUnit Jupiter`: đây chính là phiên bản JUnit 5 và được chạy trên JUnit Platform.
-	`JUnit Vintage`: kế thừa từ TestEngine và cho phép chạy các phiên bản cũ hơn của JUnit.

# 1. Cài đặt bằng Gradle
```
buildscript {
    repositories {
        mavenCentral()
        // The following is only necessary if you want to use SNAPSHOT releases.
        // maven { url 'https://oss.sonatype.org/content/repositories/snapshots' }
    }
    dependencies {
        classpath 'org.junit.platform:junit-platform-gradle-plugin:1.0.0'
    }
}

repositories {
    mavenCentral()
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'org.junit.platform.gradle.plugin'

dependencies {
    testImplementation("org.junit.jupiter:junit-jupiter-api:5.0.0")
    testRuntime("org.junit.jupiter:junit-jupiter-engine:5.0.0")
    // to run JUnit 3/4 tests:
    testImplementation("junit:junit:4.12")
    testRuntime("org.junit.vintage:junit-vintage-engine:4.12.0")
}
```
Sau khi cài đặt thì chúng ta có thể thực thi JUnit 5 thông qua lệnh terminal:
```
gradle junitPlatformTest
```
# 2. Cài đặt bằng Maven
Một ví dụ best practice để cài đặt JUnit 5 bằng Maven:

```
<build>
    <plugins>
        <plugin>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.1</version>
            <configuration>
                <source>${java.version}</source>
                <target>${java.version}</target>
            </configuration>
        </plugin>
        <plugin>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>2.19.1</version>
            <configuration>
                <includes>
                    <include>**/Test*.java</include>
                    <include>**/*Test.java</include>
                    <include>**/*Tests.java</include>
                    <include>**/*TestCase.java</include>
                </includes>
                <properties>
                    <!-- <includeTags>fast</includeTags> -->
                    <excludeTags>slow</excludeTags>
                </properties>
            </configuration>
            <dependencies>
                <dependency>
                    <groupId>org.junit.platform</groupId>
                    <artifactId>junit-platform-surefire-provider</artifactId>
                    <version>${junit.platform.version}</version>
                </dependency>
                <dependency>
                    <groupId>org.junit.jupiter</groupId>
                    <artifactId>junit-jupiter-engine</artifactId>
                    <version>${junit.jupiter.version}</version>
                </dependency>
                <dependency>
                    <groupId>org.junit.vintage</groupId>
                    <artifactId>junit-vintage-engine</artifactId>
                    <version>${junit.vintage.version}</version>
                </dependency>
            </dependencies>
        </plugin>
    </plugins>
</build>
```
và sau đó chúng ta thêm các dependency:
```
<dependencies>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter-api</artifactId>
        <version>${junit.jupiter.version}</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>${junit.version}</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

# 3. Một số annotation phổ biến
Bảng dưới đây sẽ tổng hợp một số annotation quan trọng trong Junit 5:

|import org.junit.jupiter.api.*  | import package này để sử dụng các annotation dưới đây|
|---|---|
| **@Test** | định nghĩa một method là test method |
| **@RepeatedTest(n)** | Lặp lại việc kiểm thử n lần |
| **@TestFactory** | Đánh dấu method là một Factory cho dynamic test. |
| **@BeforeEach** | Thực thi trước khi test. Cái này thường được đánh dấu những method cho việc chuẩn bị môi trường|
| **@AfterEach** | Thực thi sau khi test. Thường được đánh dấu những method có nhiệm vụ dọn dẹp môi trường|
| **@BeforeAll** | Thực hiện một lần duy nhất và là method chạy đầu tiên chạy một class test.|
| **@AfterAll** | Thực hiện một lần duy nhất và là method cuối cùng chạy trong một class test.|
| **@Neste** | Cho phép bạn lồng các class test để thực hiện theo thứ tự.|
| **@Tag("{tagName}")** | Việc kiểm thử trong JUnit 5 có thể được lọc bởi tag. Ví dụ như bạn chỉ muốn chạy các test case được đánh dấu là "run" thì sẽ đặt annotation @Tag("run").|
| **@ExtendWith** | Cho phép bạn đăng ký một lớp Extension để tích hợp với một hoặc nhiều điểm mở rộng.|
| **@Disabled** hoặc **@Disabled("Why disabled")** | Đánh dấu những method test nào có thể bỏ qua không cần run.|
| **DisplayName("{name}")** | giúp hiển thị tên các method khi chạy một cách dễ nhìn và dễ đọc hơn.|

# 4. Disabling test

Annotation `Disabled` cho phép bỏ qua phương thức test đó. Ngoài ra bạn có thể sử dụng: `Assumptions.assumeFalse` hoặc `Assumptions.assumeTrue` để định nghĩa một điều kiện cho việc bỏ qua kiểm thử.

- `Assumptions.assumeFalse` đánh dấu đoạn test là không hợp lệ nếu điều kiện của nó được đánh giá là _true_.
- `Assumptions.assumeTrue` ngược lại, đánh dấu đoạn test là không hợp lệ nếu điều kiện của nó là _false_.

Ví dụ nếu bạn không muốn chạy test trên môi trường Linux:

```java
Assumptions.assumeFalse(System.getProperty("os.name").contains("Linux"));
```

# 5. Test Suites

Để chạy nhiều đoạn test với nhau, chúng ta sẽ dùng _test suites_. JUnit 5 cung cấp 2 annotation:

- `@SelectPackages`: dùng để chỉ định tên của package sử dụng cho test suite.
- `@SelectClasses`: dùng để chỉ định những lớp sử dụng cho test suite. Chúng có thể nằm ở những package khác nhau.

```java
@RunWith(JUnitPlatform.class)
@SelectPackages("io.github.tubean.example")
public class AllTests {}

@RunWith(JUnitPlatform.class)
@SelectClasses({AssertionTest.class, AssumptionTest.class, ExceptionTest.class})
public class AllTests {}
```
# 6. Expecting Exception
Những ngoại lệ sẽ được xử lý bởi `org.junit.jupiter.api.Assertions.expectThrows()`. Bạn có thể định nghĩa các Exception class và chỉ định cách để throw một Exception:

```java
import static org.junit.jupiter.api.Assertions.expectThrows;

@Test
void exceptionTesting() {
    // set up user
    Throwable exception = expectThrows(IllegalArgumentException.class, () -> user.setAge("23"));
    assertEquals("Age must be an Integer.", exception.getMessage());
}
```
Điều này cho phép bạn phần nào xác định được đoạn code nào nên được throw exception. Ngoài phạm vi đoạn code đó thì chương trình sẽ vẫn được coi là thất bại nếu có một exception khác.

# 7. Grouped assertion
```java
@Test
void groupedAssertions() {
    Address address = new Address();
    // In a grouped assertion all assertions are executed, even after a failure.
    // The error messages get grouped together.
    assertAll("address name",
        () -> assertEquals("Tu", address.getFirstName()),
        () -> assertEquals("Bean", address.getLastName())
    );
}
    => org.opentest4j.MultipleFailuresError: address name (2 failures)
    expected: <Tu> but was: <null>
    expected: <Bean> but was: <null>
```

# 8. Timeout test
Nếu bạn muốn chắc chắn việc kiểm thử là thất bại nếu không hoàn thành trong một thời gian cho trước thì phương thức `assertTimeout()` sẽ hữu dụng với bạn.
```java
import static org.junit.jupiter.api.Assertions.assertTimeout;
import static java.time.Duration.ofSeconds;
import static java.time.Duration.ofMinutes;

@Test
void timeoutNotExceeded() {
    assertTimeout(ofMinutes(1), () -> service.doBackup());
}

// if you have to check a return value
@Test
void timeoutNotExceededWithResult() {
    String actualResult = assertTimeout(ofSeconds(1), () -> {
        return restService.request(request);
    });
    assertEquals(200, request.getStatus());
}
=> org.opentest4j.AssertionFailedError: execution exceeded timeout of 1000 ms by 212 ms
```

Nếu bạn muốn kiểm tra việc hủy bỏ sau khi khoảng thời gian chờ kết thúc, bạn có thể sử dụng phương thức `assertTimeoutPreemptively()`.

```java
@Test
void timeoutNotExceededWithResult() {
    String actualResult = assertTimeoutPreemptively(ofSeconds(1), () -> {
        return restService.request(request);
    });
    assertEquals(200, request.getStatus());
}
=> org.opentest4j.AssertionFailedError: execution timed out after 1000 ms
```
# 9. Running the same test repeatedly on a data set
Thỉnh thoảng chúng ta muốn chạy cùng một đoạn test trên một tập dữ liệu. Thông thường thì chúng ta sẽ truyền tập dữ liệu dưới dạng một Collection và xử lý theo vòng lặp một cách tuần tự, một lần thất bại sẽ kéo theo cả đoạn code được đánh giá là thất bại. Tuy nhiên JUnit 5 đã cung cấp thêm cho chúng ta nhiều cách để làm điều này.
## 9.1 Using Dynamic Test
JUnit cung cấp khả năng xác định các dynamic test. Chúng ta có thể sử dụng để viết lại ví dụ của mình. Các phương thức dynamic được đánh dấu với `@TestFactory` và có thể trả về một Interable, một Collection hoặc một Stream Dynamic Test. JUnit sau đó sẽ chạy từng dynamic test khi đoạn test được thực thi. Các phương thức được đánh dấu anotation `@BeforeEach` và  `@AfterEach` sẽ không được gọi trong dynamic test.

```java
  class DynamicTestsDemo {

    // This will result in a JUnitException!
    @TestFactory
    List<String> dynamicTestsWithInvalidReturnType() {
      return Arrays.asList("Hello");
    }

    @TestFactory
    Collection<DynamicTest> dynamicTestsFromCollection() {
      return Arrays.asList(
      dynamicTest("1st dynamic test", () -> assertTrue(true)),
      dynamicTest("2nd dynamic test", () -> assertEquals(4, 2 * 2))
      );
    }

    @TestFactory
    Iterable<DynamicTest> dynamicTestsFromIterable() {
      return Arrays.asList(
      dynamicTest("3rd dynamic test", () -> assertTrue(true)),
      dynamicTest("4th dynamic test", () -> assertEquals(4, 2 * 2))
      );
    }

    @TestFactory
    Iterator<DynamicTest> dynamicTestsFromIterator() {
      return Arrays.asList(
      dynamicTest("5th dynamic test", () -> assertTrue(true)),
      dynamicTest("6th dynamic test", () -> assertEquals(4, 2 * 2))
      ).iterator();
    }

    @TestFactory
    Stream<DynamicTest> dynamicTestsFromStream() {
      return Stream.of("A", "B", "C")
    .map(str -> dynamicTest("test" + str, () -> { /* ... */ }));
  }

  @TestFactory
  Stream<DynamicTest> dynamicTestsFromIntStream() {
     // Generates tests for the first 10 even integers.
     return IntStream.iterate(0, n -> n + 2).limit(10)
     .mapToObj(n -> dynamicTest("test" + n, () -> assertTrue(n % 2 == 0)));
   }

   @TestFactory
   Stream<DynamicTest> generateRandomNumberOfTests() {
     // Generates random positive integers between 0 and 100 until
     // a number evenly divisible by 7 is encountered.
     Iterator<Integer> inputGenerator = new Iterator<Integer>() {
       Random random = new Random();
       int current;

       @Override
       public boolean hasNext() {
         current = random.nextInt(100);
         return current % 7 != 0;
       }

       @Override
       public Integer next() {
         return current;
       }
     };

     // Generates display names like: input:5, input:37, input:85, etc.
     Function<Integer, String> displayNameGenerator = (input) -> "input:" + input;
     // Executes tests based on the current input value.
     ThrowingConsumer<Integer> testExecutor = (input) -> assertTrue(input % 7 != 0);
     // Returns a stream of dynamic tests.
     return DynamicTest.stream(inputGenerator, displayNameGenerator, testExecutor);
   }

   @TestFactory
   Stream<DynamicNode> dynamicTestsWithContainers() {
     return Stream.of("A", "B", "C")
     .map(input -> dynamicContainer("Container " + input, Stream.of(
     dynamicTest("not null", () -> assertNotNull(input)),
     dynamicContainer("properties", Stream.of(
     dynamicTest("length > 0", () -> assertTrue(input.length() > 0)),
     dynamicTest("not empty", () -> assertFalse(input.isEmpty()))
     ))
     )));
   }
}
```

## 9.2 Using Parameterized Test
```
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;

public class DynamicTestCreationTest {

    public static int[][] data() {
        return new int[][] { { 1 , 2, 2 }, { 5, 3, 15 }, { 121, 4, 484 } };
    }

    @ParameterizedTest
    @MethodSource(names = "data")
    void testWithStringParameter(int[] data) {
        MyClass tester = new MyClass();
        int m1 = data[0];
        int m2 = data[1];
        int expected = data[2];
        assertEquals(expected, tester.multiply(m1, m2));
    }

    // class to be tested
    class MyClass {
        public int multiply(int i, int j) {
            return i * j;
        }
    }
}
```
Trong ví dụ trên chúng ta sử dụng annotation `@MethodSource` để định nghĩa tên của function sẽ tạo ra data source. Function này phải là static và trả về một Collection, Interator, Stream hoặc một Array.

# 10. Bảng so sánh annotation giữa JUnit 4 và 5

|JUnit 5|JUnit 4|Mô tả|
|---|---|---|
| **import org.junit.jupiter.api.** |  *import org.junit.**|------------------------------------------------------- Câu lệnh import package cần để sử dụng các annotation sau:|
|**@Test**|**@Test**|Định nghĩa một test method|
|**@BeforeEach**|**@Before**|Thực thi trước mỗi đoạn test. Nó được sử dụng để tạo môi trường test như là đọc các input. khởi tạo class|
|**@AfterEach**|**@After**|Thực thi sau mỗi đoạn test, nhiệm vụ dọn dẹp môi trường như xóa các data tạm, restore về mặc định giúp tiết kiệm bộ nhớ.
|**@BeforeAll**|**@BeforeClass**|Thực hiện một lần duy nhất trước khi bắt đầu test trong một class.|
|**@AfterAll**|**@AfterClass**|Thực hiện một lần duy nhất sau tất cả các method khác trong một class.|
|**Disabled** hoặc **Disabled("Why disabled")**|**@Ignore** hoặc **@Ignore("Why disabled")**|Đánh dấu đoạn test được bỏ qua.|
|Không sử dụng, được thay bởi **org.junit.jupiter.api .Assertions.expectThrows()**|**@Test(expected = Exception.class)**|Thất bại nếu method đó không throw ra đúng exception mong muốn.|
|Không sử dụng, được thay bằng **AssertTimeout .assertTimeout()** và **AssertTimeout .assertTimeoutPreemptively()**|**@Test(timeout=100)**| Thất bại nếu phương thức thực thi lâu hơn 100 miliseconds.|

# Tham khảo
http://www.vogella.com/tutorials/JUnit/article.html
