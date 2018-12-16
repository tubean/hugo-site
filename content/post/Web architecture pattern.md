---
title: "[Web architecture] Kiến trúc monolithic và microservice"
slug: monolithic-vs-microservice
date: 2018-12-16
categories:
- Web Architecture
tags:
- web architecture
- monolithic
- microservice
keywords:
- web architecture
- monolithic
- microservice
- compare
- advantage
- disadvantage
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1544957029/Icon_WebArchitect.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Trong lập trình web hiện nay, hai loại kiến trúc web mà chúng ta thường áp dụng cho ứng dụng của mình là kiến trúc một khối (Monolithic architecture) và kiến trúc microservice (Microservice architecture). Trong bài viết này, chúng ta sẽ tìm hiểu về hai loại kiến trúc này để biết ưu nhược điểm cũng như khi nào sử dụng chúng.

# 1. Kiến trúc một khối (Monolithic web architecture)
Kiến trúc một khối là mẫu thiết kế được dùng nhiều nhất trong giới lập trình web hiện nay bởi tính đơn giản của nó khi phát triển và khi deploy. Mặc dù mỗi ứng dụng sẽ được triển khai theo những cách khác nhau, nhưng nhìn chung thì khi ứng dụng được lập trình theo kiến trúc một khối, kết quả thường đạt được như sau:

- Nó có thể hỗ trợ nhiều loại client như browser hay các app native trên cả desktop và mobile.
- Nó có thể expose API cho bên thứ ba.
- Nó có thể tích hợp với các ứng dụng khác thông qua REST/SOAP web service hoặc các message queue.
- Nó có thể xử lý các request dạng HTTP, thực hiện logic nghiệp vụ, truy cập cơ sở dữ liệu và có thể trao đổi dữ liệu với các hệ thống khác.
- Nó có thể chạy trên các container như Tomcat, JBoss,..
- Nó có thể scale theo chiều ngang (vertical scalability) bằng cách tăng sức mạnh của phần cứng hoặc scale theo chiều dọc (horizontal scalability) bằng cách load balancers.

> So sánh giữa REST và SOAP web service tại [đây](https://tubean.github.io/2018/12/web-service-s%E1%BB%B1-kh%C3%A1c-nhau-gi%E1%BB%AFa-soap-v%C3%A0-restful-web-service-trong-java/).

Một ví dụ phổ biến về kiến trúc một khối có thể được mô tả như sau:

>	Hãy tưởng tượng một hệ thống đặt phòng khách sạn trực tuyến nhận đơn đặt hàng trực tuyến từ khách hàng, xác minh phòng trống, xác minh tùy chọn thanh toán, đặt phòng và thông báo cho khách sạn. Ứng dụng này bao gồm một số layer và component bao gồm ứng dụng phía client, xây dựng giao diện người dùng phong phú và một số thành phần phụ trợ khác chịu trách nhiệm quản lý các đặt phòng, xác minh thanh toán, thông báo cho khách hàng / khách sạn, v.v.
Ứng dụng sẽ được đóng gói và deploy bằng một file **Web Application Archive (WAR)** duy nhất và được chạy trên một container như Tomcat và có thể scale bằng load balancer. Hãy xem diagram dưới đây:

![img_1](https://res.cloudinary.com/deop9ytsv/image/upload/v1544949567/web_1.jpg)

## Những ưu điểm của kiến trúc một khối

#### Ưu điểm:

- Dễ phát triển vì các stack công nghệ thống nhất ở tất cả các layer.
- Dễ test do  toàn bộ project được đóng gói trong một package nên dễ dàng chạy test integrantion và test end-to-end.
- Deploy đơn giản và nhanh chóng nếu bạn chỉ có một package để bận tâm.
- Dễ scale vì chúng ta có thể có nhiều instance cho load banlancer.
- Yêu cầu team size nhỏ cho việc maintain app.
- Team member có thể chia sẻ ít nhiều về skill.
- Tech stack đơn giản và đa số là dễ học.
- Phát triển ban đầu nhanh hơn do đó có thể đem sale hoặc marketing nhanh hơn.
- Yêu cầu cơ sở hạ tầng đơn giản. Thậm chí một container đơn giản cũng đủ để chạy ứng dụng.

#### Nhược điểm:

- Các component được liên kết chặt chẽ với nhau dẫn đến side effect không mong muốn như khi thay đổi một component ảnh hưởng đến một component khác.
- Theo thời gian thì project trở nên phức tạp và lớn dần. Các tính năng mới sẽ mất nhiều thời gian hơn để phát triển và tái cấu trúc các tính năng hiện có sẽ nhiều khó khăn hơn.
- Toàn bộ ứng dụng cần được triển khai lại cho bất kỳ thay đổi nào.
- Không hề dễ để hiểu project do các module liên quan chặt chẽ lẫn nhau. Một issue nhỏ cũng có thể làm chết toàn bộ ứng dụng.
- Áp dụng công nghệ mới khó khăn vì toàn bộ ứng dụng phải thay đổi. Do đó nhiều ứng dụng một khối thường phụ thuộc một công nghệ cũ và lỗi thời.
- Các service quan trọng không thể scale riêng dẫn đến lãng phí tài nguyên vì toàn bộ ứng dụng phải scale theo.
- Các ứng dụng một khối lớn sẽ có thời gian khởi động lâu và tốn tài nguyên CPU cũng như bộ nhớ.
- Các team tham gia vào dự án phải phụ thuộc lẫn nhau và tất khó để mở rộng quy mô team.

# 2. Kiến trúc microservice (Mocroservice architecture)
Đây là loại kiến trúc đang dần trở nên phổ biến trong những năm gần đây nhờ khả năng mudule hóa và khả năng mở rộng. Kiến trúc microservice có thể cung cấp hầu hết các tính năng của một ứng dụng một khối. Ngoài ra, nó cung cấp nhiều tính năng và linh hoạt hơn, do đó nó là sự lựa chọn ưu việt cho ứng dụng phức tạp. Không giống như kiến trúc một khối, khá khó để khái quát hóa kiến trúc microservice vì nó có thể thay đổi nhiều tùy thuộc vào trường hợp sử dụng và triển khai. Nhưng nhìn chung thì chúng cũng có một số đặc điểm như sau:

- Các component trong kiến trúc microservice liên kết khá lỏng lẻo (loose coupling). Các component có thể được phát triển, test, deploy và scale độc lập mà không ảnh hưởng đến các component khác.
- Các component không cần phải được phát triển cùng một stack công nghệ. Điều này có nghĩa là một component có thể chọn stack công nghệ và ngôn ngữ lập trình của riêng nó.
- Chúng thường sử dụng các tính năng nâng cao như truy tìm dịch vụ (service discovery), circuit breaking, cân bằng tải (load balance),...
- Các component chủ yếu là nhẹ và chúng làm theo chức năng riêng biệt. Ví dụ dịch vụ xác thực sẽ chỉ quan tâm xác thực người dùng vào hệ thống.
- Thường có một thiết lập giám sát (monitor) và xử lý sự cố.

Một ví dụ phổ biến về kiến trúc microservice có thể được mô tả như sau:

>	Chúng ta hãy tưởng tượng một hệ thống thương mại điện tử trực tuyến khổng lồ, nơi khách hàng có thể xem các danh mục hàng hóa, đánh dấu mục yêu thích, thêm các mặt hàng vào giỏ hàng, thực hiện và theo dõi đơn đặt hàng, v.v. Hệ thống có quản lý hàng tồn kho, quản lý khách hàng, nhiều phương thức thanh toán, quản lý đơn hàng, v.v. Ứng dụng này bao gồm một số module và component bao gồm UI gateway, xây dựng giao diện người dùng đẹp, xử lý xác thực người dùng, cân bằng tải, và một số ứng dụng khác chịu trách nhiệm quản lý kho, xác minh thanh toán và quản lý đơn hàng. Nó cũng có giám sát hiệu suất và tự động chuyển đổi dự phòng cho các service.
Ứng dụng được deploy bằng nhiều file WAR trên các Docker container và được host trên một dịch vụ cloud. Hãy xem diagram dưới đây:

![img_2](https://res.cloudinary.com/deop9ytsv/image/upload/v1544949567/web_2.jpg)

## Những ưu điểm của kiến trúc microservice

#### Ưu điểm:

- Các component có kết nối lỏng lẻo dẫn đến dễ cách ly, dễ test và khởi động nhanh.
- Vòng đời phát triển nhanh hơn. Tính năng mới được phát triển nhanh hơn và tính năng cũ được cấu trúc lại dễ hơn.
- Các service có thể deploy độc lập nên ứng dụng dễ đọc, dễ tạo các bản vá hơn.
- Những issue, ví dụ liên quan đến memry leak một trong các service, bị cô lập và có thể không làm sập ứng dụng.
- Việc áp dụng các công nghệ mới dễ hơn. Các component có thể được nâng cấp độc lập với nhau.
- Các mô hình scale phức tạp và hiệu quả hơn có thể được thiết lập. Các service quan trọng có thể scale hiệu quả hơn. Các component riêng sẽ khởi động nhanh hơn và cải thiện thời gian khởi động của cả hệ thống.
- Các team tham gia sẽ ít phụ thuộc lẫn nhau. Kiến trúc này rất thích hợp cho các đội Agile.

#### Nhược điểm:

- Phức tạp hơn về mặt tổng thể vì các component khác nhau có các stack công nghệ khác nhau nên buộc team phải tập trung đầu tư thời gian để theo kịp công nghệ.
- Khó thực hiện test end-to-end và integration test vì có nhiều stack công nghệ khác nhau.
- Deploy toàn bộ ứng dụng phức tạp hơn vì có nhiều container và nền tảng ảo hóa liên quan.
- Ứng dụng được scale hiệu quả hơn nhưng thiết lập nâng cấp sẽ phức tạp hơn vì nó sẽ yêu cầu nâng cao nhiều tính năng như truy tìm dịch vụ (service discovery), định tuyến DNS,...
- Yêu cầu một team-size lớn để maintain ứng dụng vì có nhiều component và công nghệ khác nhau.
- Các thành viên trong team chia sẻ các skill khác nhau dựa trên component họ làm nên sẽ tạo ra sự khó khăn khi thay thế và chia sẻ kiến thức.
- Stack công nghệ phức tạp và khó để học hơn.
- Thời gian phát triển ban đầu là chậm nên thời gian để có thể làm marketing lâu hơn.
- Yêu cầu cơ sở hạ tầng phức tạp. Thông thường sẽ yêu cầu nhiều container (Docker) và nhiều máy JVM để chạy.

# 3. Khi nào sử dụng

## 3.1 Kiến trúc một khối
Chúng ta thường sử dụng kiến trúc một khối khi:

- Phạm vi ứng dụng là nhỏ và được xác định rõ. Bạn chắc chắn ứng dụng sẽ không phát triển mạnh về các tính năng. Ví dụ: blog, web mua sắm trực tuyến đơn giản, ứng dụng CRUD đơn giản...
- Team-size nhỏ, thường ít hơn 8 người.
- Mặt bằng kỹ năng của các thành viên trong team thường không cao.
- Thời gian để có thể marketing là quan trọng.
- Bạn không muốn mất thời gian cho cơ sở hạ tầng, monitoring,...
- Khi người dùng thường nhỏ và ít nên bạn không mong đợi họ sẽ mở rộng. Ví dụ các ứng dụng doanh nghiệp nhắm đến mục tiêu là một nhóm người cụ thể...

## 3.2 Kiến trúc microservice
Chúng ta thường sử dụng kiến trúc microservice khi:

- Ứng dụng có phạm vi lớn và bạn xác định các tính năng sẽ được phát triển rất mạnh theo thời gian. Ví dụ: cửa hàng thương mại điện tử trực tuyến, dịch vụ truyền thông xã hội, dịch vụ truyền phát video với số lượng người dùng lơn, dịch vụ cung cấp API,...
- Team-size lớn, có đủ thành viên để phát triển các component riêng lẻ một cách hiệu quả.
- Mặt bằng kỹ năng của team tốt và các thành viên tự tin về các mẫu thiết kế microservice nâng cao.
- Thời gian để đem đi marketing không quan trọng. Kiến trúc microservice sẽ mất nhiều thời gian hơn để hoạt động được.
- Bạn sẵn sàng chi nhiều hơn cho cơ sở hạ tầng, giám sát,... để nâng cao chất lượng sản phẩm.
- Tiềm năng về người dùng lớn và bạn kỳ vọng số lượng người dùng sẽ phát triển. Ví dụ một phương tiện truyền thoong xã hội nhắm mục tiêu là người dùng trên toàn thế giới.

# Tham khảo:
https://articles.microservices.com/monolithic-vs-microservices-architecture-5c4848858f59
