
---
title: "[Design Patterns] Adapter Design Pattern"
slug: adapter-design-patterns
date: 2018-11-25
categories:
- Java
- Design Patterns
tags:
- Java
- Design Pattern
- Adapter
keywords:
- java
- design
- pattern
- adapter
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543156961/design-pattern-logo.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Chuyện kể rằng bạn Bean là một developer và đang phát triển một website e-commerce. Trang web này cho phép người dùng mua và thanh toán online bằng cách dùng một cổng thanh toán của bên thứ 3. Mọi thứ đều nhẹ nhàng như cân đường hộp sữa, cho đến một ngày mưa gió bão bùng...
Vào cái ngày định mệnh ấy, PM của bạn Bean thông báo rằng sắp tới website sẽ thay đổi cổng thanh toán và bạn Bean sẽ phải chuẩn bị cho thay đổi này.
Để dễ hình dung thì giả sử hệ thống hiện tại đang sử dụng cổng thanh toán Xpay và yêu cầu người dùng nhập các thông tin như sau:
```java
public interface Xpay {  
    public String getCreditCardNo();  
    public String getCustomerName();  
    public String getCardExpMonth();  
    public String getCardExpYear();  
    public Short getCardCVVNo();  
    public Double getAmount();  

    public void setCreditCardNo(String creditCardNo);  
    public void setCustomerName(String customerName);  
    public void setCardExpMonth(String cardExpMonth);  
    public void setCardExpYear(String cardExpYear);  
    public void setCardCVVNo(Short cardCVVNo);  
    public void setAmount(Double amount);  
}
```
Tình trạng code hiện tại:
![image1](https://res.cloudinary.com/deop9ytsv/image/upload/v1543157770/Screenshot_3.jpg)

Và yêu cầu hiện tại là chuyển sang một cổng thanh toán PayD mới yêu cầu các thông số sau:

```java
public interface PayD {  
    public String getCustCardNo();  
    public String getCardOwnerName();  
    public String getCardExpMonthDate();  
    public Integer getCVVNo();  
    public Double getTotalAmount();  

    public void setCustCardNo(String custCardNo);  
    public void setCardOwnerName(String cardOwnerName);  
    public void setCardExpMonthDate(String cardExpMonthDate);  
    public void setCVVNo(Integer cVVNo);  
    public void setTotalAmount(Double totalAmount);  
}
```
Yêu cầu phát triển:
![image2](https://res.cloudinary.com/deop9ytsv/image/upload/v1543157900/adapter2.jpg)

# Cách giải quyết
Bởi vì code hiện tại đang chạy tốt trên production nên bạn Bean không thể nào thay đổi toàn bộ source code, refactor lại chỗ nào dùng Xpay thì viết lại thành PayD. Như vậy Bean sẽ một thứ gì đó để chuyển đổi linh hoạt từ Xpay sang PayD, giống như khi bạn có một dây sạc USB-type A mà điện thoại của bạn chỉ nhận cổng USB-type C thì bạn cần mua thêm một adapter để sử dụng. Tương tự trường hợp hiện tại, bạn Bean cũng cần một adapter giúp chuyển từ cổng Xpay sang PayD.

`Adapter design pattern` là mẫu thiết kế cho phép chúng ta điều chỉnh một đối tượng có sẵn sang một đối tượng mong muốn. Đó là mẫu thiết kế hướng về sự linh hoạt sử dụng các interface khác nhau cho cùng một mục đích nào đó mà không cần chỉnh sửa trực tiếp các interface mỗi khi có yêu cầu thay đổi.
Một adapter sẽ sử dụng đối tượng cần thay đổi (Xpay), sau đó dịch nó sang đối tượng mong muốn có (PayD).
![image3](https://res.cloudinary.com/deop9ytsv/image/upload/v1543159903/adapter3.jpg)

Như trong trường hợp của bạn Bean, chúng ta có thể viết một adapter như sau:

```java
public class XpayToPayDAdapter implements PayD {  
    private String custCardNo;  
    private String cardOwnerName;  
    private String cardExpMonthDate;  
    private Integer cVVNo;  
    private Double totalAmount;  

    private final Xpay xpay;  

    public XpayToPayDAdapter(Xpay xpay){  
        this.xpay = xpay;  
        setProp();  
    }  

    @Override  
  public String getCustCardNo() {  
        return custCardNo;  
    }  

    @Override  
  public String getCardOwnerName() {  
        return cardOwnerName;  
    }  

    @Override  
  public String getCardExpMonthDate() {  
        return cardExpMonthDate;  
    }  

    @Override  
  public Integer getCVVNo() {  
        return cVVNo;  
    }  

    @Override  
  public Double getTotalAmount() {  
        return totalAmount;  
    }  

    @Override  
  public void setCustCardNo(String custCardNo) {  
        this.custCardNo = custCardNo;  
    }  

    @Override  
  public void setCardOwnerName(String cardOwnerName) {  
        this.cardOwnerName = cardOwnerName;  
    }  

    @Override  
  public void setCardExpMonthDate(String cardExpMonthDate) {  
        this.cardExpMonthDate = cardExpMonthDate;  
    }  

    @Override  
  public void setCVVNo(Integer cVVNo) {  
        this.cVVNo = cVVNo;  
    }  

    @Override  
  public void setTotalAmount(Double totalAmount) {  
        this.totalAmount = totalAmount;  
    }  

    private void setProp(){  
        setCardOwnerName(this.xpay.getCustomerName());  
        setCustCardNo(this.xpay.getCreditCardNo());  
        setCardExpMonthDate(this.xpay.getCardExpMonth()+"/"+this.xpay.getCardExpYear());  
        setCVVNo(this.xpay.getCardCVVNo().intValue());  
        setTotalAmount(this.xpay.getAmount());  
    }
```
Adapter impleament theo PayD interface - loại object mong muốn. Và chúng ta thử xem cách sử dụng adapter:

```java
public class RunAdapterExample {  
    public static void main(String[] args) {  

        // Object for Xpay  
  Xpay xpay = new XpayImpl();  
        xpay.setCreditCardNo("4789565874102365");  
        xpay.setCustomerName("Tu Bean");  
        xpay.setCardExpMonth("01");  
        xpay.setCardExpYear("2020");  
        xpay.setCardCVVNo((short)123);  
        xpay.setAmount(2565.23);  

        PayD payD = new XpayToPayDAdapter(xpay);  
        testPayD(payD);  
    }  

    private static void testPayD(PayD payD){  

        System.out.println(payD.getCardOwnerName());  
        System.out.println(payD.getCustCardNo());  
        System.out.println(payD.getCardExpMonthDate());  
        System.out.println(payD.getCVVNo());  
        System.out.println(payD.getTotalAmount());  
    }  
}
```

Như vậy chúng ta có thể tạo ra một object kiểu PayD thông qua một contructor có tham số truyền vào là Xpay. Các method bên trong adapter cũng đã giúp chuyển đổi phương thức của Xpay sang các phương thức của PayD. Tuy nhiên thì do các method của 2 loại cổng thanh toán là khác nhau nên đôi khi sự chuyển đổi chỉ mang tính tương đối. Ví dụ như ở trên, cổng PayD chỉ có 1 thông số là `CardExpMonthDate`, còn Xpay thì có 2 thông số `CardExpMonth` và `CardExpYear`. Để tạo ra một cách chuyển đổi linh hoạt, chúng ta tạo ra một method chuyển đổi từ 2 thông số của Xpay sang PayD như sau:
```java
setCardExpMonthDate(this.xpay.getCardExpMonth()+"/"+this.xpay.getCardExpYear());
```
Giải pháp của chúng ta nhìn tổng quát lại như sau:

![image4](https://res.cloudinary.com/deop9ytsv/image/upload/v1543160681/adapter4.jpg)

# Class Adapter
Có 2 loại adapter là `object adapter` và `class adapter`.  Trong ví dụ trên chúng ta đã dùng loại `object adapter`, tức là loại adapter sử dụng các thành phần trong object cần chuyển đổi để tạo ra object mong muốn. Trong khi đó, `class adapter` sẽ dựa vào đa kế thừa để tạo ra một interface thích ứng với các class khác nhau. Tuy nhiên trong java chúng ta không có đa kế thừa như C++ nên loại này có thể không cần để ý.

# Khi nào sử dụng Adapter Pattern
Mẫu thiết kế này được sử dụng khi:

- Bạn đã có sẵn một class nhưng interface của nó thì lại khác phù hợp với cái bạn cần.
- Bạn muốn tạo một class có thể tái sử dụng với các lớp không liên quan hoặc không đoán trước được, các class này không nhất thiết phải có các interface phù hợp trước.

# Source code:
 https://github.com/tubean/design-pattern
