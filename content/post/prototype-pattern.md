---
title: "[Design Pattern] Prototype Design Pattern"
slug: prototype-pattern
date: 2018-12-15
categories:
- design pattern
tags:
- design pattern
- prototype
keywords:
- design
- pattern
- java
- prototype
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543156961/design-pattern-logo.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Trong lập trình hướng đối tượng, khi chúng ta muốn tạo thêm một đối tượng thì thường sử dụng từ khóa `new`. Tuy nhiên đối với cách tạo đối tượng này thì những thuộc tính ban đầu sẽ thường là trống, trừ khi được khởi tạo giá trị default hoặc khởi tạo ngay trong contructor. Vậy nếu chúng ta muốn tạo mới một đối tượng từ một đối tượng cũ, mang tất cả thuộc tính và giá trị đang có của đối tượng cũ như một bản clone thì làm thế nào?

Thực ra chúng ta vẫn có thể dùng từ khóa `new`, sau đó gán các giá trị thuộc tính của đối tượng cũ sang đối tượng mới, nhưng như thế thì việc tạo đối tượng mới quá tốn kém và hiệu suất thấp.

# 1. Nêu vấn đề
Một ví dụ thực tế là app của chúng ta yêu cầu quyền truy cập đối với từng loại user. Ví dụ đối với chức năng in ra báo cáo, một số user sẽ có quyền truy cập và tạo ra báo cáo mới, một số khác chỉ có quyền đọc những báo cáo đã được in ra. Chúng ta không thể chia sẻ quyền truy cập vào class in ra báo cáo cho tất cả các user, vì có thể trong lúc chạy runtime, admin có thể cấp quyền cho một số user cùng level được phép truy cập, còn các user khác mặc dù cùng level nhưng chưa được cấp quyền tạo mới thì vẫn chỉ được phép đọc báo cáo. Lúc này, mỗi một user sẽ chỉ nên có một quyền truy cập riêng tương ứng.

Và đó là lý do mà Prototype xuất hiện như một mẫu thiết kế dành riêng cho việc clone object. Chúng ta sẽ tạo một đối tượng liên quan đến quyền truy cập cho tất cả user cùng level tại một thời điểm, sau đó khi cần cấp thêm quyền thì sẽ cung cấp một cách clone từ quyền truy cập của một đối tượng có level cao hơn.

# 2. Prototype Pattern là gì?
`Prototype pattern` được sử dụng để tạo ra một khuôn mẫu instance và có thể tạo nhiều instance mới từ khuôn mẫu này. Trong Java, chúng ta có vài cách để tạo ra mới đối tượng. Một trong số đó là sử dụng interface `Cloneable`. Java cung cấp phương thức `clone()` là một phương thức trừu tượng trong lớp `Object`. Bạn cần implement interface `Cloneable` và override phương thức `clone` theo cách bạn muốn.
![img1](https://res.cloudinary.com/deop9ytsv/image/upload/v1544934985/pro_1.jpg)
Trong UML trên thì:

- `Prototype`: Khai báo interface có phương thức clone.
- `ConcretePrototype`: Implement một opretation dành cho việc clone.
- `Clinet`: Tạo mới một object bằng cách dùng một loại khuôn mẫu để clone.

# 3. Giải pháp
Chúng ta cùng xem giải pháp cho vấn đề ban đầu:

- Tạo interface dành cho việc clone, extend từ interface `Cloneable`:

```java
public interface Prototype extends Cloneable {  

    public AccessControl clone() throws CloneNotSupportedException;  

}
```
- Tạo class implement interface trên:

```java
public class AccessControl implements Prototype {  
    private final String controlLevel;  
    private String access;  

    public AccessControl(String controlLevel, String access) {  
        this.controlLevel = controlLevel;  
        this.access = access;  
    }  

    @Override  
  public AccessControl clone() {  
        try {  
            return (AccessControl) super.clone();  
        } catch (CloneNotSupportedException e) {  
            e.printStackTrace();  
        }  
        return null;  
    }  

    public String getControlLevel() {  
        return controlLevel;  
    }  

    public String getAccess() {  
        return access;  
    }  

    public void setAccess(String access) {  
        this.access = access;  
    }  
}
```
Lớp `AccessControl` trên implemet interface `Prototype` và override phương thức `clone`. Phương thức này sẽ gọi đến `super.clone()`, tức là phương thức `clone` của lớp `Object`. (__Mọi class đều là class con của Object__).
Trong lớp `AccessControl` cũng bao gồm 2 properties là `controlLevel` được sử dụng để định nghĩa level truy cập của đối tượng chứa nó, level này phụ thuộc vào user sẽ dùng nó, ví dụ USER, ADMIN, MANAGER,.. Property còn lại là `access`, chứa cách truy cập cho từng user. Để đơn giản, chúng ta sử dụng String cho property này. Trong thực tế thì nó nên được sử dụng Map để chứa các cặp key-value cách truy cập cho từng loại user.

- Tạo class User có property `level` và tham chiếu của `AccessControl`.

```java
public class User {  
    private String userName;  
    private String level;  
    private AccessControl accessControl;  

    public User(String userName, String level, AccessControl accessControl) {  
        this.userName = userName;  
        this.level = level;  
        this.accessControl = accessControl;  
    }  

    public String getUserName() {  
        return userName;  
    }  

    public void setUserName(String userName) {  
        this.userName = userName;  
    }  

    public String getLevel() {  
        return level;  
    }  

    public void setLevel(String level) {  
        this.level = level;  
    }  

    public AccessControl getAccessControl() {  
        return accessControl;  
    }  

    public void setAccessControl(AccessControl accessControl) {  
        this.accessControl = accessControl;  
    }  

    @Override  
  public String toString() {  
        return "Name: " + userName + ", Level: " + level + ", Access Control Level:" + accessControl.getControlLevel() + ", Access: " + accessControl.getAccess();  
    }  
}
```
- Tạo class `AccessControlProvider` để tạo và lưu trữ các instance `AccessControl` trong điều kiện nó được cấp quyền thêm.

```java
public class AccessControlProvider {  
    private static Map<String, AccessControl> map = new HashMap<String, AccessControl>();  

    static {  

        System.out.println("Fetching data from external resources and creating access control objects...");  
        map.put("USER", new AccessControl("USER", "DO_WORK"));  
        map.put("ADMIN", new AccessControl("ADMIN", "ADD/REMOVE USERS"));  
        map.put("MANAGER", new AccessControl("MANAGER", "GENERATE/READ REPORTS"));  
        map.put("VP", new AccessControl("VP", "MODIFY REPORTS"));  
    }  

    public static AccessControl getAccessControlObject(String controlLevel) {  
        AccessControl ac = null;  
        ac = map.get(controlLevel);  
        if (ac != null) {  
            return ac.clone();  
        }  
        return null;  
    }  
}
```
- Cuối cùng là test kết quả:

```java
public class TestPrototypePattern {  
    public static void main(String[] args) {  
        AccessControl userAccessControl = AccessControlProvider.getAccessControlObject("USER");  
        User user = new User("User A", "USER Level", userAccessControl);  

        System.out.println("************************************");  
        System.out.println(user);  

        userAccessControl = AccessControlProvider.getAccessControlObject("USER");  
        user = new User("User B", "USER Level", userAccessControl);  
        System.out.println("Changing access control of: " + user.getUserName());  
        user.getAccessControl().setAccess("READ REPORTS");  
        System.out.println(user);  

        System.out.println("************************************");  

        AccessControl managerAccessControl = AccessControlProvider.getAccessControlObject("MANAGER");  
        user = new User("User C", "MANAGER Level", managerAccessControl);  
        System.out.println(user);  
    }  
}
```
Trong đoạn test thì chúng ta tạo một đối tượng `AccessControl` có level là User và được gán cho đối tượng A, có quyền truy cập là `DO_WORK`. Sau đó có hai đối tượng B nhưng chúng ta cần đổi quyền truy cập là `READ REPORT` cho B.
Kết quả của đoạn test trên:

```
Fetching data from external resources and creating access control objects...
************************************
Name: User A, Level: USER Level, Access Control Level:USER, Access: DO_WORK
Changing access control of: User B
Name: User B, Level: USER Level, Access Control Level:USER, Access: READ REPORTS
************************************
Name: User C, Level: MANAGER Level, Access Control Level:MANAGER, Access: GENERATE/READ REPORTS
```

# 4. Khi nào dùng
Chúng ta dùng `Prototype pattern` khi :

- muốn tạo đối tượng run-time
- chúng ta muốn truyền đối tượng vào một hàm nào đó để xử lý thì thay vì truyền đối tượng gốc dễ bị ảnh hưởng dữ liệu thì chúng ta truyền một clone của nó.
- khi chi phí để tạo đối tượng mới bằng từ khóa `new` là quá lớn.

# 5. Source code
https://github.com/tubean/design-pattern/
