---
title: "[Design Patterns] Facade Design Pattern in Java"
slug: facade-design-patterns
date: 2018-11-29
categories:
- Java
- Design Patterns
tags:
- Java
- Design Pattern
- Facade
keywords:
- java
- design
- pattern
- facade
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543156961/design-pattern-logo.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Trong bài viết này, chúng ta cùng xem xét mẫu thiết kế khác, đó là `Facade pattern`. Trước khi đi vào chi tiết mẫu thiết kế, chúng ta cùng xem xét câu chuyện sau:

Công ty phần mềm A vận hành một sản phẩm tên là **Schedule Server**. Đó là một ứng dụng làm rất nhiều việc như gửi mail, sms, đọc và viết file đến địa chỉ đích, gửi và nhận file giữa 2 server. Ứng dụng được các developers sử dụng để quản lý các loại công việc đó và có thể tập trung hơn vào nghiệp vụ của mình. Server sẽ thực thi mỗi công việc tại thời điểm được chỉ định. Là một developer, bạn chỉ cần code các nghiệp vụ liên quan và cung cấp các API để thực hiện nghiệp vụ mà khách hàng muốn.

Mọi thứ đều ổn cho đến khi khách hàng phàn nàn rằng việc bắt đầu và kết thúc của một tiến trình là phức tạp và mất thời gian. Họ muốn làm điều đó nhanh gọn hơn. Do đó chúng ta cần cung cấp một giải pháp để start và stop server. Vấn đề ở đây là lỗi thiết kế ban đầu đã khiến cho các interface trở nên rất phức tạp. Và dù muốn dù không thì chúng ta cũng không thể đập đi xây lại từ đầu. `Facade pattern` sẽ giúp chúng ta giải quyết vấn đề này.

# 1. Mẫu Facade là gì?
Mục đích của mẫu facade làm khiên cho các interface phức tạp trở nên dễ sử dụng hơn bằng cách tạo ra một lớp Facade. Lớp này sẽ định nghĩa một _higher-level interface_ giúp cho các hệ thống con dễ sử dụng hơn. Điều này giống như khi bạn gọi điện tổng đài chăm sóc khách hàng thì sẽ có một em xinh tươi giúp chúng ta giao tiếp với tất cả dịch vụ mà chúng ta cần.

Facade không đóng gói các interface hoặc các class con, mà nó chỉ tạo ra thêm một cách mới để đơn giản hóa một nghiệp vụ nào đó. Các API khác vẫn được expose và khách hàng có thể sử dụng chúng một cách trực tiếp không cần thông qua Facade. Ngoài ra, Facade còn làm cho sự liên kết giữa phía client và các hệ thống con trở nên lỏng lẻo hơn, tuân thủ principle `Least Knowledge`, khiến chương trình trở nên linh hoạt hơn: giả sử một ngày nào đó, công ty bạn quyết định thêm một vài function vào để khởi tạo và kết thúc tiến trình thì phía client chỉ cần quan tâm đến Facade, không cần quan tâm đến sự thay đổi bên dưới nó.

Cần chú ý là Facade tương tự [Adapter](https://tubean.github.io/2018/11/adapter-design-patterns/) đều wrap nhều class với nhau. Tuy nhiên Facade được sử dụng để tạo ra một interface mới dễ sử dụng hơn từ một loạt các interface phức tạp, trong khi Adapter sẽ convert từ một interface sang một interface được yêu cầu.

![img1](https://res.cloudinary.com/deop9ytsv/image/upload/v1543506804/facade_1.jpg)

# 2. Cách giải quyết
Vấn đề gặp phải là phía client sử dụng Schedule Server sẽ phải làm những việc phức tạp khi start và stop server :
```java
ScheduleServer scheduleServer = new ScheduleServer();
```
Để start server, phía clients cần làm tất cả các việc sau:
```java
scheduleServer.startBooting();  
scheduleServer.readSystemConfigFile();  
scheduleServer.init();  
scheduleServer.initializeContext();  
scheduleServer.initializeListeners();  
scheduleServer.createSystemObjects();  

System.out.println("Start working......");  
System.out.println("After work done.........");
```
Còn để stop server, client cần gọi các method sau một cách tuần tự:
```java
scheduleServer.releaseProcesses();  
scheduleServer.destory();  
scheduleServer.destroySystemObjects();  
scheduleServer.destoryListeners();  
scheduleServer.destoryContext();  
scheduleServer.shutdown();
```
Để giải quyết vấn đề này, chúng ta tạo một lớp facade để wrap đối tượng server này. Lớp facade này sẽ cung cấp các phương thức đơn giản hơn cho phía client:
```java
class ScheduleServerFacade {  
    private final ScheduleServer scheduleServer;  

    ScheduleServerFacade(ScheduleServer scheduleServer) {  
        this.scheduleServer = scheduleServer;  
    }  

    void startServer() {  

        scheduleServer.startBooting();  
        scheduleServer.readSystemConfigFile();  
        scheduleServer.init();  
        scheduleServer.initializeContext();  
        scheduleServer.initializeListeners();  
        scheduleServer.createSystemObjects();  
    }  

    void stopServer() {  

        scheduleServer.releaseProcesses();  
        scheduleServer.destory();  
        scheduleServer.destroySystemObjects();  
        scheduleServer.destoryListeners();  
        scheduleServer.destoryContext();  
        scheduleServer.shutdown();  
    }  
}
```
Khi này thì khách hàng muốn start hay stop server thì chỉ cần gọi đến 2 phương thức `startServer()` và `stopServer()`, quá tiện ::smile::

# 4. Dùng Facade khi nào?
Chúng ta sẽ sử dụng Facade trong các trường hợp sau:

-	Cần cung cấp một interface đơn giản cho một hệ thống con phức tạp:  Các hệ thống con thường trở nên phức tạp hơn theo thời gian. Trong hầu hết các mô hình thì các lớp con thường sẽ trở nên nhỏ hơn và dễ custom hơn. Nhưng điều này cũng làm cho khách hàng trở nên bối rối mỗi lần chúng ta thay đổi version. Facade cung cấp một chế độ xem đủ tốt và đơn giản cho hầu hết những khách hàng không muốn đi sâu vào custom hệ thống.
-	Có nhiều phụ thuộc giữa phía client và các lớp implementation: Một Facade sẽ giúp tách biệt hệ thống con từ khách hàng và các hệ thống con khác, do đó thúc đẩy sự độc lập của hệ thống con và tính di động của chúng.
-	Muốn che giấu tính phức tạp của hệ thống con: Sử dụng Facade sẽ giúp xác định các _entry point_ của mỗi tầng hệ thống.

# 5. Source code
https://github.com/tubean/design-pattern/
