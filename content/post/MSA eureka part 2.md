---
title: "[Microservice] Dựng Microservice web bằng Spring Boot và Eureka [Phần 2]"
slug: microservice-springboot-eureka-part2
date: 2018-12-19
categories:
- Microservice
- Spring Boot
tags:
- web architecture
- spring boot
- eureka
- zuul
- microservice
- jwt
keywords:
- web architecture
- spring boot
- eureka
- zuul
- microservice
- tutorial
- intelij
- jwt
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1545140745/1_aVq0q9jjFx1R8DMVhKKFWQ.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Ở [bài viết](https://tubean.github.io/2018/12/microservice-springboot-eureka/)  trước, chúng ta đã dựng được một hệ thống microservice đơn giản với 2 microservice, 1 cổng gateway và 1 naming server. Trong bài viết này, chúng ta sẽ tìm hiểu cách xác thực đối với hệ thống microservice bằng JWT.

# 1. Authentication Workflow
Chúng ta sẽ xem xét những bước xác thực diễn ra như thế nào trong một hệ thống bình thường:

1. Người dùng gửi một request để lấy một token thông qua một hệ thống đăng nhập.
2. Server sẽ xác định danh tính của người dùng và gửi trả về một token.
3. Với mỗi request sau đó, người dùng sẽ cung cấp token nhận được để server xác nhận.

Chúng ta sẽ sử dụng một service mới là  `auth service` để xác nhận danh tính của user và cung cấp token. Vậy còn xác nhận token thì ai đảm nhận? Thực ra chúng ta có thể triển khai việc này trong auth service và cổng gateway của chúng ta sẽ gọi đến service này để xác nhận token trước khi cho phép request gọi đến bất kỳ service nào. Tuy nhiên trong bài viết này, chúng ta sẽ thực hiện việc xác nhận token ở tầng gateway luôn, và nhiệm vụ của auth service chỉ là xác nhận danh tính user sau đó cung cấp một token tương ứng. Dù sử dụng cách nào thì việc chúng ta làm đều có mục đích là chặn các request chưa được xác thực gọi đến các service.

# 2. JSON Based Token (JWT)
Một token là một chuỗi String được mã hóa, được gen từ ứng dụng của chúng ta (sau khi xác thực thành công) và được gửi bởi người dùng trong mỗi request để cung cấp quyền truy cập vào các tài nguyên cho phép của ứng dụng. JSON Based Token (JWT) là một chuẩn JSON để tạo token. Nó bao gồm ba phần: header, payload và chữ ký (signature).

Phần header sẽ chứa thuật toán hash:
```
{type: “JWT”, hash: “HS256”}
```
Phần payload sẽ chứa các thuộc tính (username, email, ...) và giá trị của nó:
```
{username: "Omar", email: "omar@example.com", admin: true }
```
Phần chữ ký là giá trị hash của `Header + “.” + Payload + Secret key`.

# 3. Gateway
Ở trong gateway, chúng ta sẽ cần thêm hai phần: một là xác nhận token cho mỗi request và hai là chặn tất cả các request không được xác thực.

Trong file `pom.xml` chúng ta sẽ thêm 2 dependency của spring security và JWT:
```xml
<dependency>  
  <groupId>org.springframework.boot</groupId>  
  <artifactId>spring-boot-starter-security</artifactId>  
</dependency>

<dependency>  
  <groupId>io.jsonwebtoken</groupId>  
  <artifactId>jjwt</artifactId>  
  <version>0.9.0</version>  
</dependency>
```
Trong file `application.properties` chúng ta khai báo đường dẫn path đến auth service (sẽ tạo sau):
```
# Map path to auth service

zuul.routes.auth-service.path=/auth/**

zuul.routes.auth-service.service-id=AUTH-SERVICE

# By default, all requests to gallery service for example will start with: "/gallery/"

# What will be sent to the gallery service is what comes after the path defined,

# So, if request is "/gallery/view/1", gallery service will get "/view/1".

# In case of auth, we need to pass the "/auth/" in the path to auth service. So, set strip-prefix to false

zuul.routes.auth-service.strip-prefix=false

# Exclude authorization from sensitive headers

zuul.routes.auth-service.sensitive-headers=Cookie,Set-Cookie
```
Để khai báo cấu hình bảo mật thì chúng ta cần tạo một lớp được extend từ `WebSecurityConfigurerAdapter` và dùng annotation `@EnableWebSecurity` cho nó:
```java
package io.github.tubean.eureka.zuulserver.security;  

import javax.servlet.http.HttpServletResponse;  

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.context.annotation.Bean;  
import org.springframework.http.HttpMethod;  
import org.springframework.security.config.annotation.web.builders.HttpSecurity;  
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;  
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;  
import org.springframework.security.config.http.SessionCreationPolicy;  
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;  

@EnableWebSecurity     // Enable security config. This annotation denotes config for spring security.  
public class SecurityTokenConfig extends WebSecurityConfigurerAdapter {  
   @Autowired  
  private JwtConfig jwtConfig;  

   @Override  
  protected void configure(HttpSecurity http) throws Exception {  
          http  
      .csrf().disable()  
          // make sure we use stateless session; session won't be used to store user's state.  
  .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)      
      .and()  
          // handle an authorized attempts   
 .exceptionHandling().authenticationEntryPoint((req, rsp, e) -> rsp.sendError(HttpServletResponse.SC_UNAUTHORIZED))       
      .and()  
         // Add a filter to validate the tokens with every request  
  .addFilterAfter(new JwtTokenAuthenticationFilter(jwtConfig), UsernamePasswordAuthenticationFilter.class)  
      // authorization requests config  
  .authorizeRequests()  
         // allow all who are accessing "auth" service  
  .antMatchers(HttpMethod.POST, jwtConfig.getUri()).permitAll()    
         // must be an admin if trying to access admin area (authentication is also required here)  
  .antMatchers("/gallery" + "/admin/**").hasRole("ADMIN")  
         // Any other request must be authenticated  
  .anyRequest().authenticated();   
   }  

   @Bean  
  public JwtConfig jwtConfig() {  
          return new JwtConfig();  
   }  
}
```
Trong class `JwtConfig` chúng ta khai báo các biến để cấu hình JWT:
```java
package io.github.tubean.eureka.zuulserver.security;  

import org.springframework.beans.factory.annotation.Value;  

public class JwtConfig {  
    @Value("${security.jwt.uri:/auth/**}")  
    private String Uri;  

    @Value("${security.jwt.header:Authorization}")  
    private String header;  

    @Value("${security.jwt.prefix:Bearer }")  
    private String prefix;  

    @Value("${security.jwt.expiration:#{24*60*60}}")  
    private int expiration;  

    @Value("${security.jwt.secret:JwtSecretKey}")  
    private String secret;  

    public String getUri() {  
        return Uri;  
    }  

    public void setUri(String uri) {  
        Uri = uri;  
    }  

    public String getHeader() {  
        return header;  
    }  

    public void setHeader(String header) {  
        this.header = header;  
    }  

    public String getPrefix() {  
        return prefix;  
    }  

    public void setPrefix(String prefix) {  
        this.prefix = prefix;  
    }  

    public int getExpiration() {  
        return expiration;  
    }  

    public void setExpiration(int expiration) {  
        this.expiration = expiration;  
    }  

    public String getSecret() {  
        return secret;  
    }  

    public void setSecret(String secret) {  
        this.secret = secret;  
    }  
}
```
Spring có các lớp filter cho phép thực thi trong life-cycle của một request. Để khởi động và sử dụng các filter này, chúng ta cần extend chúng. Ở chế độ mặc định thì spring sẽ định nghĩa riêng cho mỗi filter lúc nào thì nên sử dụng. Tuy nhiên thì bạn có thể sửa lại thứ tự một filter sẽ hoạt động trước hoặc sau filter nào.

Công việc tiếp theo là chúng ta cần triển khai một filter dùng để xác nhận token. Filter `OncePerRequestFilter` là một filter được kích hoạt cho mỗi một lần request đến nên chúng ta sẽ dùng nó để tạo một filter của chúng ta:
```java
package io.github.tubean.eureka.zuulserver.security;  

import java.io.IOException;  
import java.util.List;  
import java.util.stream.Collectors;  

import javax.servlet.FilterChain;  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;  
import org.springframework.security.core.authority.SimpleGrantedAuthority;  
import org.springframework.security.core.context.SecurityContextHolder;  
import org.springframework.web.filter.OncePerRequestFilter;  

import io.jsonwebtoken.Claims;  
import io.jsonwebtoken.Jwts;  

public class JwtTokenAuthenticationFilter extends OncePerRequestFilter {  

   private final JwtConfig jwtConfig;  

   public JwtTokenAuthenticationFilter(JwtConfig jwtConfig) {  
      this.jwtConfig = jwtConfig;  
   }  

   @Override  
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)  
         throws ServletException, IOException {  

      // 1. get the authentication header. Tokens are supposed to be passed in the authentication header  
  String header = request.getHeader(jwtConfig.getHeader());  

      // 2. validate the header and check the prefix  
  if(header == null || !header.startsWith(jwtConfig.getPrefix())) {  
         chain.doFilter(request, response);        // If not valid, go to the next filter.  
  return;  
      }  

      // If there is no token provided and hence the user won't be authenticated.   
      // It's Ok. Maybe the user accessing a public path or asking for a token.  
       // All secured paths that needs a token are already defined and secured in config class.  
 // And If user tried to access without access token, then he won't be authenticated and an exception will be thrown.       // 3. Get the token  
  String token = header.replace(jwtConfig.getPrefix(), "");  

      try {  // exceptions might be thrown in creating the claims if for example the token is expired  
          // 4. Validate the token  
  Claims claims = Jwts.parser()  
               .setSigningKey(jwtConfig.getSecret().getBytes())  
               .parseClaimsJws(token)  
               .getBody();  

         String username = claims.getSubject();  
         if(username != null) {  
            @SuppressWarnings("unchecked")  
            List<String> authorities = (List<String>) claims.get("authorities");  

            // 5. Create auth object  
 // UsernamePasswordAuthenticationToken: A built-in object, used by spring to represent the current authenticated / being authenticated user. // It needs a list of authorities, which has type of GrantedAuthority interface, where SimpleGrantedAuthority is an implementation of that interface  UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(  
                         username, null, authorities.stream().map(SimpleGrantedAuthority::new).collect(Collectors.toList()));  

             // 6. Authenticate the user  
 // Now, user is authenticated  SecurityContextHolder.getContext().setAuthentication(auth);  
         }  

      } catch (Exception e) {  
         // In case of failure. Make sure it's clear; so guarantee user won't be authenticated  
  SecurityContextHolder.clearContext();  
      }  

      // go to the next filter in the filter chain  
  chain.doFilter(request, response);  
   }  

}
```

# 4. Auth service
Trong auth service, chúng ta sẽ làm hai việc: một là xác thực định danh mà người dùng cung cấp và hai là gen ra một token trong trường hợp xác thực hợp lệ hoặc trả về một exception nếu nó không hợp lệ.

Trong file `pom.xml` chúng ta cần các dependencies sau: Web, Eureka Client, Spring Security và JWT.
```
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-web</artifactId>  
</dependency>  
<dependency>  
    <groupId>org.springframework.cloud</groupId>  
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>  
</dependency>  
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-security</artifactId>  
</dependency>  
<dependency>  
    <groupId>io.jsonwebtoken</groupId>  
    <artifactId>jjwt</artifactId>  
    <version>0.9.0</version>  
</dependency>
```
File `application.properties` khai báo như các service khác:
```
spring.application.name=auth-service

server.port=9100

eureka.client.service-url.default-zone=http://localhost:8761/eureka
```
Giống như cấu hình cổng Gateway, chúng ta cần tạo một lớp extends từ `WebSecurityConfigurerAdapter` và đánh anotation `@EnableWebSecurity` cho nó:
```java
package io.github.tubean.authservice.security;  

import javax.servlet.http.HttpServletResponse;  

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.context.annotation.Bean;  
import org.springframework.http.HttpMethod;  
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;  
import org.springframework.security.config.annotation.web.builders.HttpSecurity;  
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;  
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;  
import org.springframework.security.config.http.SessionCreationPolicy;  
import org.springframework.security.core.userdetails.UserDetailsService;  
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;  

@EnableWebSecurity // Enable security config. This annotation denotes config for spring security.  
public class SecurityCredentialsConfig extends WebSecurityConfigurerAdapter {  

   @Autowired  
  private UserDetailsService userDetailsService;  

   @Autowired  
  private JwtConfig jwtConfig;  

   @Override  
  protected void configure(HttpSecurity http) throws Exception {  
      http  
          .csrf().disable()  
           // make sure we use stateless session; session won't be used to store user's state.  
  .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)  
           .and()  
               // handle an authorized attempts   
 .exceptionHandling().authenticationEntryPoint((req, rsp, e) -> rsp.sendError(HttpServletResponse.SC_UNAUTHORIZED))  
           .and()  
          // Add a filter to validate user credentials and add token in the response header  
           // What's the authenticationManager()?   
          // An object provided by WebSecurityConfigurerAdapter, used to authenticate the user passing user's credentials  
 // The filter needs this auth manager to authenticate the user.  .addFilter(new JwtUsernameAndPasswordAuthenticationFilter(authenticationManager(), jwtConfig))   
      .authorizeRequests()  
          // allow all POST requests   
 .antMatchers(HttpMethod.POST, jwtConfig.getUri()).permitAll()  
          // any other requests must be authenticated  
  .anyRequest().authenticated();  
   }  

   // Spring has UserDetailsService interface, which can be overriden to provide our implementation for fetching user from database (or any other source).  
 // The UserDetailsService object is used by the auth manager to load the user from database. // In addition, we need to define the password encoder also. So, auth manager can compare and verify passwords.  @Override  
  protected void configure(AuthenticationManagerBuilder auth) throws Exception {  
      auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());  
   }  

   @Bean  
  public JwtConfig jwtConfig() {  
           return new JwtConfig();  
   }  

   @Bean  
  public BCryptPasswordEncoder passwordEncoder() {  
       return new BCryptPasswordEncoder();  
   }  
}
```
Trong đoạn code trên, chúng ta sử dụng interface `UserDetailsService` nên chúng ta cần implement nó:
```java
package io.github.tubean.authservice.security;  

import java.util.Arrays;  
import java.util.List;  

import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.security.core.GrantedAuthority;  
import org.springframework.security.core.authority.AuthorityUtils;  
import org.springframework.security.core.userdetails.User;  
import org.springframework.security.core.userdetails.UserDetails;  
import org.springframework.security.core.userdetails.UserDetailsService;  
import org.springframework.security.core.userdetails.UsernameNotFoundException;  
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;  
import org.springframework.stereotype.Service;  

@Service // It has to be annotated with @Service.  
public class UserDetailsServiceImpl implements UserDetailsService  {  

   @Autowired  
  private BCryptPasswordEncoder encoder;  

   @Override  
  public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {  

      // hard coding the users. All passwords must be encoded.  
  final List<AppUser> users = Arrays.asList(  
         new AppUser(1, "tubean", encoder.encode("12345"), "USER"),  
         new AppUser(2, "admin", encoder.encode("12345"), "ADMIN")  
      );  


      for(AppUser appUser: users) {  
         if(appUser.getUsername().equals(username)) {  

            // Remember that Spring needs roles to be in this format: "ROLE_" + userRole (i.e. "ROLE_ADMIN")  
 // So, we need to set it to that format, so we can verify and compare roles (i.e. hasRole("ADMIN")).  List<GrantedAuthority> grantedAuthorities = AuthorityUtils  
                         .commaSeparatedStringToAuthorityList("ROLE_" + appUser.getRole());  

            // The "User" class is provided by Spring and represents a model class for user to be returned by UserDetailsService  
 // And used by auth manager to verify and check user authentication.  return new User(appUser.getUsername(), appUser.getPassword(), grantedAuthorities);  
         }  
      }  

      // If user not found. Throw this exception.  
  throw new UsernameNotFoundException("Username: " + username + " not found");  
   }  

   // A (temporary) class represent the user saved in the database.  
  private static class AppUser {  
      private Integer id;  
          private String username, password;  
          private String role;  

      public AppUser(Integer id, String username, String password, String role) {  
             this.id = id;  
             this.username = username;  
             this.password = password;  
             this.role = role;  
          }  

      public Integer getId() {  
         return id;  
      }  

      public void setId(Integer id) {  
         this.id = id;  
      }  

      public String getUsername() {  
         return username;  
      }  

      public void setUsername(String username) {  
         this.username = username;  
      }  

      public String getPassword() {  
         return password;  
      }  

      public void setPassword(String password) {  
         this.password = password;  
      }  

      public String getRole() {  
         return role;  
      }  

      public void setRole(String role) {  
         this.role = role;  
      }  
   }  
}
```
Đây là class hoạt động như một nơi cung cấp cho người dùng, nghĩa là nó tải các thông tin chi tiết của người dùng từ database lên và sử dụng chúng.

Bước tiếp theo cũng là bước cuối cùng, chúng ta cần một filter. Ở đây chúng ta sử dụng `JwtUsernameAndPasswordAuthenticationFilter` để xác thực định danh người dùng và tạo token. Các thông tin về username hay password phải được gửi dưới dạng POST request.
```java
package io.github.tubean.authservice.security;  

import java.io.IOException;  
import java.sql.Date;  
import java.util.Collections;  
import java.util.stream.Collectors;  

import javax.servlet.FilterChain;  
import javax.servlet.ServletException;  
import javax.servlet.http.HttpServletRequest;  
import javax.servlet.http.HttpServletResponse;  

import org.springframework.security.authentication.AuthenticationManager;  
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;  
import org.springframework.security.core.Authentication;  
import org.springframework.security.core.AuthenticationException;  
import org.springframework.security.core.GrantedAuthority;  
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;  
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;  

import com.fasterxml.jackson.databind.ObjectMapper;  

import io.jsonwebtoken.Jwts;  
import io.jsonwebtoken.SignatureAlgorithm;  

public class JwtUsernameAndPasswordAuthenticationFilter extends UsernamePasswordAuthenticationFilter   {  

   // We use auth manager to validate the user credentials  
  private AuthenticationManager authManager;  

   private final JwtConfig jwtConfig;  

   public JwtUsernameAndPasswordAuthenticationFilter(AuthenticationManager authManager, JwtConfig jwtConfig) {  
      this.authManager = authManager;  
      this.jwtConfig = jwtConfig;  

      // By default, UsernamePasswordAuthenticationFilter listens to "/login" path.   
      // In our case, we use "/auth". So, we need to override the defaults.  
  this.setRequiresAuthenticationRequestMatcher(new AntPathRequestMatcher(jwtConfig.getUri(), "POST"));  
   }  

   @Override  
  public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)  
         throws AuthenticationException {  

      try {  

         // 1. Get credentials from request  
  UserCredentials creds = new ObjectMapper().readValue(request.getInputStream(), UserCredentials.class);  

         // 2. Create auth object (contains credentials) which will be used by auth manager  
  UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(  
               creds.getUsername(), creds.getPassword(), Collections.emptyList());  

         // 3. Authentication manager authenticate the user, and use UserDetialsServiceImpl::loadUserByUsername() method to load the user.  
  return authManager.authenticate(authToken);  

      } catch (IOException e) {  
         throw new RuntimeException(e);  
      }  
   }  

   // Upon successful authentication, generate a token.  
 // The 'auth' passed to successfulAuthentication() is the current authenticated user.  @Override  
  protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain,  
         Authentication auth) throws IOException, ServletException {  

      Long now = System.currentTimeMillis();  
      String token = Jwts.builder()  
         .setSubject(auth.getName())      
         // Convert to list of strings.   
         // This is important because it affects the way we get them back in the Gateway.  
  .claim("authorities", auth.getAuthorities().stream()  
            .map(GrantedAuthority::getAuthority).collect(Collectors.toList()))  
         .setIssuedAt(new Date(now))  
         .setExpiration(new Date(now + jwtConfig.getExpiration() * 1000))  // in milliseconds  
  .signWith(SignatureAlgorithm.HS512, jwtConfig.getSecret().getBytes())  
         .compact();  

      // Add token to header  
  response.addHeader(jwtConfig.getHeader(), jwtConfig.getPrefix() + token);  
   }  

   // A (temporary) class just to represent the user credentials  
  private static class UserCredentials {  
       private String username, password;  

      public String getUsername() {  
         return username;  
      }  

      public void setUsername(String username) {  
         this.username = username;  
      }  

      public String getPassword() {  
         return password;  
      }  

      public void setPassword(String password) {  
         this.password = password;  
      }  
   }  
}
```

> Đừng quên class JwtConfig như bên Gateway!

# 5. Testing
Chúng ta sẽ chạy lần lượt Eureka Server, các service image, gallery, auth và gateway.

Đầu tiên chúng ta thử truy cập vào gallery service thông qua đường dẫn `localhost:8762/gallery` mà không có token. Chúng ta sẽ nhận về một lỗi 401 như sau:
```
{
    "timestamp": "2018-12-19T16:26:08.131+0000",
    "status": 401,
    "error": "Unauthorized",
    "message": "No message available",
    "path": "/gallery"
}
```
Để nhận token, chúng ta gửi định danh của chúng ta đến địa chỉ `localhost:8762/auth` như sau:
![imag1](https://res.cloudinary.com/deop9ytsv/image/upload/v1545237441/msa_jwt_img1.jpg)

Bây giờ gọi lại đến gallery service kèm theo một token trong header:
![img_2](https://res.cloudinary.com/deop9ytsv/image/upload/v1545237474/Screenshot_2.jpg)
Ngoài ta thì bạn có thể thử chạy nhiều instance của gallery service để test xem các request được phân tán như thế nào. Trong phần tiếp theo, chúng ta sẽ tìm hiểu các xử lý lỗi và theo dõi trong mô hình microservice.


# Nguồn bài viết
https://medium.com/omarelgabrys-blog/microservices-with-spring-boot-authentication-with-jwt-part-3-fafc9d7187e8

> Trong bài viết gốc, tác giả có ử dụng thêm service config để chứa nhận phần resources chung của các microservice nhằm mục đích tránh bị trùng lặp. Ví dụ trong hệ thống của chúng ta có sử dụng class JwtConfig ở cả Gateway và auth service. Tuy nhiên do chưa thử thành công nên tôi không đưa nó vào bài viết. Nếu bạn nào đọc mà hiểu thì vui lòng comment phía dưới để tôi thêm vào bài viết. Xin cảm ơn.

# Source code
https://github.com/tubean/MSA-springboot-eureka

Check out branch `part2_authen_with_jwt`.
