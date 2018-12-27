---
title: "[Microservice] Các khái niệm chính trong microservice"
slug: microservice-key-architectural-concepts
date: 2018-12-27
categories:
- Microservice
tags:
- web architecture
- key
- concept
- microservice
keywords:
- web architecture
- key
- concept
- microservice
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1545140745/1_aVq0q9jjFx1R8DMVhKKFWQ.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Trong bài viết này, chúng ta sẽ tìm hiểu một số khái niệm chính trong hệ thống microservice.

# 1. Monolithic Architecture
Các ứng dụng doanh nghiệp ngày nay đang được thiết kế để đáp ứng được số lượng lớn nghiệp vụ kinh doanh. Do đó một ứng dụng phần mềm cần cung cấp hàng trăm chức năng và tất cả các những chức năng như vậy thường được gói gọn trong một ứng dụng nguyên khối duy nhất. ERP, CRM và các hệ thống phần mềm khác nhau là những ví dụ điển hình - chúng được xây dựng dưới dạng nguyên khối với hàng trăm chức năng. Việc triển khai, xử lý sự cố, mở rộng và nâng cấp các ứng dụng như vậy quả là một cơn ác mộng đối với bất kỳ doanh nghiệp nào.

 Kiến trúc hướng dịch vụ (service-oriented architecture - SOA) được thiết kế để khắc phục các vấn đề phát sinh từ ứng dụng một khối (monolithic) bằng cách đưa ra khái niệm `service`. Do đó, với SOA, một ứng dụng sẽ được thiết kế dưới dạng kết hợp các service khác nhau. Khái niệm SOA không có nghĩa là biến từng service thành một khối riêng, nhưng hầu hết các ứng dụng triển khai theo SOA đều có hướng triển khai từng service dưới dạng một khối có cùng thời gian runtime. Vì vậy, tương tự như các ứng dụng một khối, các service này theo thời gian cũng tích lũy nhiều nghiệp vụ và chức năng khác nhau. Sự tăng trưởng này sẽ sớm biến những service đó thành những _khối u nguyên khối_, không khác gì những ứng dụng một khối thông thường.

![img_1](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_1.jpg)

Hình 1 cho thấy một ứng dụng phần mềm bán lẻ bao gồm nhiều dịch vụ. Tất cả các service này được deploy trong cùng một ứng dụng runtime. Do đó nó cho thấy một số đặc điểm của một ứng dụng nguyên khối: nó phức tạp, được thiết kế, phát triển và deploy trong cùng một đơn vị duy nhất; nó quá khó để áp dụng các phương pháp phát triển linh hoạt và phân phối nhanh; cập nhật một phần ứng dụng sẽ bắt buộc phải triển khai lại toàn bộ ứng dụng.

 Ngoài ra còn một số vấn đề đối với kiến trúc một khối: Nó sẽ khó được scale nếu có xung đột về yêu cầu resource (ví dụ như một service cần nhiều CPU hơn trong khi service khác lại cần nhiều bộ nhớ hơn). Một service không ổn định có thể làm cả ứng dụng bị chết, và thông thường, nó khó có thể đổi mới và áp dụng các công nghệ hay framework mới.

 Những đặc điểm này là khởi đầu dẫn đến kiến trúc microservice ra đời. Hãy cùng xem xét cách thức hoạt động của nó.

# 2. Kiến trúc microservice
Nền tẳng của kiến trúc microservice (MSA) là về việc phát triển một ứng dụng bằng các service nhỏ và độc lập chạy trong tiến trình riêng của chúng. Các service này được phát triển và deploy một cách độc lập.

Hầu hết các định nghĩa về MSA giải thích nó như là một khái niệm kiến trúc tập trung vào việc tách các service sẵn có trong kiến trúc một khối thành một tập hợp các service độc lập. Tuy nhiên thì microservice không chỉ là làm những việc phân chia như thế.

Hãy xem xét điều đó bằng cách nhìn các chức năng trong kiến trúc một khối bằng cách xác định khả năng nghiệp vụ cần có từ ứng dụng - đó là trả lời câu hỏi ứng dụng cần làm gì, có ích hay không? Sau đó những khả năng đó có thể được thực hiện các service độc lập hoàn toàn, đủ tốt và khép kín. Chúng có thể được triển khai trên các stack công nghệ khác nhau, nhưng mỗi service sẽ giải quyết một phạm vi kinh doanh rất cụ thể và hạn chế.

Bằng cách này, kiến trúc hệ thống bán lẻ như hình 1 có thể được mô tả lại như sau:
![img_2](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_2.jpg)
Bây giờ hãy xem xét các nguyên tắc kiến trúc quan trọng của microservice và quan trọng hơn là tập trung vào cách chúng có thể được sử dụng trong thực tế.

# 3. Thiết kế Microservice: Size, Scope và Capabilities.
Bạn có thể làm một trong hai điều khi nói điều microservice: Một là bạn xây dựng ứng dụng của mình từ đầu và hai là bạn chuyển đổi ứng dụng/service của mình hiện có thành microservice. Dù bằng cách nào, điều quan trọng là bạn phải quyết định đúng kích thước, phạm vi và khả năng của các microservice. Đây có lẽ là điều khó nhất mà bạn cần gặp phải khi thực hiện MSA trong thực tế.

Dưới đây là một vài mối quan tâm chính và quan niệm sai lầm về chúng:

- Số dòng code (line of code)/ kích thước team (team size) là số liệu tệ hại: Có một số tranh luận về việc quyết định kích thước của microservice dựa trên số dòng code của việc triển khai hoặc [team size](http://blog.idonethis.com/two-pizza-team/).  Tuy vậy, đây được coi là những số liệu rất không thực tế và tệ hại.
- *Micro* là một thuật ngữ bị hiểu sai: Nhiều lập trình viên có xu hướng nghĩ rằng họ nên cố làm cho service nhỏ nhất có thể. Đây là một hiểu nhầm, không phải càng nhỏ thì càng tốt.
- Trong bối cảnh web service, các service thường được triển khai ở các mức độ chi tiết khác nhau - từ một vài chức năng đến vài chục chức năng. Việc có các webservice và đặt chúng dưới dạng microservice sẽ không đem lại cho bất kỳ lợi ích nào của MSA.

Vậy làm thế nào chúng ta có thể thiết kế service đúng cách trong MSA:

## 3.1 Hướng dẫn thiết kế microservice

- `Single Responsibility Priciple (SRP)`: Mỗi service cần có phạm vi và bị giới hạn về nghiệp vụ cụ thể, không phụ thuộc lẫn nhau. Điều đó giúp cho chúng ta đáp ứng sự phát triển linh hoạt và nhanh chóng trong cung cấp service.
- Trong giai đoạn thiết kế các microservice, chúng ta nên tìm ranh giới của chúng và tùy chỉnh chúng phù hợp với các nghiệp vụ (hay còn biết đến là giới hạn context trong [DomainDriven-Design](https://martinfowler.com/bliki/BoundedContext.html)).
- Chắc chắn việc thiết kế microservice đảm bảo sự phát triển và triển khai nhanh chóng, độc lập của service. Bạn nên tập trung vào phạm vi của microservice, không phải là cố làm cho nó nhỏ hơn.
- Thường thì bạn nên bắt đầu với các ranh giới service rộng, sau đó tái cấu trúc cho các ranh giới nhỏ hơn (dựa trên nghiệp vụ) theo thời gian.
Trong ví dụ về hệ thống bán lẻ ở trên, bạn có thể thấy nó đã phân chia các chức năng thành 4 microservice khác nhau là _inventory_, _accounting_, _shipping_ và _store_. Chúng đang giải quyết một nghiệp vụ cụ thể và mỗi service đều không phụ thuộc lẫn nhau, đảm bảo phát triển và deploy nhanh chóng.

# 4. Message trong microservice
Trong kiến trúc một khối, các chức năng nghiệp vụ của các component/ bộ xử lý khác nhau sẽ gọi nhau bằng cách sử dụng các lệnh hàm gọi hoặc các method gọi hàm của ngôn ngữ lập trình. Trong SOA, điều này đã được chuyển sang cách request/response các message service có tính lỏng lẻo hơn, chủ yếu dựa trên SOAP với nhiều giao thức khác nhau như HTTP, JMS.

## 4.1 Tin nhắn đồng bộ (Synchronous Messaging) - REST, Thrift
Đối với tin nhắn đồng bộ ( client yêu cầu phản hồi kịp thời từ các service và thời gian đợi để nhận được nó) trong MSA, REST là lựa chọn dễ nhất vì nó cung cấp một kiểu message đơn giản với các request, respose HTTP. Do đó hầu hết các microservice đều sử dụng HTTP bên cạnh các tài nguyên khác (mỗi chức năng đại diện cho một tài nguyên và các hoạt động sẽ được thực hiện trên các tài nguyên khác).
![img_3](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_3.jpg)
`Thift` được sử dụng như một thay thế cho REST/HTTP trong đồng bộ tin nhắn.

## 4.2 Tin nhắn không đồng bộ (Asynchronous) - AMQP, STOMP, MQTT
Đối với một số hoàn cảnh chúng ta bắt buộc phải sử dụng các tin nhắn không đồng bộ ( client không muốn phản hồi ngay lập tức hoặc muốn hoàn toàn không phản hồi). Trong những tình huống này, các giao thức tin nhắn không đồng bộ như AMQP, STOPM hay MQTT được sử dụng phổ biến.

## 4.3 Message Format - JSON, XML, Thrift, ProtoBuf, Avro
Một yếu tố quan trọng khác là định dạng của message. Các ứng dụng một khối truyền thống sử dụng các định dạng nhị phân phức tạp, còn SOA/Web service lại sử dụng các message dựa trên các định dạng message phức tạp (SOAP) hay schema (xsd). Hầu hết các ứng dụng dựa trên microservice sử dụng các định dạng message dựa trên văn bản đơn giản như JSON hay XML trên HTTP REST API. Trong trường hợp chúng ta cần các định dạng message nhị phân (do message văn bản có thể trở nên dài dòng), microservice có thể tận dụng định dạng message nhị phân như binary Thrift, ProtoBuf hay Avro.

## 4.4 Service Contracts - Khai báo Service Interface - Swagger, RAML, Thrift IDL
Khi bạn có một nghiệp vụ có thể làm thành một service, bạn sẽ cần làm những bản service contract (đại loại một văn bản mà bạn muốn những client khác gọi đến phải tuân theo những nguyên tắc trong đó để trích xuất được dữ liệu). Trong ứng dụng một khối truyền thống, chúng ta hầu như không cần làm bởi vì các service bên trong có thể gọi nhau qua framework hoặc ngôn ngữ nền tảng. Trong SOA/Web service, WSDL thường được dùng để làm service contract, nhưng WSDL không phải là giải pháp trong một hệ thống microservice dùng REST để giao tiếp giữa các service.

Bởi vì chúng ta xây dựng microservice dựa trên kiến trúc REST nên chúng ta có thể sử dụng các kỹ thuật định nghĩa API trong REST để tạo một service contract. Do đó, chúng ta có thể sẻ dụng Swagger và RAML để định nghĩa service contract.

Đối với các hệ thống không dựa trên HTTP/REST, chẳng hạn như Thrift, chúng ta có thể dùng  `Interface Definition Languages (IDL)` như Thrift IDL.

# 5. Quản lý dữ liệu phân tán
Trong kiến trúc một khối, ứng dụng lưu trữ dữ liệu trong các cơ sở dữ liệu đơn và tập trung để thực hiện các chức năng/khả năng khác nhau của ứng dụng.
![img_4](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_4.jpg)
Trong MSA< các chức năng được phân tán trên nhiều microservice và nếu chúng ta sử dụng cùng một cơ sở dữ liệu tập trung thì nó rất khó đảm bảo tính lỏng lẻo giữa các service bởi nếu nếu database schema có sự thay đổi ở một service nào đó có thể sẽ làm chết một vài service khác. Do đó, mỗi service cần phải có cơ sở dữ liệu riêng.
![img_5](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534648/microservice%20in%20practice/soa_5.jpg)
Dưới đây là các khía cạnh chính của việc thực hiện quản lý dữ liệu phân tán trong MSA:

- Mỗi microservice có thể có một cơ sở dữ liệu riêng để duy trì dữ liệu cần thực hiện chức năng nghiệp vụ của nó.
- Một microservice cụ thể chỉ có thể truy cập vào cơ sở dữ liệu riêng của nó, chứ không phải cơ sở dữ liệu của các service khác.
- Trong một số tình huống, bạn có thể phải cập nhật một số cơ sở dữ liệu cho một giao dịch. Trong các trường hợp như vậy, cơ sở dữ liệu của các service khác chỉ được cập nhật thông qua API của nó (không được phép truy cập trực tiếp vào cơ sở dữ liệu).

Việc quản lý dữ liệu phân tán sẽ cung cấp cho bạn các service tách rời hoàn toàn và tự do lựa chọn các kỹ thuật quản lý dữ liệu khác nhau (SQL hoặc NoSQL,... các hệ thống quản trị cơ sở dữ liệu khác nhau cho mỗi service). Tuy nhiên, đối với các trường hợp sử dụng transaction phức tạp liên quan đến nhiều service, các transaction  phải được thực hiện bằng cách sử dụng API được cung cấp từ mỗi service và logic tại client hoặc các tầng trung gian (Gateway).

# 6. Quản trị phân tán
MSA rất thích hợp để quản trị phân tán. Quản trị trong IT được hiểu là các quy trình đảm bảo việc sử dụng công nghệ hiệu quả và cho phép một tổ chức đạt được mục tiêu của mình. Trong SOA, quản trị SOA hướng dẫn phát triển các service có thể sử dụng lại, thiết lập cách thức các service sẽ được thiết kế, phát triển và cách các service đó thay đổi theo thời gian. Nó thiết lập các thỏa thuận giữa bên cung cấp service và người sử dụng service, nói cho người sử dụng biết những gì họ mong muốn và cho bên cung cấp biết những gì họ bắt buộc phải cung cấp. Quản trị SOA có hai loại quản trị thường được dùng phổ biến:

- Quản trị *Design-time*: xác định và kiểm soát cách tạo, thiết kế và phát triển service theo policy.
- Quản trị *Run-time*: xác định khả năng thực thi các policy trong suốt thời gian thi hành.

Vậy quản trị trong microservice có ý nghĩa là gì? Trong MSA, microservice được xây dựng dưới các service độc lập và tách rời hoàn toàn với các nền tảng công nghệ khác nhau. Do đó không cần xác định một tiêu chuẩn chung cho thiết kế và phát triển service. Chúng ta có thể tóm tắt quản trị phân tán của microservice như sau:

- Các service có thể tự đưa ra những nguyên tắc về thiết kế và cách thực hiện của riêng nó.
- MSA khuyến khích việc chia sẻ các service chung hoặc có thể tái sử dụng.
- Các khía cạnh quản trị run-time như SALs, điều tiết, giám sát, các yêu cầu chung về bảo mật và service discovery sẽ không được triển khi trên mỗi service. Thay vào đó, chúng nên được ở trong các component chuyên dụng (thường ở tầng API-gateway).

# 7. Service Registry và Service Discovery
Trong MSA, số lượng các service mà bạn cần để làm việc sẽ là khá nhiều. Chúng thay đổi vị trí linh hoạt do tính chất cần phát triển nhanh của microservice. Do đó, bạn cần tìm vị trí của microservice trong suốt thời gian runtime. Giải pháp cho vấn đề này là sử dụng `Service Registry`.

## Service Registry
Service registry là nơi để chứa các metadata của các microservice instances (bao gồm vị trí location, host port,...). Các microservice instance được đăng ký với service registry khi khởi động và sẽ hủy đăng ký khi bị shut down. Các thành phần khác cần tìm thông tin của một microservice nào đó thì sẽ tìm thông qua service registry.

## Service Discovery
Để tim các microservice đang hoạt động và vị trí location của nó, chúng ta cần đến cơ chế `service discovery`. Có 2 loại cơ chế `service discovery` là client-side discovery và server-side discovery. Chúng ta sẽ xem xét kỹ hơn về các cơ chế này:

- Client-side discovery
Theo cách tiếp cận này, client hoặc API-gateway sẽ có được vị trí của một service instance bằng cách truy vấn một service registry.
![img_6](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534648/microservice%20in%20practice/soa_6.jpg)

- Server-side discovery
Với phương pháp này, client/API gateway sẽ gửi một request đến một component (ví dụ như một load balancer) chạy trên một location đã biết. Component đó sẽ gọi đến service registry và xác địh vị trí location mà request cần đến.
![img_7](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534646/microservice%20in%20practice/soa_7.jpg)
Các microservice có thể tận dụng các giải pháp deployment như Kubernetes cho service-side discovery.

# 8. Deployment
Khi nói đến MSA, việc deploy các service đóng một vai trò quan trọng và có các yêu cầu chính như sau:

- Khả năng deploy/undeploy độc lập đối với các service khác.
- Phải có khả năng scale cho từng service.
- Deploy nhanh chóng.
- Lỗi trong một service sẽ không được làm ảnh hưởng đến bất kỳ service nào khác.
[Docker](https://www.docker.com/) (một công cụ mã nguồn mở cho phép các lập trình viên và quản trị viên hệ thống deploy các container trong mỗi trường Linux) cung cấp một cấp tuyệt vời để deploy các service theo các yêu cầu trên. Các ý chính bao gồm:

- Package của service dưới dạng một Docker image.
- Deploy mỗi service instance bằng một container.
- Scale được thực hiện dựa trên việc thay đổi số lượng container instance.
- Build, deploy và khởi động một service sẽ nhanh hơn nhiều khi sử dụng Docker container (so với các máy ảo VM thông thường).

[Kubernetes](https://kubernetes.io/) là một công cụ có khả năng mở rộng các tính năng của Docker bằng cách cho phép quản lý một cụm (cluster) Linux container dưới dạng một hệ thống duy nhất, quản lý và chạy các Docker container trên nhiều máy chủ, cung cấp các vị trí cùng cấp (co-location) của các container, service discovery và các kiểm soát khác. Như bạn có thể thấy, hầu hết các tính năng này đều rất cần thiết trong hệ thống microservice. Do đó, sử dụng Kubernetes (dựa trên Docker) để triển khai hệ thống microservice đã trở thành một giải pháp mạnh mẽ, đặc biệt là đối với các hệ thống có quy mô lớn.
![img_8](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534646/microservice%20in%20practice/soa_8.jpg)

# 9. Bảo mật
Bảo mật là một yêu cầu quan trọng và phổ biến khi bạn sử dụng microservice trong thực tế. Trước khi tìm hiểu bảo mật trong microservice, chúng ta sẽ xem xét qua cách mà chúng ta thường triển khai bảo mật ở một ứng dụng một khối.

- Trong một ứng dụng nguyên khối điển hình, bảo mật là tìm ra "ai là người gọi", "người gọi có thể làm gì" và "chúng ta truyền thông tin đó như thế nào".
- Điều này thường được thực hiện tại một component bảo mật chung, nằm ở đầu chuỗi xử lý yêu cầu và component  đó chứa thông tin cần thiết với việc sử dụng vùng lưu trữ người dùng bên dưới.

Vậy thì chúng ta có thể trực tiếp sử dụng lại các nguyên tắc này ở MSA không? Câu trả lời là có, nhưng nó đòi hỏi một component bảo mật được triển khai ở từng service có thể giao tiếp với vùng lưu trữ thông tin user và truy xuất thông tin cần thiết. Đó là một cách giải quyết rất tệ trong bảo mật microservice.

Thay vào đó, chúng ta có thể tận dụng các tiêu chuẩn bảo mật API đang được dùng phổ biến như OAuth 2.0, OpenID Connect để tìm giải pháp tốt hơn cho vấn đề bảo mật. Trước khi đi sâu vào vấn đề đó, trước tiên hãy tóm tắt mục đích của từng tiêu chuẩn và cách chúng ta có thể sử dụng chúng.

- `OAuth 2.0`Là một giao thức ủy quyền truy cập. Client xác thực với một server ủy quyền và nhận được mã token, được gọi là 'Access token'. Một access token sẽ không có thông tin nào về user/client. Nó chỉ có một tham chiếu đến thông tin user chỉ có thể truy xuất bởi server ủy quyền. Do đó nó còn được gọi là `by-reference token` và nó đủ an toàn ngay khi trong mỗi trường mạng internet công khai.
- `OpenID Connect` hoạt động tương tự như OAuth, nhưng ngoài access token, server ủy quyền sẽ phát hành mã token ID có chứa thông tin về người dùng. Điều này thường được triển khai bằng JWT (JSON Web Token) và nó được đăng ký bởi server ủy quyền. Điều này đảm bảo sự tin tưởng giữa server ủy quyền và client. Do đó, JWT còn được gọi là `by-value token` vì nó chứa thông tin của người dùng và rõ ràng không an toàn khi sử dụng bên ngoài mạng nội bộ.

Bây giờ, hãy xem cách chúng ta có thể sử dụng các tiêu chuẩn này để bảo mật các service trong ví dụ cửa hàng bán lẻ lúc đầu:
![img_9](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_9.jpg)
Như đã mô tả trong hình trên, các bước chính cần có liên quan đến việc triển khai bảo mật trong hệ thống microservice là:

- Để lại việc xác thực cho OAuth 2.0 và OpenID Connect (server ủy quyền), nhờ vậy microservice sẽ cung cấp quyền truy cập thành công khi ai đó có quyền sử dụng dữ liệu.
- Sử dụng API-gateway trong đó có một entry-point duy nhất cho tất cả các yêu cầu của máy khách.
- Client kết nối với server ủy quyền và nhận access token (by reference token). Sau đó sẽ gửi các access token kèm theo trong mỗi lần request đến API-gateway.
- Token sẽ được giải mã ở gateway - API-gateway trích xuất access token và gửi nó đến server ủy quyền để truy xuất JWT. (by value-token).
- Cổng gateway sẽ dùng mã JWT kèm theo mỗi lần request đến tầng microservice.
- JWT chứa các thông tin cần thiết để lưu trữ các phiên người dùng... Nếu mỗi service đều có thể hiểu một JSON token thì bạn có thể phân phối cơ chế nhận dạng của mình mà cho phép vận chuyển danh tính của người dùng trên toàn hệ thống của bạn.
- Ở mỗi lớp microservice, chúng ta có thể có một component nhỏ để xử lý JWT.

# 10. Inter-Service/Process Communication
Trong MSA, các ứng dụng được xây dựng như một tập hợp các service độc lập. Do đó để biết khi nào cần đến nghiệp vụ nào thì chúng ta cần phải có các cấu trúc giao tiếp giữa các service hay quy trình khác nhau.
Từ khi microservice sử dụng các chuẩn giao thức (như HTTP) và các định dạng message (như JSON,...) thì yêu cầu tích hợp với một giao thức khác là yêu cầu tối thiểu khi nhắc đến việc giao tiếp giữa các microservice. Một cách tiếp cận khác trong giao tiếp microservice là sử dụng bus message hoặc cổng gateway với khả năng định tuyến tối thiểu và chỉ hoạt động như một 'dumb pipe' không triển khai bất kì nghiệp vụ nào trên gateway. Dựa trên những phương pháp này, chúng ta có một số kiểu giao tiếp như sau:

## 10.1 Point-to-Point Style - Gọi service trực tiếp
Trong kiểu `point-to-point` , toàn bộ logic định tuyến message nằm trên mỗi điểm cuối và các service có thể giao tiếp trực tiếp. Mỗi microservice sẽ expose một REST API và một microservice cụ thể hoặc một client bên ngoài có thể gọi một microservice khác thông qua REST API của nó.
![img_10](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534648/microservice%20in%20practice/soa_10.jpg)
Rõ ràng mô hình này hoạt động cho các ứng dụng microservice tương đối đơn giản, nhưng khi số lượng service tăng lên, điều này sẽ trở nên phức tạp vô cùng. Sau tất cả, đó chính là lý do cho việc sử dụng ESB trong triển khai SOA truyền thống, đó là loại bỏ các liên kết tích hợp point-to-point lộn xộn này. Hạn chế của kiểu giao tiếp này được liệt kê như sau:

- Các yêu cầu phi chức năng, chẳng hạn như xác thực người dùng cuối, điều chỉnh, giám sát, v.v ... cần phải được thực hiện ở mỗi cấp độ microservice.
- Do việc sao chép các common function, mỗi microservice có thể trở nên phức tạp.
- Không có trung tâm lưu trữ các yêu cầu phi chức năng, như giám sát, truy tìm hoặc bảo mật cần được áp dụng ở mỗi cấp độ service.
- Thông thường kiểu giao tiếp trực tiếp được coi là `microservice anti-pattern` khi dùng trong các hệ thống microservice quy mô lớn.

## 10.2 API-Gateway Style
Ý tưởng chính đằng sau kiểu  API-Gateway là sử dụng một message gateway nhẹ làm điểm vào chính cho tất cả client/consumers và thực hiện các yêu cầu phi chức năng phổ biến ở cấp độ gateway. Nói chung, một API-Gateway cho phép bạn sử dụng API được quản lý qua REST/HTTP. Do đó, bạn có thể expose các business functions của mình được triển khai dưới dạng microservice thông qua API-Gateway dưới dạng một API được quản lý. Trên thực tế, đây là sự kết hợp giữa quản lý MSA và API.
![img_11](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534648/microservice%20in%20practice/soa_11.jpg)
Trong kịch bản kinh doanh bán lẻ ban đầu, như được mô tả trong Hình 11, tất cả các microservice được hiển thị thông qua một API-gateway và đó là điểm vào duy nhất cho tất cả các client. Kiểu API-gateway sẽ đem lại cho bạn những lợi ích sau:

- Có khả năng cung cấp các khái niệm trừu tượng cần thiết ở cấp độ gateway cho các microservice, ví dụ: thay vì cung cấp API one-size-fits-all, API-gateway có thể expose API khác nhau cho từng khách hàng.
- Định tuyến/chuyển đổi message nhẹ ở cấp độ gateway- bạn có thể thực hiện lọc, định tuyến và chuyển đổi thông báo cơ bản ở gateway layer.
- Nơi tập trung để áp dụng các yêu cầu phi chức năng, như bảo mật, giám sát và điều tiết - thay vì thực hiện các tính năng chung này ở mỗi lớp microservice.
- Với việc sử dụng mẫu API-gateway, microservice sẽ trở nên nhẹ hơn nữa vì tất cả các yêu cầu phi chức năng được thực hiện ở cấp độ gateway.

Kiểu API-gateway cũng có thể là mẫu được sử dụng rộng rãi nhất trong hầu hết các triển khai microservice.

## 10.3 Message Broker Style
Trong các tình huống message không đồng bộ, chẳng hạn như các request một chiều sử dụng hàng đợi queues. Điều đó có nghĩa là một microservice có thể là nguồn cung cấp message và nó có thể gửi các message không đồng bộ đến một queue hoặc topic. Sau đó những microservice xử lý message đó sẽ lấy nguồn từ một queue hoặc topic. Kiểu giao tiếp này sẽ tách biệt nguồn cung message và nơi cần sử dụng message. Nó sử dụng một khu vực trung gian để lưu trữ các message cho đến khi những service cần đến có thể xử lý những message đó. Như vậy, các microservice gửi message sẽ không hề biết những microservice nào sử dụng message.
![img_12](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534646/microservice%20in%20practice/soa_12.jpg)
Giao tiếp giữa consumers/producers được tạo thông qua một message broker dựa trên các tiêu chuẩn message không đồng bộ, chẳng hạn như AMQP, MQTT, v.v.

# 11. Transactions
Các transaction được hỗ trợ như thế nào trong microservice? Trên thực tế thì đây là một nhiệm vụ phức tạp. Kiến trúc microservice khuyến khích các service không có transaction. Lý do là một service nên hoàn toàn khép kín và chỉ có một nhiệm vụ duy nhất. Do đó, trong hầu hết các trường hợp, transaction chỉ được áp dụng ở phạm vi của các microservice (tức là không phải trên nhiều microservice).

Tuy nhiên, nếu có một yêu cầu bắt buộc là phải có các transaction trên nhiều service, thì các kịch bản như vậy có thể được thực hiện bằng việc bổ sung các "hoạt động bù" ở cấp độ microservice. Có nghĩa là một microservice cụ thể chỉ có một nhiệm vụ và nếu một microservice cụ thể không thực hiện được nhiệm vụ, chúng ta có thể coi đó là một thất bại của toàn bộ microservice đó. Sau đó, tất cả các hoạt động upstream khác phải được hoàn tác bằng cách gọi hoạt động bù tương ứng của các microservice đó.

# 12. Thiết kế khi gặp lỗi
MSA là một bộ service phân tán và so với thiết kế nguyên khối, nó làm tăng khả năng gặp sự cố ở mỗi cấp độ service. Một microservice cụ thể có thể thất bại do sự cố mạng, không có sẵn tài nguyên cơ bản, v.v. Một microservice không có sẵn hoặc không phản hồi sẽ không được phép làm chết cả ứng dụng. Do đó, bản thân mỗi microservice nên có khả năng chịu lỗi, có thể phục hồi và nhờ đó client sẽ xử lý lỗi một cách mềm mại. Hơn nữa, vì các service có thể thất bại bất cứ lúc nào, điều quan trọng là có thể phát hiện (giám sát theo thời gian thực) các lỗi một cách nhanh chóng và nếu có thể, các service này sẽ tự động khôi phục.

Dưới đây là một số phương pháp xử lý lỗi trong microservice:

### Circuit Breaker
Khi bạn gọi đến một service, bạn sẽ muốn cài đặt một thành phần giám sát lỗi với mỗi lần gọi, và khi số lỗi đạt ngưỡng nhất định thì thành phần đó sẽ dừng tất cả các request của service (ngắt mạch). Sau một số lượng request nhất định ở trạng thái mở (mà bạn có thể định cấu hình), hãy thay đổi mạch trở lại trạng thái đóng. Thiết kế này khá hữu ích để tránh tiêu thụ tài nguyên không cần thiết, yêu cầu phản hồi chậm trễ do timeout và cũng cung cấp cho chúng ta cách để giám sát hệ thống (dựa vào trạng thái mạch mở hoạt động).

### Bulkhead
Mẫu thiết kế `Bulkhead` là cách thiết kế để cách ly các thành phần khác nhau trong ứng dụng để khi một service bị lỗi sẽ không ảnh hưởng đến bất kì service nào khác.

### Timeout
Mẫu timeout là một cơ chế cho phép bạn ngừng chờ phản hồi từ microservice khi bạn nghĩ rằng nó sẽ không đến. Tại đây, bạn có thể chỉ định khoảng thời gian bạn muốn chờ.

Như vậy, chúng ta sẽ sử dụng các mẫu thiết kế này khi nào và như thế nào? Trong hầu hết các trường hợp thì các mẫu này sẽ được áp dụng ở cấp độ gateway. Điều này có nghĩa là khi microservice không khả dụng hoặc không phản hồi ở cấp độ cổng, chúng ta có thể quyết định có nên gửi yêu cầu tới microservice bằng cách sử dụng `circuit breaker` hoặc mẫu `timeout` hay không. Áp dụng theo mẫu `bulkhead` ở gateway cũng rất quan trọng vì nó là điểm đầu vào duy nhất cho tất cả request của client, do đó, sự thất bại trong một service nhất định sẽ không ảnh hưởng đến việc gọi các service khác.

Ngoài ra, cổng gateway có thể được sử dụng làm trung tâm lưu trữ mà tại đó chúng ta có thể có được trạng thái và giám sát từng service, vì mỗi service đều được gọi thông qua cổng gateway.

# 13. Microservice trong kiến trúc doanh nghiệp hiện đại
![img_13](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_13.jpg)
Hình 13 minh họa một kiến ​​trúc CNTT doanh nghiệp cấp cao. Ở đây, chúng ta đã sử dụng một kiến ​​trúc lai bao gồm cả microservice và các hệ thống hiện có. Có những quyết định thiết kế chính mà bạn cần phải đưa ra khi giới thiệu MSA cho tổ chức của mình:

- Sử dụng MSA để làm giải pháp bất cứ khi nào cần và cố gắng đạt được toàn bộ sức mạnh mà MSA mang lại.
- Tích hợp doanh nghiệp vẫn là bắt buộc : vì chúng ta sẽ có một cách tiếp cận hỗn hợp, bạn vẫn sẽ cần tích hợp tất cả các hệ thống và dịch vụ nội bộ của mình với việc sử dụng một phần mềm tích hợp, chẳng hạn như ESB.
- Bạn sẽ không thể vứt bỏ hầu hết các hệ thống hiện có, bởi các microservice mới có thể cần phải gọi các hệ thống nguyên khối đó để tạo điều kiện cho các yêu cầu kinh doanh khác nhau.
- Các ESB 'mới': Mặc dù phần mềm tích hợp, chẳng hạn như ESB, vẫn có thể cần thiết cho kiến ​​trúc doanh nghiệp hiện đại, thì một tổ chức vẫn nên tìm kiếm phần mềm tích hợp nhẹ, hiệu suất cao và có thể mở rộng thay vì các frameworks tích hợp hạng nặng.
- Quản lý API: microservice có thể được expose thông qua cổng gateway và tất cả các kỹ thuật quản lý API có thể được áp dụng ở lớp đó. Tất cả các yêu cầu khác như bảo mật, điều chỉnh, lưu trữ và giám sát phải được thực hiện ở cổng gateway. Hơn nữa, các service không dựa trên microservice (SOA truyền thống) cũng có thể được expose thông qua cổng API gateway.

# 14. Tích hợp Microservice
Các câu hỏi thường gặp nhất trong microservice là 'microservice có thể nói chuyện với nhau không?', 'làm thế nào để xây dựng các microservice mới bằng cách tận dụng một microservice  hiện có?' hoặc 'làm thế nào để chúng ta soạn thảo/tích hợp microservice và hình thành các service/solution?'.

Trên thực tế, MSA thúc đẩy xây dựng một microservice với phạm vi kinh doanh hạn chế và tập trung. Do đó, khi nói đến việc xây dựng các giải pháp CNTT trên MSA, không thể tránh khỏi việc chúng ta phải sử dụng các microservice hiện có. Sự tương tác giữa các microservice có thể được thực hiện theo kiểu point-to-point thông thường. Tuy nhiên, cách tiếp cận đó trở nên khá dễ phá vỡ (với quá nhiều tương tác point-to-point, khó quản lý, duy trì, scale và khắc phục sự cố) khi nói đến các giải pháp microservice. Do đó, chúng ta cần tuân thủ các nguyên tắc tốt nhất về tích hợp các microservices để loại bỏ các nhược điểm của tương tác kiểu point-to-point.

- Sử dụng một cổng gateway để expose các microservices: Sử dụng một cổng gateway ở trước tất cả các microservices và tất cả consumers chỉ sử dụng các microservices thông qua cổng gateway .
- Không có gọi trực tiếp giữa các microservices: microservice không thể gọi trực tiếp các microservice, tất cả các cuộc gọi phải đi qua cổng gateway.
- Micro-integration thông qua một máy chủ tích hợp.

## 14.1 Phối hợp tại Microservices Layer
Khi bạn phải gọi nhiều microservices để hỗ trợ một yêu cầu business nhất định, bạn có thể xây dựng một microservice khác (một lần nữa giải quyết phạm vi business hạn chế) sẽ điều phối các request service đến các microservices cần thiết và tổng hợp phản hồi cuối cùng và gửi lại cho consumer ban đầu.

Ví dụ, Hình 14 mô tả một kịch bản trong đó chúng ta có một vài microservices là A, B, C và D. Bây giờ chúng tôi muốn đưa ra một chức năng mới đòi hỏi phải gọi microservice A và C một cách tuần tự và cung cấp một phản hồi tổng hợp. Để làm điều này, chúng ta có thể xây dựng một microservice mới (microservice E) và logic phối hợp có chứa dịch vụ gọi A và C được nhúng vào microservice E. Tất cả các yêu cầu của microservice được thực hiện thông qua cổng gateway. Nếu microservice E phải được scale một cách độc lập, điều đó có thể được thực hiện bằng cách scale microservice E, A và C theo yêu cầu.
![img_14](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534646/microservice%20in%20practice/soa_14.jpg)

## 14.2 Phối hợp tại Gateway Layer
Cách tiếp cận khả thi khác là thực hiện cùng một kịch bản phối hợp bằng cách đưa logic phối hợp đến cấp độ cổng gateway. Trong trường hợp này, chúng ta không phải đưa ra một microservice mới, nhưng sẽ cần một lớp virtual service được lưu trữ trong cổng gateway đảm nhiệm việc điều phối.

Ví dụ, như trong Hình 15, service gọi tới microservice A và C có thể được triển khai bên trong cổng gateway (hầu hết các cài đặt microservice gateway đều hỗ trợ tính năng này).

Khi việc scale business mới được nói đến, chúng ta phải scale quy mô của cổng gateway và microservice A và C. Với điều này, cổng gateway sẽ trở nên hơi nguyên khối vì nó cũng chịu trách nhiệm định tuyến tất cả các microservices requests khác.
![image_15](https://res.cloudinary.com/deop9ytsv/image/upload/v1545534647/microservice%20in%20practice/soa_15.jpg)

## 14.3 Micro-Integration
Khi chúng ta phải xây dựng các giải pháp tích hợp, thường thì việc sử dụng một máy chủ tập trung có chứa logic tích hợp được xem xét hàng đầu. Khái niệm tích hợp vi mô (micro-integration) là một framework tích hợp nhẹ có thể được sử dụng để xây dựng các giải pháp tích hợp; nó có thể tích hợp microservers và các service/system khác (tại chỗ hoặc SaaS). Và chúng ta có thể scale chúng tại thời điểm runtime chứ không như phương pháp xây dựng máy chủ tích hợp thông thường, nơi mà chúng ta chỉ có thể scale theo những kịch bản lựa chọn sẵn.

## 14.4 Choreography Style
Một cách tiếp cận khả thi khác là xây dựng các tương tác giữa các microservices bằng cách sử dụng kiểu message không đồng bộ, chẳng hạn như MQTT hoặc Kafka. Trong trường hợp này, không có thành phần trung tâm nào đảm nhiệm các tương tác service. Các service khác nhau có thể thực hiện message bằng các giao thức
messaging protocol.

# 15. WSO2 Microservices Framework cho Java (WSO2 MSF4J)

Có khá nhiều thư viện và framework để xây dựng microservice, nhưng hầu hết trong số đó không thực sự tuân thủ các nguyên tắc cốt lõi của microservice, chẳng hạn như nhẹ hoặc thân thiện với container.

WSO2 cung cấp một microservice framework nhẹ, nhanh và thân thiện với container.

[WSO2 Microservices Framework for Java](https://wso2.com/products/microservices-framework-for-java/) (WSO2 MSF4J) cung cấp tùy chọn tốt nhất để tạo microservice trong Java với ý định triển khai dựa trên container. Các dịch vụ được phát triển bằng WSO2 MSF4J có thể khởi động chỉ trong vài mili giây trong Docker và có thể dễ dàng tạo Docker image.

# 16. Tổng kết
Kh i bạn muốn kết hợp MSA trong môi trường CNTT doanh nghiệp hiện đại ngày nay, các khía cạnh chính bạn cần quan tâm tổng kết lại sau:

- Microservice không phải là thuốc chữa bách bệnh - nó không giải quyết tất cả các nhu cầu CNTT của doanh nghiệp của bạn, vì vậy chúng ta cần sử dụng nó với các kiến ​​trúc hiện có khác.
- Dùng SOA hợp lý.
- Hầu hết các doanh nghiệp sẽ không thể chuyển đổi toàn bộ hệ thống CNTT doanh nghiệp của họ sang microservice. Thay vào đó, họ sẽ sử dụng microservice để giải quyết một số trường hợp sử dụng kinh doanh trong đó họ có thể tận dụng sức mạnh của MSA.
- Tích hợp doanh nghiệp sẽ không bao giờ biến mất - điều đó có nghĩa là bạn cần phải có phần mềm tích hợp, chẳng hạn như ESB, để phục vụ cho tất cả các nhu cầu tích hợp doanh nghiệp của bạn.
- Tất cả business functions phải được expose dưới dạng API bằng cách tận dụng các kỹ thuật quản lý API.
- Tương tác giữa các microservices nên được thực hiện qua cổng gateway.
- Việc phối hợp service giữa các microservice có thể được yêu cầu cho một số business và có thể được triển khai bên trong một microservice khác hoặc ở tại lớp gateway.

# Nguồn
 https://wso2.com/whitepapers/microservices-in-practice-key-architectural-concepts-of-an-msa/
