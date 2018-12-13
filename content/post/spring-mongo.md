---
title: "[Spring Boot] Dựng app CRUD đơn giản bằng Spring Boot + MongoDB trên Intelij"
slug: spring-boot-mongo-db
date: 2018-12-13
categories:
- Spring
- Tutorial
- SpringBoot
- MongoDB
tags:
- Spring Boot
- Tutorial
- MongoDB
keywords:
- Spring
- Hướng dẫn
- Spring Boot
- MongoDB
- Crud app
- NoSQL
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542422606/spring-boot-icon0_cf21dec4-5056-b3a8-49c015fd3bde6cb5.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
MongoDB hiện đang là cơ sở dữ liệu NoSQL phổ biến nhất. Bài viết này là một hướng dẫn nhỏ về cách sử dụng Spring Boot kết hợp với MongoDB để tạo một app dạng CRUD.

# Các tool sử dụng:
1. Java
2. Spring Boot
3. Maven
4. MongoDB
5. Postman

# 1. Tạo database
Trước khi bắt đầu xây dựng app, chúng ta cần chuẩn bị một instance của MongoDB để truy xuất tới nó. Cách cài đặt MongoDB các bạn có thể tìm kiếm trên mạng. Tôi sẽ giả sử các bạn cài đặt xong MongoDB và bắt đầu tạo một database `spring_mongo` như sau:
```
use spring_mongo;
```
Sau khi tạo xong database, chúng ta tạo một collection (tương đương với các bảng) và dữ liệu cho nó:
```
// Tạo collection
db.createCollection(“contact”);

// Insert data
db.contact.insertMany([
{
"name":"Tu Bean",
 "age":"24",
 "email":"tubean@github.io"
 },
{
"name": "Vi Quynh",
 "age":"21",
 "email":"viquynh@gmail.com"
 }
 ]);
```
Trong collection trên, chúng ta sẽ lưu trữ data dưới dạng JSON và có các key là `name`, `age`, `email`. Nếu sử dụng truy vấn `db.contact.find({});` thì MongoDB sẽ tự động tạo cho mỗi field một `_id` duy nhất để dễ tìm kiếm và thao tác.

Chúng ta sẽ tạo thêm một `user` để có thể truy cập vào database này:
```
db.createUser(  
  {  
    user: "tubean",  
    pwd: "tubean",  
    roles: [ { role: "readWrite", db: "contact" } ]  
  }  
)
```
# 2. Tạo project Spring Boot từ Intelij
Đầu tiên chúng ta khởi động intellij, chọn new project -> Spring Initializr
![khởi tạo dự án](https://res.cloudinary.com/deop9ytsv/image/upload/v1542364170/Screen_Shot_2018-11-16_at_11.22.22_AM.png)

- Chọn Next, điền các thông tin `Group`, `Artifact`, `Name`, `Description`

![thông tin cơ bản](https://res.cloudinary.com/deop9ytsv/image/upload/v1544716944/mg_1.jpg)

- Chọn tiếp các `dependencies` cần thiết: `Web`, `MôngDB`:

![dependencies](https://res.cloudinary.com/deop9ytsv/image/upload/v1544716943/mg_2.jpg)

- Đặt tên project và finish bước khởi tạo.

# 3. Cấu trúc dự án

Cây thư mục dự án như sau:

![structure](https://res.cloudinary.com/deop9ytsv/image/upload/v1544717091/mg_3.jpg)
File `pom.xml` có các dependencies như sau:
```xml
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-data-mongodb</artifactId>  
</dependency>  
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-web</artifactId>  
</dependency>
```
# 4. Tạo Model
Trước tiên chúng ta cần tạo một model để lưu trữ cấu trúc của document "contact" trong collection, tương tự như entity khi sử dụng cơ sở dữ liệu dạng sql.
```java
public class Contact {  
    @Id  
  private ObjectId _id;  

    private String name;  
    private Integer age;  
    private String email;  

    public Contact() {  
    }  

    public Contact(ObjectId _id, String name, Integer age, String email) {  
        this._id = _id;  
        this.name = name;  
        this.age = age;  
        this.email = email;  
    }  

    public String get_id() {  
        return _id.toHexString();  
    }  

    public void set_id(ObjectId _id) {  
        this._id = _id;  
    }  

    public String getName() {  
        return name;  
    }  

    public void setName(String name) {  
        this.name = name;  
    }  

    public Integer getAge() {  
        return age;  
    }  

    public void setAge(Integer age) {  
        this.age = age;  
    }  

    public String getEmail() {  
        return email;  
    }  

    public void setEmail(String email) {  
        this.email = email;  
    }  

    @Override  
  public String toString() {  
        return "{" +  
                "\"name\":" + "\"" + name + "\"" +  
                ", \"age\":" +  + age +  
                ", \"email\":\"" + email + '\"' +  
                '}';  
    }  
}
```
Trong class trên chúng ta hãy chú ý đến field `_id`. Annotation `@Id` sẽ báo cho Spring biết rằng field `_id` được sử dụng làm khóa chính. Phương thức get của field này nên được modify để trả về dạng String cho phù hợp với JSON.

# 5. Tạo repository
Sau khi chúng ta có model để định danh cấu trúc dữ liệu được lưu trữ trong database, chúng ta cần tạo ra một lớp với nhiệm vụ kết nối giữa model và MongoDB. Trong app đơn giản này chúng ta sẽ tạo một interface `ContactRepository` như sau:
```java
public interface ContactRepository extends MongoRepository<Contact, String> {  
    Contact findBy_id(ObjectId _id);  
}
```
Interface này được extends từ `MongoRepository` với 2 param lần lượt là kiểu của model và kiểu của khóa chính. Do trong MongoRepository đã có sẵn các method `getAll`,`save` hay `delete` nên chúng ta chỉ cần viết thêm một method `findBy_id` để get data theo id.

# 6. Config thông tin kết nối database
Để config thông tin kết nối database, chúng ta sẽ dùng file `application.properties` trong `resources` và mô tả như sau:
```
spring.data.mongodb.host=localhost //[host]  
spring.data.mongodb.port=27017//[port]  
spring.data.mongodb.authentication-database=spring_mongo //[authentication_database]  
spring.data.mongodb.username=tubean //[username]  
spring.data.mongodb.password=tubean //[password]  
spring.data.mongodb.database=spring_mongo
```

# 7. Tạo controller
App của chúng ta bây giờ đã có thể connect đến database, và chúng ta cần tạo các `endpoint` để truy vấn đến data trong đó. Để khai báo một class là controller, chúng ta dùng annotation `@RestController` và nhớ xác định đường dẫn path đến nó qua `@RequestMapping`:
```java
@RestController  
@RequestMapping("/contact")  
public class ContactController {
@Autowired  
private ContactRepository contactRepository;
}
```
Đừng quên để thao tác với database chúng ta cần tạo một instance cho `ContactRepository` qua annotation `Autowired`.

Method đầu tiên chúng ta cần tạo sẽ là `GET`:
```java
@RequestMapping(value = "/", method = RequestMethod.GET)  
public List<Contact> getAllContacts() {  
    return contactRepository.findAll();  
}  

@RequestMapping(value = "/{id}", method = RequestMethod.GET)  
public Contact getContactById(@PathVariable("id") ObjectId id) {  
    return contactRepository.findBy_id(id);  
}
```
Chúng ta có thể get tất cả dữ liệu thông qua endpoint `/contact/` hoặc lấy dữ liệu theo id qua endpoint `/contact/{id}`.

Tiếp theo là thêm mới và cập nhật, 2 method `POST` và `PUT` sẽ có sự khác biệt là khi chúng ta tạo mới một field, chúng ta không cần đến `_id` của nó, nhưng để sửa một field thì lại cần `_id` để xác định. Do đó endpoint cho `POST` sẽ là `/contact/` với RequestMethod là POST, còn endpoint cho `PUT` sẽ là `/contact/{id}` với RequestMethod là PUT.
```java
@RequestMapping(value = "/{id}", method = RequestMethod.PUT)  
public void modifyContactById(@PathVariable("id") ObjectId id, @Valid @RequestBody Contact contact) {  
    contact.set_id(id);  
    contactRepository.save(contact);  
}  

@RequestMapping(value = "/", method = RequestMethod.POST)  
public Contact createContact(@Valid @RequestBody Contact contact) {  
    contact.set_id(ObjectId.get());  
    contactRepository.save(contact);  
    return contact;  
}
```
Cuối cùng khi chúng ta muốn xóa một field nào đó trong database, chúng ta sử dụng method `DELETE`:
```java
@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)  
public void deleteContact(@PathVariable ObjectId id) {  
    contactRepository.delete(contactRepository.findBy_id(id));  
}
```

# 8. Testing các API
Sau khi execute class main, ứng dụng của chúng ta sẽ chạy ở localhost với cổng mặc định 8080.

Để lấy tất cả dữ liệu, chúng ta sẽ dùng POSTMAN gửi một request HTTP/GET như sau:
```
http://localhost:8080/contact/
```
Kết quả trả về sẽ như sau:
![mg_get](https://res.cloudinary.com/deop9ytsv/image/upload/v1544719409/mg_4.jpg)

Các method còn lại có thể kiểm tra như sau:

**GET (by id):**
http://localhost:8080/contact/5c1136692ae696f25358b92d
Kết quả trả về:
```
{
    "_id": "5c1136692ae696f25358b92d",
    "name": "Tu Bean",
    "age": 24,
    "email": "tubean@github.io"
}
```

**POST:**
http://localhost:8080/contact/ với body như sau:
```
{

    "name": "Bean Bean",
    "age": 2,
    "email": "bean@github.io"
}
```
Kết quả trả về:
```
{
    "_id": "5c128d84815f101660860fc5",
    "name": "Bean Bean",
    "age": 2,
    "email": "bean@github.io"
}
```
**PUT:**
http://localhost:8080/contact/5c128d84815f101660860fc5 với body như sau:
```
{
   "name": "Bean Bean",
    "age": 25,
    "email": "vibean@github.io"
}
```
Kết quả trả về có status 200.

**DELETE:**
Tương tự **PUT**, chỉ thay đổi method request.

# Source code
https://github.com/tubean/spring-mongodb
