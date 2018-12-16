---
title: "[Web Service] Sự khác nhau giữa SOAP và RESTful Web Service trong Java"
date: 2018-12-13
categories:
- Java
- Web service
tags:
- Java
- web service
- soap
- restful
keywords:
- Java
- web service
- soap
- restful
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1544948787/web-service-drawing_csp11664505.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Cả 2 loại `SOAP` và `RESTful` đều cho phép phía client gửi request đến server để query, nhưng chúng được thực hiện bằng những cách khác nhau. Sự khác nhau chính giữa SOAP và REST là cách mà client giao tiếp server thông qua SOAP sẽ bị hạn chế bởi nhiều quy tắc và format được thiết kế chính xác, trong khi với REST cho phép việc giao tiếp thông qua giao thức HTTP và ít các quy tắc rườm rà hơn. Từ khi các request HTTP như `GET` và `POST` trở nên quen thuộc hơn thì việc sử dụng REST dần trở nên phổ biến, dễ chịu hơn so với thời kỳ SOAP cùng với cấu trúc WSDL đầy quy tắc và luật lệ trước đó. Trong bài viết này, chúng ta sẽ cùng xem sự khác biệt giữa SOAP và REST cũng như lợi thế và hạn chế của mỗi loại.

# 1. Sự khác nhau giữa REST và SOAP trong Java
 Dưới đây là một vài khác biệt cơ bản giữa REST,  RESTful và SOAP :

## Viết tắt
`REST` là viết tắt của `REpresentational State Transfer` (Chuyển giao trạng thái phản hồi) trong khi `SOAP` là `Simple Object Access Protocol` (Giao thức truy cập đối tượng đơn giản).

## Kiến trúc và giao thức
REST là một kiểu kiến trúc, từ đó RESTful web service được xây dựng trong khi SOAP là một chuẩn được tạo ra để chuẩn hóa giao tiếp giữa client và server về format, structure và method.

## Sử dụng giao thức HTTP
REST thừa hưởng tất cả những lợi ích của giao thức HTTP, bao gồm các method như `GET`, `POST`, `PUT` và `DELETE` để thực hiện các hành động truy vấn, thêm, sửa, xóa dữ liệu. Trong khi đó SOAP sử dụng các message dạng XML để giao tiếp với server.

## Các dạng format được support
RESTful web service có thể trả về dữ liệu dưới dạng JSON, XML hoặc HTML, trong khi nếu sử dụng SOAP web service thì chúng ta chỉ có thể sử dụng XML bởi vì các quy tắc trong một message SOAP đã được định nghĩa sẵn trong định dang XML.

## Tốc độ
RESTful nhanh hơn so với SOAP vì các message của SOAP cần parsing nhiều hơn RESTful.

## Băng thông
Các message SOAP thường có độ dài và dung lượng cao hơn so với một request của RESTful, do đó nếu dùng SOAP thì bạn sẽ tốn băng thông nhiều hơn.

## Transport Independence
Vì các message của SOAP được đóng gói trong một định dạng đặc biệt nên nó có thể gửi qua bất kỳ cơ chế vận chuyển nào như TCP, FTP, SMTP,... Mặt khác thì RESTful phụ thuộc rất nhiều vào giao thức HTTP. Tuy nhiên trong thực tết chúng ta cũng sử dụng giao thức HTTP nhiều hơn nên lợi thế này của SOAP cũng không mấy được coi trọng.

## Tài nguyên
RESTful sử dụng URL để xác định tài nguyên mong muốn được truy cập trong khi SOAP sử dụng các message dạng XML để xác định các thủ tục hay tài nguyên yêu cầu.

## Bảo mật
Bảo mật trong RESTful web service có thể được triển khai bằng các giải pháp và tiêu chuẩn truyền thống để các truy cập được phân quyền và xác thực trước khi sử dụng tài nguyên web. Còn đối với SOAP, bạn cần có viết thêm các cơ sở hạ tầng để bảo mật các message và giao thức vận chuyển.

## Caching
RESTful web service tận dụng tối đa cơ chế caching vì về cơ bản chúng dựa trên URL. Mặt khác, các dịch vụ web SOAP hoàn toàn bỏ qua caching web.

## Tiếp cận
Trong các dịch vụ web dựa trên REST, mọi thực thể đều tập trung vào các tài nguyên, trong khi trong trường hợp dịch vụ web SOAP, mọi thực thể đều tập trung vào các interface và message.

## Ví dụ
Ví dụ: giả sử bạn muốn truy xuất thời tiết hôm nay cho một thành phố cụ thể từ một máy chủ cung cấp thông tin thời tiết, URL RESTful của bạn sẽ trông giống như `http://weatherdata.org/data/weather/uk/london`, rất giống một request HTTP như `http://weatherdata.org/data/weather?q=uk,London`.

Bên cạnh đó thì để có được cùng một dữ liệu bằng SOAP, bạn cần tạo một thông báo XML có tiêu đề và nội dung và gửi nó `http://www.webservicex.net/globalweather.asmx?op=GetWeather`.

Tóm lại, RESTfull đơn giản, linh hoạt và dễ chịu hơn nhiều so với SOAP trong Java.

# 2. Bảng tổng kết

| Stt |SOAP|REST|
|---|---|---|
| 1 |Một giao thức gửi nhận message có dạng XML| Một loại kiến trúc bao gồm các quy tắc để thao tác với server|
|2|Sử dụng WSDL để giao tiếp giữa máy chủ và máy khách| Sử dụng XML hoặc JSON để gửi nhận dữ liệu|
|3|Gọi các service thông qua method RPC|Gọi các service qua đường dẫn URL|
|4|Kết quả trả về không dễ đọc| Kết quả trả về dễ đọc vì đơn giản chỉ là text XML hoặc JSON.|
|5|Có thể truyền qua nhiều giao thức khác nhau như HTTP, SMTP, FTP,...|Chỉ có thể truyền qua HTTP|
|6|JS có thể dùng để gọi SOAP, nhưng rất khó để làm| Quá đơn giản nếu dùng JS.
|7|Performance không tốt bằng REST| Performance tốt hơn SOAP, tốn ít tài nguyên CPU hơn, code ngắn gọn hơn|

# 3. Lý do gì REST tốt hơn SOAP?
1. REST có thể được sử dụng bởi bất kỳ client nào ví dụ: Java, C ++, Python client và thậm chí là một trình duyệt web với Ajax và JavaScript.

2. REST nhẹ hơn so với SOAP, nó không yêu cầu phân tích cú pháp XML và nó cũng tiêu tốn ít băng thông hơn vì không giống như SOAP, REST không yêu cầu SOAP header cho mỗi lần request.

3. SOAP là một công nghệ cũ, còn tất cả những gã khổng lồ hiện đại đang sử dụng REST, ví dụ: Google, Twitter và Flickr...

4. REST rất dễ học, nó chỉ cần hiểu danh từ và động từ. Nếu bạn đã biết các phương thức HTTP thì nó thậm chí còn dễ dàng hơn.

5. Java hỗ trợ tuyệt vời cho RESTFul web service và cũng hỗ trợ tốt cho SOAP web service.  Bạn có rất nhiều sự lựa chọn ở đây, ví dụ: Jersey, RESTLet, v.v.

# Nguồn
https://javarevisited.blogspot.com/2015/08/difference-between-soap-and-restfull-webservice-java.html
