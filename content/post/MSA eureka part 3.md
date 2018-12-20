---
title: "[Microservice] Dựng Microservice web bằng Spring Boot và Eureka [Phần 3]"
slug: microservice-springboot-eureka-part3
date: 2018-12-20
categories:
- Microservice
- Spring Boot
tags:
- web architecture
- spring boot
- eureka
- zuul
- microservice
- hystrix
keywords:
- web architecture
- spring boot
- eureka
- zuul
- microservice
- tutorial
- intelij
- hystrix
- circuit breaker
- log tracing
- sleuth
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1545140745/1_aVq0q9jjFx1R8DMVhKKFWQ.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Ở [bài viết](https://tubean.github.io/2018/12/microservice-springboot-eureka-part2/)  trước, chúng ta đã dựng được một hệ thống microservice đơn giản với 2 microservice, 1 cổng gateway và 1 naming server và thực hiện xác thực người dùng bằng JWT. Trong bài viết lần này chúng ta sẽ tìm hiểu cách xử lý lỗi và ghi log trong hệ thống microservice theo thiết kế **Circuit Breaker** và **Log Tracing**.

# 1. Hystrix
Giả sử bạn có 3 service: A, B và C. Trong đó service A sẽ gọi đến service B và service B sẽ gọi đến service C. Chuyện gì sẽ xảy ra nếu service B trong một ngày mưa gió bỗng xảy ra sự cố?
```
A -> B (bị chết) -> C
```
Trong một ví dụ khác, hãy tưởng tượng service A gọi một service R  bên thứ ba, nhưng vì một lí do nào đó R bị chết. Bạn sẽ xử lý tình huống này như thế nào? Liệu bạn có có muốn dừng lỗi lại ngay tại service bị chết, không muốn nó làm chết hay bị tắc cả hệ thống của mình?

`Hystrix` là một thư viện được cung cấp bởi Netflix. Nó được triển khai theo mô hình **circuit breaker**, giúp cho người dùng không còn phải chờ đợi vô ích những service không phản hồi. Ý tưởng chính là ngăn chặn các lỗi được lan truyền một cách nhanh chống và phục hồi càng sớm càng tốt.

Trong hệ thống microservice đã xây dựng, chúng ta sẽ đưa ra một kịch bản là lỗi sẽ xảy ra ở service Image và chúng ta cần ngăn chặn và xử lý lỗi ở service gọi đến nó là service Gallery. Trong file `pom.xml` của Gallery service, chúng ta thêm dependency của Hystrix:
```
<dependency>  
  <groupId>org.springframework.cloud</groupId>  
  <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>  
</dependency>
```
Trong class main của Gallery service, chúng ta thêm annotation `@EnableCircuitBreaker`:
```java
@SpringBootApplication  
@EnableEurekaClient  
@EnableCircuitBreaker  
public class GalleryServiceApplication {  

    public static void main(String[] args) {  
        SpringApplication.run(GalleryServiceApplication.class, args);  
    }  

}
```
Spring sẽ tìm kiếm tất cả các method được đánh dấu annotation `@HytrixCommand` và để Hystrix có thể kiểm soát nó. Từ đó Hytrix có thể theo dỗi xem lỗi đến từ method nào và tỉ lệ lỗi trong một service vượt quá ngưỡng quy định, Hystrix sẽ chuyển Circuit breaker và tất cả lệnh yêu cầu trong thời gian nhất định sẽ thất bại ngay lập tức. Trong khi circuit breaker được mở, các lệnh dự phòng cho lỗi sẽ được triển khai, ví dụ như đọc từ bộ đệm, trả về giá trị mặc định hay ghi lại log.

Như vậy, trong class controller của Gallery, chúng ta sẽ cập nhật lại method `getGallery()` để thêm annotation và method dự phòng:
```java
package io.github.tubean.eureka.gallery.controller;  

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;  
import io.github.tubean.eureka.gallery.entity.Gallery;  
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.core.env.Environment;  
import org.springframework.web.bind.annotation.PathVariable;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RestController;  
import org.springframework.web.client.RestTemplate;  

import java.util.List;  

@RestController  
@RequestMapping("/")  
public class HomeController {  
   @Autowired  
  private RestTemplate restTemplate;  

   @Autowired  
  private Environment env;  

    private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);  

   @RequestMapping("/")  
   public String home() {  
      // This is useful for debugging  
 // When having multiple instance of gallery service running at different ports. // We load balance among them, and display which instance received the request.  return "Hello from Gallery Service running at port: " + env.getProperty("local.server.port");  
   }  

   @HystrixCommand(fallbackMethod = "fallback")  
   @RequestMapping("/{id}")  
   public Gallery getGallery(@PathVariable final int id) {  
      LOGGER.info("Creating gallery object ... ");  
      // create gallery object  
  Gallery gallery = new Gallery();  
      gallery.setId(id);  

      // get list of available images  
  @SuppressWarnings("unchecked")    // we'll throw an exception from image service to simulate a failure  
  List<Object> images = restTemplate.getForObject("http://image-service/images/", List.class);  
      gallery.setImages(images);  

      LOGGER.info("Returning images ... ");  
      return gallery;  
   }  

   // -------- Admin Area --------  
 // This method should only be accessed by users with role of 'admin' // We'll add the logic of role based auth later  @RequestMapping("/admin")  
   public String homeAdmin() {  
      return "This is the admin area of Gallery service running at port: " + env.getProperty("local.server.port");  
   }  

   // a fallback method to be called if failure happened  
  public Gallery fallback(int galleryId, Throwable hystrixCommand) {  
      return new Gallery(galleryId);  
   }  
}
```
Để tạo một kịch bản lỗi, chúng ta sẽ thả một exception trong class controller của  service Image:
```java
package io.github.tubean.eureka.image.controller;  

import io.github.tubean.eureka.image.entity.Image;  
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.core.env.Environment;  
import org.springframework.web.bind.annotation.RequestMapping;  
import org.springframework.web.bind.annotation.RestController;  

import java.util.Arrays;  
import java.util.List;  

@RestController  
@RequestMapping("/")  
public class HomeController {  
   @Autowired  
  private Environment env;  

   @RequestMapping("/")  
   public String home() {  
      // This is useful for debugging  
 // When having multiple instance of image service running at different ports. // We load balance among them, and display which instance received the request.  return "Hello from Image Service running at port: " + env.getProperty("local.server.port");  
   }  

   @RequestMapping("/images")  
   public List<Image> getImages() {  
      List<Image> images = Arrays.asList(  
         new Image(1, "Treehouse of Horror V", "https://www.imdb.com/title/tt0096697/mediaviewer/rm3842005760"),  
         new Image(2, "The Town", "https://www.imdb.com/title/tt0096697/mediaviewer/rm3698134272"),  
         new Image(3, "The Last Traction Hero", "https://www.imdb.com/title/tt0096697/mediaviewer/rm1445594112"));  
      try {  
         throw new Exception("Images can't be fetched");  
      } catch (Exception e) {  
         e.printStackTrace();  
      }  
      return images;  
   }  
}
```
Bây giờ hãy test xem hệ thống làm việc như thế nào bằng cách gọi đến service Gallery `localhost:8762/gallery/1`. Bạn sẽ nhận được kết quả như sau:
```
{  
    "id": 1,  
    "images": null  
}
```

> Đừng quên thêm token để xác thực nếu gặp status 401!

# 2. Sleuth
Nếu bạn có 3 service A, B và C. Chúng ta tạo 3 request khác nhau: một request từ A -> B, một cái từ A -> B -> C và cái cuối cùng là từ B -> C.
```
A -> B  
A -> B -> C  
B -> C
```
Nếu như số lượng microservice tăng dần, việc truy tìm các request lan truyền từ service này sang service khác và tìm ra cách một request đi xuyên suốt cả hệ thống ra sao là khá khó khăn. Tuy nhiên `Sleuth` sẽ giúp chúng ta truy tìm các request bằng cách đặt cho chúng những id unique để ghi log. Một dòng log của Sleuth thường có dạng như sau:
```
 INFO [application-name,trace id,span id, flag]
```
Trong đó, giá trị đầu tiên là tên service, tiếp theo là `trace id` được sử dụng để tracking nó trong cả hệ thống. Giá trị thứ ba là `span id` và được sử dụng để tracking bên trong nội bộ microservice. Giá trị cuối cùng cho biết liệu thông tin đó có nên được xuất sang Zipkin hay không? Mình sẽ đề cập chi tiết hơn về Sleuth và Zipkin trong một bài viết khác.

Để sử dụng Sleuth, chúng ta thêm vào file `pom.xml` của Gallery service (hoặc Image):
```
<dependency>  
  <groupId>org.springframework.cloud</groupId>  
  <artifactId>spring-cloud-starter-sleuth</artifactId>  
</dependency>
```
Sau đó trong controller của Gallery, chúng ta sẽ ghi lại một vài thông tin:
```
import org.slf4j.Logger;  
import org.slf4j.LoggerFactory;**

// ...  
private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);

public Gallery getGallery(@PathVariable final int id) {  
 LOGGER.info("Creating gallery object ... "); // ...   
 LOGGER.info("Returning images ... ");  
 return images;  
}  
// ...
```
Cuối cùng, sau khi bạn tạo một request đến gallery service, bạn sẽ thấy được `trace id` và `span id` trong màn hình console:
```
INFO [gallery-service,bb3f24a6afde87ac,591ea3b8354f9319,false]
```
# Nguồn bài viết
https://medium.com/omarelgabrys-blog/microservices-with-spring-boot-circuit-breaker-log-tracing-part-4-9cdf5e898988

# Source code
https://github.com/tubean/MSA-springboot-eureka

Checkout branch: `part3_circuitbreaker_logtracing`.
