

---
title: "[Spring Boot] Secu thập chưởng bảo vệ app Spring Boot của bạn"
slug: spring-boot-10-ways-security
date: 2018-11-06
categories:
- Spring Boot
- Security
tags:
- Spring Boot
- Security
keywords:
- Spring
- Spring Boot
- Security
- Share
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://assets.simpleviewcms.com/simpleview/image/fetch/c_limit,h_640,q_60,w_800/https://res.cloudinary.com/simpleview/image/upload/crm/howardcounty/spring-boot-icon0_cf21dec4-5056-b3a8-49c015fd3bde6cb5.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Spring Boot được release lần đầu năm 2014 và không có nhiều thay đổi đáng kể cho đến hiện tại. Với mục tiêu tự động cấu hình và giảm thiểu lượng code để có thể start một ứng dụng, Spring Boot đã giúp cho không biết con dân nhà Spring dễ sống và bớt chửi thề đi.
Giống như khi dùng bất kì một framework nào để xây dựng ứng dụng, điều bạn cần quan tâm không chỉ là chất lượng code, vượt qua các test case, ... mà còn là khả năng bảo mật của ứng dụng. Các cụ có câu: "Phật cao một thước, ma cao một trượng". Thế nên bạn nào chưa có tư tưởng phát triển ứng dụng mà cần bảo mật thì liệu mà quan tâm đi. Bộ bí kíp này được truyền lại theo [Matt Raible](https://developer.okta.com/blog/2018/07/30/10-ways-to-secure-spring-boot) và được việt hoá bởi tôi, nhằm mục đích hướng dẫn các bạn những tuyệt chiêu xây dựng một ứng dụng Spring Boot bảo mật.

# Chưởng 1: Hãy sử dụng HTTPS cho môi trường production
`Transport Layer Security (TLS)` hay còn được biết đến với cái tên `HTTPS` hay khái niệm `SSL (Secure Sockets Layer)`. `TLS` là một giao thức bảo mật cung cấp một môi trường giao tiếp an toàn trên mạng máy tính, đảm bảo sự riêng tư và tính toàn vẹn giữa các ứng dụng máy tính.

Để sử dụng được giao thức này, bạn cần mua chứng chỉ TLS, hoặc dùng hàng miễn phí. Chi tiết vụ mua bán này có lẽ mình sẽ viết trong một bài viết khác. Bạn nào rảnh rỗi có thể nghiên cứu thêm ở [đây](https://letsencrypt.org/)

Để bật chế độ HTTPS trong ứng dụng Spring Boot, bạn cần có một class thừa kế `WebSecurityConfigurerAdapter` và dùng method `requiresSecure()` như sau:
```java
@Configuration
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

 @Override
 protected void configure(HttpSecurity http) throws Exception {
   http.requiresChannel().requiresSecure();
 }
}
```
Cách cấu hình này có thể sử dụng trong môi trường "độc lập tự do", nơi mà hầu hết chúng ta đều gặp đau thương khi phải tự mình mua và cài đặt một chứng chỉ TLS. Nếu bạn sử dụng [Heroku](https://www.heroku.com/), [Cloud Foundry](https://www.cloudfoundry.org/) hay bất kì một nhà cung cấp dịch vụ cloud nào khác, các chứng chỉ TLS sẽ được tự động cung cấp cho người dùng, vì vậy bạn chỉ cần thêm một ít code nữa như dưới đây là đủ.

```java
@Configuration
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.requiresChannel()
            .requestMatchers(r -> r.getHeader("X-Forwarded-Proto") != null)
            .requiresSecure();
    }
}
```
# Chưởng 2: Kiểm tra Dependencies bằng Snyk
Thông thường khi chúng ta sử dụng các tool quản lý thư viện như Maven, Gradle,... chúng ta thường thêm các dependencies mà không hề kiểm tra cũng như kiểm soát tính bảo mật của những thư viện này. Vì vậy, những kẻ tà ma ngoại đạo có thể tấn công thông qua các `open source` này mà nhưng con dân tin người như chúng ta hoàn toàn không hay biết. :grin:

[Snyk](https://snyk.io/) là một công cụ giúp kiểm tra ứng dụng của chúng ta có sử dụng `dependencies` nào nguy hại không. Nó sẽ liệt kê hết các nguy cơ, lỗ hổng tồn tại trong những `packages` mà chúng ta sử dụng lên một `dashboard`.

![](https://developer.okta.com/assets/blog/spring-boot-10-ways-to-secure/snyk-vulnerabilities-9687d386d37830a36649fc93b2e7b3bc946ccdd5e84374c0a95e7b24e84555a3.png)
Ngoài ra nó còn giúp đưa ra các giải pháp ngăn chặn bằng cách tạo tạo một `pull request` lên source code của bạn. Nó cũng giúp kiểm tra và đảm bảo tất cả các `pull request` đều không gặp phải các lỗ hổng bảo mật đã biết.

Thêm nữa là nó cũng có sẵn giao diện người dùng như CLI, vì vậy bạn có thể tích hợp nó với môi trường CI của mình, đảm bảo hệ thống sẽ an toàn ngay từ lúc build.
Bạn có thể sử dụng `Snyk` phiên bản free để dành cho các `open source` của bạn hoặc các dự án riêng với giới hạn thời gian test.

# Chưởng 3: Sử dụng các bản Lastest Release
Có rất nhiều lí do để chúng ta phải thường xuyên cập nhật các `dependencies` cho ứng dụng của mình. Và lí do bảo mật là một trong những nỗi lo hàng đầu. Các ứng dụng spring boot được generate từ https://start.spring.io/ luôn sử dụng các version mới nhất cho các package, các dependencies nếu có thể.

Khi bạn phát hiện ra một lỗ hổng bảo mật trong ứng dụng của mình, hoặc là bạn sẽ có 3 lựa chọn : upgrade, tạo bản vá (Patch) hoặc không làm gì cả. Upgrade là an toàn nhất cho ứng dụng, nhưng thường thì nó sẽ gây ra nhiều phiền toán vì các method, thư viện thay đổi khiến chúng ta phải code lại, làm mất thời gian nghiên cứu và code. Tạo bản vá (Patch) có lẽ sẽ khả thi hơn vì chúng ta sẽ chỉ phải vá lại chỗ nào bị lỗ hổng. Cuối cùng, việc bỏ qua không làm gì với các lỗ hổng, dĩ nhiên cũng là một sự lựa chọn vì nó không làm ứng dụng của chúng ta shutdown ngay, tuy nhiên một ngày đẹp trời nào đấy bạn sẽ không muốn bị khách hàng gọi điện liên tục và chửi bới này nọ đâu. :grin:

# Chưởng 4: Ngăn chặn CSRF
[Cross-Site Request Forgery (CSRF)](https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)) là một hình thức tấn công website phổ biến hiện nay. Spring Security đã support ngăn chặn `CSRF` một cách mặc định.
Nếu bạn sử dụng Spring MVC và dùng tag `form:form` hoặc `Thymeleaf` và sử dụng annotation `@EnableWebSecurity` thì  `CSRF token` sẽ tự động được thêm vào các `input field` ẩn.
Nếu bạn sử dụng Javascript framework như Angular hay React thì bạn cần cấu hình `CookieCsrfTokenRepository` để JavaScript có thể đọc token trong cookie.
```java
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .csrf()
                .csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse());
    }
}
```
Nếu bạn dùng Angular, đoạn code trên là đủ rồi. Còn nếu bạn dùng React, bạn cần lấy `XSRF-TOKEN` cookie và gửi kèm nó trong header. Mình sẽ viết một bài viết về cách build một Spring Boot app tích hợp React sau, còn nếu muốn bạn có thể tham khảo thêm tại [đây](https://developer.okta.com/blog/2018/07/19/simple-crud-react-and-spring-boot#modify-react-to-handle-csrf-and-be-identity-aware).

Spring Security sẽ tự động thêm `secure flag` vào `XSRF cookie` khi có bất kì request nào đến thông qua giao thức HTTPS. Spring Security không sử dụng flag `SameSite=strict` cho CSRF cookies, nhưng nó sẽ được dùng khi sử dụng Spring Session hoặc WebFlux session handling.

# Chưởng 5: Sử dụng Content Security Policy để ngăn chặn tấn công XSS
[Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) (CSP) là một lớp bảo mật giúp giảm thiểu tấn công [XSS(cross-site cripting)](https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)) và tấn công `data injection`. Để kích hoạt chế độ này, bạn cần cấu hình app để trả về `Content-Security-Policy` header. Bạn cũng có thể dùng thẻ tag `meta http-equiv="Content-Security-Policty">` trong trang HTML.

Spring security cung cấp một số [thuộc tính bảo mật mặc định](https://docs.spring.io/spring-security/site/docs/current/reference/html/web-app-security.html#default-security-headers) trong header:
```
Cache-Control: no-cache, no-store, max-age=0, must-revalidate
Pragma: no-cache
Expires: 0
X-Content-Type-Options: nosniff
Strict-Transport-Security: max-age=31536000 ; includeSubDomains
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```
Spring Security không kích hoạt CSP một cách mặc định. Muốn kích hoạt CSP header, bạn cấu hình ứng dụng như sau:
```java
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.headers()
            .contentSecurityPolicy("script-src 'self' https://trustedscripts.example.com; object-src https://trustedplugins.example.com; report-uri /csp-report-endpoint/");
    }
}
```
Bạn có thể kiểm tra `CSP header` trên ứng dụng của bạn tại [đây](https://securityheaders.com/).

# Chưởng 6: Sử dụng OpenID Connect cho Authentication
OpenID Connect (OIDC) là một OAuth 2.0 extension với mục đích cung cấp thông tin người dùng cho app của mình.
Dưới đây là diagram về cách OIDC xác thực:
![](https://developer.okta.com/assets/blog/spring-boot-10-ways-to-secure/oidc-for-authentication-2d91f30a19fbb9f9bced6dbbd44b76aa599fcc2c52233f61981399863bb04228.png)
Để tìm hiểu thêm về cách sử dụng OIDC trong ứng dụng Spring Boot, bạn có thể xem thêm [bài viết này](https://developer.okta.com/blog/2017/12/18/spring-security-5-oidc).
# Chưởng 7: Sử dụng Password Hashing để quản lý Password
Việc lưu trữ mật khẩu nhạy cảm dưới dạng `plain text` là một trong những việc làm tệ nhất mà bạn dành cho ứng dụng yêu quý của mình. May mắn cho bạn là Spring Security có một [cryto module](https://docs.spring.io/spring-security/site/docs/current/reference/html/servlet-webclient.html#crypto) giúp bạn mã hoá mật khẩu.
`PasswordEncoder` là interface khai báo các method cho việc mã hoá mật khẩu:
```
public interface PasswordEncoder {
    String encode(String rawPassword);
    boolean matches(String rawPassword, String encodedPassword);
}
```
Có một vài implementations cho việc mã hoá này, phổ biến nhất là `BCryptPasswordEncoder` và `Pbkdf2PasswordEncoder`.

# Chưởng 8: Lưu trữ các thông tin nhạy cảm một cách bảo mật
Các thông tin nhạy cảm như mật khẩu, token,... cần được xử lý cẩn thận để tránh bị lộ. Bạn không thể lưu chúng dưới dạng `plain text` hoặc bất kì một dạng có thể đoán được nếu giữ chúng ở ổ cứng cá nhân. Chúng ta thường không đủ cẩn thận khi lưu trữ các thông tin nhạy cảm. Dĩ nhiên bạn có thể mã hoá chúng giống như mã hoá mật khẩu. Nhưng khi mật khẩu an toàn, bạn lại có thêm một cái khác cần lưu trữ, đó chính là chìa khoá để giải mã. _(Thực tế thì chúng ta thường dùng các hàm hash một chiều để mã hoá mật khẩu, tức là không thể dịch ngược lại một khi đã mã hoá. Nhưng trong trường hợp này là các tài liệu nhạy cảm cần đọc được chứ không chỉ đơn giản là để so sánh)_.

[Spring Vault](http://projects.spring.io/spring-vault/) được coi là một giải pháp an toàn giúp chúng ta lưu trữ các thông tin nhạy cảm, cung cấp cách truy cập và cả tự động tạo thông tin đăng nhập cho chúng ta sử dụng.

# Chưởng 9: Kiểm tra ứng dụng với OWASP ZAP
Công cụ bảo mật [OWASP ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) là một proxy thực hiện việc kiểm tra bằng cách cố gắng xâm nhập ứng dụng tại lúc runtime. Hai phương pháp `OWASP ZAP` sử dụng để tìm kiếm các lỗ hổng là `Spider` và `Active Scan`.

Công cụ `Spider` sẽ bắt đầu bằng một chuỗi các URL, nó sẽ truy cập và phân tích cú pháp thông qua các response, xác định các hyperlink và thêm chúng vào một danh sách. Sau đó nó sẽ cố gắng tạo ra một bản đồ URLs dành riêng cho ứng dụng của bạn.

Công cụ `Active Scan` sẽ tự động kiểm tra và cung cấp cho bạn một báo cáo về những nơi ứng dụng của bạn có thể bị khai thác cũng như chi tiết về các lỗ hổng.

# Chưởng 10: Thành lập một team bảo mật để review code.
Code review là việc làm cần thiết cho bất kì một team phát triển dự án nào. Nếu bạn phải làm việc với những thông tin nhạy cảm, bạn nên xây dựng một team gồm các chuyên gia bảo mật để phân tích và báo cáo các lỗ hổng tiềm năng trong hệ thống. Nhưng nếu công ty hoặc khách hàng của bạn không có budget cho việc đó thì bạn cứ làm hết khả năng của mình là được. :stuck_out_tongue_closed_eyes:

Tải [Cheat sheet](https://res.cloudinary.com/snyk/image/upload/v1534422834/blog/Spring_Boot_Security_Cheat_Sheet.pdf)

Via: https://developer.okta.com/blog/2018/07/30/10-ways-to-secure-spring-boot
