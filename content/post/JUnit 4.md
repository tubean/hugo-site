---
title: "[Java] Unit Test với JUnit 4x"
slug: junix-4x
date: 2018-11-30
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
Trong bài viết này chúng ta cùng tìm hiểu về test và _unit test_ bằng JUnit 4.x.

# 1. Một số thuật ngữ trong kiểm thử (testing)
## 1.1 Code under test
Những đoạn code được kiểm thử thường gọi **code under test**. Nếu bạn đang kiểm thử một ứng dụng nào đó thì nó được gọi là **application under test**.
## 1.2 Test fixture
Đây là các điều kiện để có thể bắt đầu kiểm thử. Ví dụ như là một đoạn String cố định được sử dụng để làm input cho một method nào đó. Chúng ta chỉ có thể kiểm thử nếu đoạn test đó có đầy đủ các thông số truyền vào.
## 1.3 Unit test và unit testing
Một _unit test_ là một đoạn code nhỏ được viết bởi developer nhằm mục đích kiểm tra một hàm hay chức năng riêng biệt nào đó có kết quả đúng như kì vọng hay không. Tỉ lệ các đoạn code được kiểm tra bằng _unit test_ được gọi là _test coverage_.
Phạm vi kiểm tra của một unit test thường là một method hoặc một class. Những method hay class có phụ thuộc lẫn nhau nên được tách biệt ra khi viết unit test. Vì vậy, unit test không phù hợp để kiểm thử những interface phức tạp hoặc một component. Chúng ta nên sử dụng _integration test_ cho những phạm vi lớn và phức tạp này.
## 1.4 Integration test
Một kiểm thử tích hợp (integration test) có nhiệm vụ kiểm tra hoạt động của một component hoặc một tập hợp các component. Loại kiểm thử này còn được biết đến với cái tên `funtional test`.

Integration test sẽ kiểm tra toàn bộ hệ thống có làm việc như mong muốn không, do đó chúng giúp làm giảm các công việc kiểm thử thủ công.
## 1.5 Performance test
Kiểm thử hiệu năng được sử dụng để đánh giá các thành phần trong phần mềm được dùng đi dùng lại nhiều lần. Mục đích là để kiểm tra khả năng chịu tải cao, tốc độ tải trong điều kiện nhiều request.
## 1.6 Behavior và state testing
Một đoạn test được gọi là `behavior test` nếu nó kiểm tra các phương thức với các parameter truyền vào là chính xác và không quan tâm đến kết quả trả về là gì.
Một đoạn test được gọi là  `state testing` nếu nó validate kết quả trả về.
## 1.7 Testing framework
Trong java thì chúng ta có một vài framework hỗ trợ việc kiểm thử. Tiêu biểu nhất là JUnit và TestNG. Trong bài viết này chúng ta sẽ tìm hiểu về JUnit 4.x.
## 1.8 Những đoạn test nên đặt ở đâu?
Thông thường thì các đoạn _unit test_ sẽ được tạo trong một folder hoặc một package riêng, tránh lẫn lộn với những đoạn code chính. Theo chuẩn build project của Maven và Gradle thì

-	`src/main/java` là nơi chứa Java class
-	`src/test/java` là nơi chứa test class.

# 2. Các tính năng chính của Junit

- Cung cấp Annotation để xác định việc xác thực phương thức.
- Cung cấp Asertion cho kết quả mong muốn.
- Cung cấp các Runner cho việc chạy thử.
- Giúp viết code nhanh hơn mà chất lượng ngày càng tăng.

# 3. Các annotation thường dùng
Dưới đây là những annotation thường được sử dụng nhất để viết test trong JUnit 4.

- `@Test` - Đánh dấu một method là một method dùng để kiểm thử.
- `@Before`  và `@After` : đánh dấu vị trí bắt đầu và kết thúc của một method test trong một class.
- `@BeforeClass` và `AfterClass`: Đánh dấu method chạy đầu tiên và cuối cùng trong một class test.
- `@Ignore` hoặc `@Ignore("Why disabled")`: đánh dấu đoạn test nên được _disabled_. Nó được sử dụng khi các đoạn code chính đã được thay đổi nhưng các test case chưa được cập nhật hoặc điều chỉnh hoặc thời gian thực thi quá lâu nếu phải bao gồm cả nó. Tốt nhất là nên kèm theo giải thích tại sao lại disabled khi sử dụng annotation này.
- `@Test(timeout=100)`: Đoạn test sẽ được đánh là thất bại nếu thời gian thực thi lớn hơn 100 miliseconds.

Ví dụ:
 ```
public class SampleTest {

        @BeforeClass
        public static void setUpBeforeClass() throws Exception {


            //Method annotated with `@BeforeClass` will execute once before any of the test methods
            //in this class.

            //This method could be used to set up any test fixtures that are computationally expensive
            //and shared by several test methods. e.g. establishing database connections

            //Sometimes several tests need to share computationally expensive setup
            //(like logging into a database). While this can compromise the independence of tests,
            //sometimes it is a necessary optimization.
            //From http://junit.sourceforge.net/javadoc/org/junit/BeforeClass.html

        }

        @AfterClass
        public static void tearDownAfterClass() throws Exception {

            //Method annotated with `@AfterClass` will execute once after all of the test
            //methods are executed in this class.

            //If you allocate expensive external resources in a BeforeClass method you need
            //to release them after all the tests in the class have run. Annotating
            //a public static void method with @AfterClass causes that method to be
            //run after all the tests in the class have been run. All @AfterClass methods
            //are guaranteed to run even if a BeforeClass method throws an exception.
            //From http://junit.sourceforge.net/javadoc/org/junit/AfterClass.html
        }

        @Before
        public void setUp() throws Exception {
             //Method annotated with `@Before` will execute before each test method
             //in this class is executed.

             //If you find that several tests need similar objects created before they
             //can run this method could be used to do set up those objects (aka test-fixtures).
        }

        @After
        public void tearDown() throws Exception {

             //Method annotated with `@After` will execute after each test method
             //in this class is executed.

             //If you allocate external resources in a Before method you must
             //release them in this method.
        }

        @Test
        public void test1() {

           //A public void method annotated with @Test will be executed as a test case.
        }

        @Test
        public void test2() {

            //Another test cases
        }

    }
```

Khi chạy đoạn code trên thì thứ tự thực thi sẽ là:

 1. Method được đánh dấu `@BeforeClass`.
 2. Method được đánh dấu `@Before`.
 3. Method kiểm thử đầu tiên được đánh dấu `@Test` (ở đây là `test1()`).
 4. Method được đánh dấu `@After`.
 5. Method được đánh dấu `@Before`.
 6. Method kiểm thử thứ hai được đánh dấu `@Test` ( ở đây là `test2()`).
 7. Method được đánh dấu `@After`.
 8. Method được đánh dấu `@AfterClass`.

 # 4. Assertions
 Khi muốn xác nhận một kết quả trả về có đúng như mong muốn không, chúng ta có danh sách Junit assertion cũ như sau:

-   org.junit.Assert.assertArrayEquals
-   org.junit.Assert.assertEquals
-   org.junit.Assert.assertFalse
-   org.junit.Assert.assertNotNull
-   org.junit.Assert.assertNotSame
-   org.junit.Assert.assertNull
-   org.junit.Assert.assertSame
-   org.junit.Assert.assertTrue

Từ phiên bản JUnit4, chúng ta có thêm một method `org.junit.Assert.assertThat` cho phép sử dụng các `matcher` để xác nhận tốt hơn:

-   Dễ đọc hơn
    -   `assertThat(actual, is(equalTo(expected)));`  dễ đọc hơn  `assertEquals(expected, actual);`
    -   `assertThat(actual, is(not(equalTo(expected))));`  tốt hơn`assertFalse(expected.equals(actual));`
-   Thông báo lỗi tốt hơn
    -   `java.lang.AssertionError: Expected: is "hello" but: was "hello world"`  tốt hơn

        `org.junit.ComparisonFailure: expected:<hello[]> but was:<hello[ world]>`

-   Linh hoạt hơn
    -   Có thể sử dụng nhiều điều kiện để assert bằng cách dùng các matcher như `anyOf`  hay `allOf`.

        vd:  `assertThat("hello world", anyOf(is("hello world"), containsString("hello")));`  Trong trường hợp này thì test sẽ pass nếu trong đoạn String "hello world" có chứa đoạn String "hello".
Các đoạn matchers khác có thể tham khảo thêm trong bảng [hamcrest docs](http://hamcrest.org/JavaHamcrest/javadoc/1.3/org/hamcrest/CoreMatchers.html).
Ví dụ một vài cách sử dụng matcher:

```java
@Test
public void testAssetThatExamples() {

    // 'theString' should contain 'S' and 'r'
    assertThat("theString", both(containsString("S")).and(containsString("r")));

    List<String> items = Arrays.asList("John", "James", "Julia", "Jim");

    // items list should have James and Jim
    assertThat(items, hasItems("James", "Jim"));

    // Every item in the list should have the character 'J'
    assertThat(items, everyItem(containsString("J")));

    // check all of the matchers
    assertThat("Once", allOf(equalTo("Once"), startsWith("O")));

    // negation of all of the matchers
    assertThat("Once", not(allOf(equalTo("test"), containsString("test"))));
}
```
# 5. Exception testing
Nếu phương thức bạn cần kiểm thử có throw các exceptions thì chúng ta cũng có vài cách để kiểm tra xem nó có throw đúng như trong điều kiện mong muốn không. Ví dụ như chúng ta tạo một phương thức để đọc file và nó sẽ trả về một exception với message "The file ${file_name} does not exit!" trong trường hợp không tìm thấy file đó.

1. Sử dụng parameter `expected`:

```java
@Test(expected = FileNotFoundException.class)
    public void testReadFile() throws IOException {
        FileReader reader = new FileReader("test.txt");
        reader.read();
        reader.close();
    }
```
2. Sử dụng `try` `catch`:

```java
@Test
    public void testReadFile2() {
        try {
            FileReader reader = new FileReader("test.txt");
            reader.read();
            reader.close();
            fail("Expected an IOException to be thrown");
        } catch (IOException e) {
            assertThat(e.getMessage(), is("test.txt (No such file or directory)"));
        }

    }
```
3. Sử dụng `@Rule` `ExpectedException`:

```java
@Rule
    public ExpectedException thrown = ExpectedException.none();

    @Test
    public void testReadFile3() throws IOException {

        thrown.expect(IOException.class);
        thrown.expectMessage(startsWith("test.txt (No such file or directory)"));
        FileReader reader = new FileReader("test.txt");
        reader.read();
        reader.close();
    }
```
# 6. Parameterize tests
Thông thường chúng ta cần kiểm tra một method đơn với nhiều loại data test khác nhau hoặc nhiều input khác nhau. Trong trường hợp này chúng ta có `Parameterized` để thực hiện kiểm thử một cách dễ dàng và dễ đọc.
```
@RunWith(Parameterized.class)
public class GreetingTest {

    @Parameters
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][] {
                 { "hello world", 10 }, { "helloworld", 10 }, { "hello", 5 }
                 //The first item in the array is the input, and second is the expected outcome.
           });
    }

    private String input;
    private int expected;

    //This constructor must be provided for the parameterized tests to work.
    public GreetingTest(String input, int expected) {
        this.input = input;
        this.expected = expected;
    }

    @Test
    public void test() {

        Greeting greeting = new Greeting();
        assertThat(greeting.getTotalCharactersWithoutSpaces(input), is(expected));
    }

}
```
Trong ví dụ trên thì phương thức `getTotalCharactersWithoutSpaces` đã đếm số lượng các kí tự trong một chuỗi (không tính dấu space). Chúng ta có các trường hợp khác nhau với những input là những chuỗi String khác nhau. Nếu không sử dụng `Parameterized`, chúng ta sẽ phải lặp lại một đoạn test đến 3 lần, mỗi lần dành cho một đoạn String.
Để tìm hiểu thêm về Parameterized, các bạn có thể xem thêm tại [đây](https://github.com/junit-team/junit4/wiki/Parameterized-tests).

# Tham khảo:
https://javacodehouse.com/blog/junit-tutorial/

http://www.vogella.com/tutorials/JUnit/article.html
