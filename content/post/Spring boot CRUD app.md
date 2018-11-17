
---
title: "[Spring Boot] Dựng app CRUD đơn giản bằng Spring Boot + Thymeleaf trên Intelij"
slug: spring-boot-crud-app
date: 2018-11-17
categories:
- Spring
- Tutorial
- SpringBoot
tags:
- Spring Boot
- Tutorial
keywords:
- Spring
- Hướng dẫn
- Spring Boot
- Thymeleaf
- Crud app
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1542422606/spring-boot-icon0_cf21dec4-5056-b3a8-49c015fd3bde6cb5.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Để remind kiến thức cũng như tổng kết khi mới bắt đầu học một công nghệ mới, mình thường tạo một app đơn giản có đủ các thao tác thêm, xóa, sửa (CRUD). Bài viết này là một tutorial dạng cơ bản nhất khi học về Spring, sử dụng các công nghệ sau:

- Spring Boot: để khởi tạo và cấu hình ứng dụng một cách nhanh chóng.
- Spring MVC: để xây dựng app.
- Spring Data: cụ thể là Spring Data JPA, dùng để giúp ứng dụng thao tác với tầng cơ sở dữ liệu.
- Hệ quản trị cơ sở dữ liệu: MySQL.
- Template engine: Thymeleaf và Bootstrap css.
- Tool IDE: Intellij JetBrain.
- Công nghệ khác: Maven 3, 1.  Tomcat Embed 8.
- Source code dự án: https://github.com/tubean/spring-boot-application

### Các chức năng chính sẽ xây dựng:
- Hiển thị quản lý user.
- Thêm user.
- Sửa user.
- Xóa user.

Cơ sở dữ liệu cần chuẩn bị:
Bảng `user`:
```sql
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `phone` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
```
---
# 1. Khởi tạo dự án bằng Intellij
Đầu tiên chúng ta khởi động intellij, chọn new project -> Spring Initializr
![khởi tạo dự án](https://res.cloudinary.com/deop9ytsv/image/upload/v1542364170/Screen_Shot_2018-11-16_at_11.22.22_AM.png)

- Chọn Next, điền các thông tin `Group`, `Artifact`, `Name`, `Description`

![thông tin cơ bản](https://res.cloudinary.com/deop9ytsv/image/upload/v1542364169/Screen_Shot_2018-11-16_at_11.25.53_AM.png)

- Chọn tiếp các `dependencies` cần thiết: `Web`, `Thymeleaf`, `MySQL`, `JPA`:

![dependencies](https://res.cloudinary.com/deop9ytsv/image/upload/v1542364170/Screen_Shot_2018-11-16_at_11.27.08_AM.png)

- Đặt tên project và finish bước khởi tạo.

# 2. Cấu trúc dự án

Cây thư mục dự án như sau:

![structure](https://res.cloudinary.com/deop9ytsv/image/upload/v1542424758/Screenshot_1.jpg)

- Để sử dụng bootstrap css, các bạn tải [bootstrap](https://getbootstrap.com/) , sau đó giải nén và copy file `bootstrap.min.css` vào thư mục _resources/static_.
- Kiểm tra cấu hình file `pom.xml`:

```xml
<parent>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-parent</artifactId>  
    <version>2.1.0.RELEASE</version>  
    <relativePath/> <!-- lookup parent from repository -->  
</parent>  

<properties>  
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>  
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>  
    <java.version>1.8</java.version>  
</properties>  

<dependencies>  
    <dependency>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-data-jpa</artifactId>  
    </dependency>  
    <dependency>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-thymeleaf</artifactId>  
    </dependency>  
    <dependency>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-web</artifactId>  
    </dependency>  

    <dependency>  
        <groupId>mysql</groupId>  
        <artifactId>mysql-connector-java</artifactId>  
        <scope>runtime</scope>  
    </dependency>  
    <dependency>  
        <groupId>org.springframework.boot</groupId>  
        <artifactId>spring-boot-starter-test</artifactId>  
        <scope>test</scope>  
    </dependency>  
</dependencies>
```
# 3. Xây dựng view
- Nếu sử dụng Spring MVC và Thymeleaf, chúng ta sẽ cần config khá nhiều thứ mới có thể sử dụng engine Thymeleaf. Tuy nhiên sử dụng Spring Boot thì chúng ta không cần quan tâm nhiều đến thế. Các file `html` được Spring Boot chỉ định đặt trong folder `src/main/resources` nên chúng ta sẽ bỏ các file layout vào trong này.
- Để không phải relaunch server để xem các thay đổi trên giao diện, các bạn vào file `application.properties` thêm cấu hình sau:
```xml
spring.thymeleaf.cache=false
```

#### Quản lý resources

Các file static resources (css, js, ảnh) sẽ được Spring Boot đọc từ thư mục  `static`  trong  `src/main/resources`. Để cho tiện quản lý:

-   Các file css được đặt trong  `static/css`
-   Các file js được đặt trong  `static/js`
-   Các file ảnh được đặt trong  `static/images`

Trong dự án này do chỉ sử dụng một file `bootstrap.min.css` nên mình không tạo thêm các folder khác :smile:.

### Xây dựng layout

Trong ứng dụng này sẽ có 3 màn hình chính là:

- Màn hình hiển thị user: `index.html`
- Thêm mới một user: `addUser.html`
- Sửa một user: `editUser.html`

Nội dung các file như sau:

`index.html`

```html
<!DOCTYPE html>  
<html lang="en" xmlns:th="http://www.springframework.org/schema/data/jaxb">  
<head>  
    <title>User List</title>  
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>  
    <link type="text/css" rel="stylesheet" href="bootstrap.min.css" th:href="@{bootstrap.min.css}"/>  
</head>  
<body>  
<div class="col-3"></div>  
<div class="container col-6">  
    <h1>Manage User</h1>  
    <table class="table table-active">  
        <tr>  
            <th>Name</th>  
            <th>Email</th>  
            <th>Phone</th>  
            <th>Actions</th>  
        </tr>  
        <tr th:each="user : ${users}">  
            <td th:text="${user.name}"></td>  
            <td th:text="${user.email}"></td>  
            <td th:text="${user.phone}"></td>  
            <td>  
                <a th:href="@{/edit?id={id}(id=${user.id})}" class="btn btn-primary">Edit</a>  
                <a th:href="@{/delete?id={id}(id=${user.id})}" class="btn btn-danger">Delete</a>  
            </td>  
        </tr>  
    </table>  
    <a href="/add" class="btn btn-success">Add User</a>  
</div>  
</body>  
</html>
```

`addUser.html`

```html
<!DOCTYPE html>  
<html lang="en" xmlns:th="http://www.springframework.org/schema/data/jaxb">  
<head>  
    <meta charset="UTF-8">  
    <title>Add User</title>  
    <link type="text/css" rel="stylesheet" href="bootstrap.min.css" th:href="@{bootstrap.min.css}"/>  
</head>  
<body>  
<div class="col-3"></div>  
<div class="container col-6">  
    <h1>New User</h1>  
    <div class="col-md-auto">  
        <form th:object="${user}" th:action="@{save}" action="#" method="post">  
            <div>  
                <label th:text="Name" th:for="name"></label>  
                <input type="text" th:field="*{name}" class="form-control" placeholder="Name"/>  
            </div>  
            <div style="clear: both; display: block; height: 10px"></div>  
            <div>  
                <label th:text="Email" th:for="email"></label>  
                <input type="text" th:field="*{email}" class="form-control" placeholder="Email"/>  
            </div>  
            <div style="clear: both; display: block; height: 10px"></div>  
            <div>  
                <label th:text="Phone" th:for="phone"></label>  
                <input type="text" th:field="*{phone}" class="form-control" placeholder="Phone"/>  
            </div>  
            <div style="clear: both; display: block; height: 10px"></div>  
            <input type="submit" class="btn btn-success" value="Save"/>  
        </form>  
    </div>  
</div>  
</body>  
</html>
```

`editUser`
```html
<!DOCTYPE html>  
<html lang="en" xmlns:th="http://www.springframework.org/schema/data/jaxb">  
<head>  
    <meta charset="UTF-8">  
    <title>Edit User</title>  
    <link type="text/css" rel="stylesheet" href="bootstrap.min.css" th:href="@{bootstrap.min.css}"/>  
</head>  
<body>  
<div class="col-3"></div>  
<div class="container col-6">  
    <h1>Edit User</h1>  
    <form th:object="${user}" th:action="@{save}" action="#" method="post">  
        <input type="hidden" th:field="*{id}">  
        <div>  
            <label th:text="Name" th:for="name"></label>  
            <input type="text" th:field="*{name}" class="form-control"/>  
        </div>  
        <div style="clear: both; display: block; height: 10px"></div>  
        <div>  
            <label th:text="Email" th:for="email"></label>  
            <input type="text" th:field="*{email}" class="form-control"/>  
        </div>  
        <div style="clear: both; display: block; height: 10px"></div>  
        <div>  
            <label th:text="Phone" th:for="phone"></label>  
            <input type="text" th:field="*{phone}" class="form-control"/>  
        </div>  
        <div style="clear: both; display: block; height: 10px"></div>  
        <input type="submit" class="btn btn-success" value="Save"/>  
    </form>  
</div>  
</body>  
</html>
```

Chú ý khi khai báo file css trong layout:
-   Thuộc tính  `href`  là của HTML5, cung cấp đường dẫn tới file  `style.css`  cho trình duyệt nếu như  _server chưa run_. Cho nên chúng ta hoàn toàn có thể mở file html để xem dù chưa run server.
-   Thuộc tính  `th:href`  là của Thymeleaf, cung cấp đường dẫn tới file  `style.css`  cho trình duyệt khi  _server run_.  `@{}`  mà một biểu thức  [SPeL](https://springframework.guru/introduction-spring-expression-language-spel/)  xác định đường dẫn.

# 4. Xây dựng DataAccess layer và Service layer
#### Cấu hình DataSource, JPA
Các cấu hình liên quan đến DataSource, JPA chúng ta sẽ viết trong file `application.properties` của `java/main/resources`. Chúng ta có thể cấu hình đơn giản như sau:
```
spring.datasource.url=jdbc:mysql://localhost:3306/spring_app  
spring.datasource.username=root  
spring.datasource.password=  
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```
_Chú ý thay đổi các giá trị url, username, password cho phù hợp với môi trường của bạn._

#### Entity
Đây là các java bean được ánh xạ từ các bảng trong cơ sở dữ liệu. Với chỉ duy nhất một bảng `user`, mình sẽ tạo một class `User` trong package `entity`:

```java
package io.github.tubean.myspringcrud.entity;  

import javax.persistence.*;  

@Entity  
@Table(name = "user")
public class User {  
  @Id  
 @GeneratedValue(strategy = GenerationType.AUTO)  
  private Long id;  

  @Column(name = "name")  
  private String name;  

  @Column(name = "email")  
  private String email;  

  @Column(name = "phone")  
  private String phone;  

  public User() {}  

  public User(String name, String email, String phone) {  
    this.name = name;  
    this.email = email;  
    this.phone = phone;  
  }  

  public Long getId() {  
    return id;  
  }  

  public void setId(Long id) {  
    this.id = id;  
  }  

  public String getName() {  
    return name;  
  }  

  public void setName(String name) {  
    this.name = name;  
  }  

  public String getEmail() {  
    return email;  
  }  

  public void setEmail(String email) {  
    this.email = email;  
  }  

  public String getPhone() {  
    return phone;  
  }  

  public void setPhone(String phone) {  
    this.phone = phone;  
  }  
}
```
Các annotation mình sử dụng trong đoạn code trên là các annotation của JPA:

-   `@Entity`  xác định lớp hiện tại là một entity.
-   `@Table`  xác định tên bảng ánh xạ sang.
-   `@Id`  xác định thuộc tính hiện tại là ID trong bảng CSDL.
-   `@GeneratedValue`  xác định kiểu sinh khóa chính, ở đây là AUTO_INCREMENT.
-   `@Column`  xác định thuộc tính hiện tại là một cột trong CSDL.

#### Repository

Đây là các interface giúp chúng ta thao tác với CSDL. Trong Spring Data JPA có một tính năng rất hay đó là  **CRUD Repository**. Đây là một interface cung cấp các  [phương thức](http://docs.spring.io/spring-data/commons/docs/current/api/org/springframework/data/repository/CrudRepository.html)  CRUD cơ bản. Chúng ta chỉ cần định nghĩa một interface kế thừa CRUD Repository, Spring Data JPA sẽ dùng các generic và reflection để sinh implementation tương ứng với interface đó.
Trong dự án này chúng ta tạo một interface `UserRepository`:

```java
package io.github.tubean.myspringcrud.repository;  

import io.github.tubean.myspringcrud.entity.User;  
import org.springframework.data.repository.CrudRepository;  
import org.springframework.stereotype.Repository;  

@Repository  
public interface UserRepository extends CrudRepository<User, Long> {}
```
Các tham số trong CrudRepository là tên entity (User) và kiểu làm khóa chính (Long).

#### Service
Trong mô hình MVC thì nơi xử lý các business logic được đặt trong package `service`. Chúng ta có một interface `UserService` :
```java
package io.github.tubean.myspringcrud.service;  

import io.github.tubean.myspringcrud.entity.User;  

import java.util.List;  
import java.util.Optional;  

public interface UserService {  
  List<User> getAllUser();  

  void saveUser(User user);  

  void deleteUser(Long id);  

  Optional<User> findUserById(Long id);  
}
```
và một implementation `UserServiceImpl` của nó:
```java
package io.github.tubean.myspringcrud.service.impl;  

import io.github.tubean.myspringcrud.entity.User;  
import io.github.tubean.myspringcrud.repository.UserRepository;  
import io.github.tubean.myspringcrud.service.UserService;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Service;  

import java.util.List;  
import java.util.Optional;  

@Service  
public class UserServiceImpl implements UserService {  
  @Autowired private UserRepository userRepository;  

  @Override  
  public List<User> getAllUser() {  
    return (List<User>) userRepository.findAll();  
  }  

  @Override  
  public void saveUser(User user) {  
    userRepository.save(user);  
  }  

  @Override  
  public void deleteUser(Long id) {  
    userRepository.deleteById(id);  
  }  

  @Override  
  public Optional<User> findUserById(Long id) {  
    return userRepository.findById(id);  
  }  
}
```
Trong đó:
-   Annotation  `@Service`  giúp Spring xác định lớp hiện tại là một Service và tạo một bean cho lớp đó.
-   Annotation  `@Autowired`  dùng để inject UserRepository vào UserServiceImpl.

# 5. Tạo controller để điều hướng các request đến business và view tương ứng:
Chúng ta tạo một controller `UserController` trong package `controller`:
```java
package io.github.tubean.myspringcrud.controller;  

import io.github.tubean.myspringcrud.entity.User;  
import io.github.tubean.myspringcrud.service.UserService;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.stereotype.Controller;  
import org.springframework.ui.Model;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RequestMethod;  
import org.springframework.web.bind.annotation.RequestParam;  

import java.util.List;  
import java.util.Optional;  

@Controller  
public class UserController {  
  @Autowired private UserService userService;  

  @RequestMapping("/")  
  public String index(Model model) {  
    List<User> users = userService.getAllUser();  

    model.addAttribute("users", users);  

    return "index";  
  }  

  @RequestMapping(value = "add")  
  public String addUser(Model model) {  
    model.addAttribute("user", new User());  
    return "addUser";  
  }  

  @RequestMapping(value = "/edit", method = RequestMethod.GET)  
  public String editUser(@RequestParam("id") Long userId, Model model) {  
    Optional<User> userEdit = userService.findUserById(userId);  
    userEdit.ifPresent(user -> model.addAttribute("user", user));  
    return "editUser";  
  }  

  @RequestMapping(value = "save", method = RequestMethod.POST)  
  public String save(User user) {  
    userService.saveUser(user);  
    return "redirect:/";  
  }  

  @RequestMapping(value = "/delete", method = RequestMethod.GET)  
  public String deleteUser(@RequestParam("id") Long userId, Model model) {  
    userService.deleteUser(userId);  
    return "redirect:/";  
  }  
}
```
Trong đó:

-   Annotation  `@Controller`  giúp Spring xác định lớp hiện tại là một Controller.
-   Annotation  `RequestMapping(/)`  xác định phương thức  `index()`  sẽ đón nhận các request có HTTP method là  **GET**  và URI pattern là  `/`.
-   Annotation  `@Autowired`  inject ContactService vào ContactController
-   Phương thức  `index()`  được truyền vào 1 tham số có kiểu dữ liệu là  **Model**. Model có nhiệm vụ truyền dữ liệu từ Controller cho View. Ở đây mình sẽ lấy ra danh sách các user thông qua  `userService.getAllUser()`. Sau đó gắn danh sách này vào Model thông qua phương thức  `addAttribute()`,  `users`  chính là tên biến đại diện cho danh sách mà ta sẽ dùng ở View sau này.  

-   Phương thức  `index()`  trả về 1 String, từ String này Spring sẽ suy ra View nào sẽ nhận dữ liệu từ Controller:  `return "index";"`  => view là  `index.html`

---
Cuối cùng start ứng dụng bằng intellij và truy cập vào đường dẫn http://localhost:8080/ để thao tác với ứng dụng.

Mục tiêu của bài viết là để remind và hướng dẫn tạo một ứng dụng nhanh gọn bằng Spring Boot nên có nhiều phần mình không giải thích rõ ràng. Để tìm hiểu chi tiết các kiến thức được sử dụng một cách đầy đủ hơn, các bạn có thể tham khảo thêm bài viết dưới đây:
https://kipalog.com/posts/Lap-trinh-Spring-voi-ung-dung-MyContact.
