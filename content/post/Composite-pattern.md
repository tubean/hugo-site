﻿---
title: "[Design Pattern] Composite Design Pattern"
slug: composite-pattern
date: 2018-12-05
categories:
- design pattern
tags:
- design pattern
- composite
keywords:
- design
- pattern
- java
- composite
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1543156961/design-pattern-logo.jpg
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Trong bài viết này, chúng ta sẽ đi tìm hiểu về một mẫu thiết kế khá thú vị, đó là `Composite pattern`. Trong tiếng anh thì từ `composite` có nghĩa là làm một hỗn hợp, tức là một thứ gì đó được tạo từ rất nhiều thành phần hỗn tạp.
Đây là một mẫu thiết kế thuộc nhóm cấu trúc. Một đối tượng _composite_ được tạo thành từ một hay nhiều đối tượng tương tự nhau (hoặc có một số chức năng tương tự nhau). Ý tưởng là có thể thao tác trên một nhóm đối tượng theo cách thao tác trên một đối tượng duy nhất và các đối tượng của nhóm phải có các thao tác chung. (method chung).

Điều này tương tự như việc bạn có một cấu trúc dạng cây được tạo thành từ nhiều nhánh khác nhau, mỗi nhánh lại có thể được tạo từ nhiều nhánh khác, tất cả đều giống nhau về mặt cấu trúc và tạo nên một thứ hỗn độn. Trong thực tế thì chúng ta gặp nhiều bài toán cần dùng đến cấu trúc như vậy như hệ thống các thư mục, file, hệ thống các thẻ tag trong html, xml,...

# 1. Composite Pattern là gì?
Nếu bạn quen thuộc với cấu trúc dữ liệu dạng tree, bạn sẽ biết một tree sẽ có `parents` và `children`. Một parent có thể có nhiều `children`, nhưng một `chid` chỉ có một `parent`. Trong mẫu thiết kế Composite, những element có children được gọi là `Nodes`, những element không có children được gọi là `Leafs`.

Một mẫu thiết kế Composite sẽ có 4 thành phần:

- Component
- Leaf
- Composite
- Client

Hình dưới đây mô tả cấu trúc thường thấy của một đối Composite:
![image1](https://res.cloudinary.com/deop9ytsv/image/upload/v1544023400/composite-1.jpg)

# 2. Sơ đồ mẫu Composite UML

![img-2](https://res.cloudinary.com/deop9ytsv/image/upload/v1544023400/composite-2.jpg)
Trong biểu đồ trên thì:

- Component (thành phần):
	- Khai báo interface hoặc abtract chung cho các thành phần đối tượng.
	- Chứa các method thao tác chung của các thành phần đối tượng.
- Leaf (Lá):
	- Biểu diễn các đối tượng lá trong thành phần đối tượng.
- Composite (hỗn hợp):
	- Định nghĩa một thao tác cho các thành phần có thành phần con.
	- Lưu trữ các thành con.
	- Thực thi sự quản lý các thành phần con của Component.
- Client:
	- Điều khiển các đối tượng trong Composite thông qua các method trong Component.

# 3. Ví dụ
Một file html là một cấu trúc phân cấp, bắt đầu từ thẻ tag  `<html>` và sau đó gồm nhiều các thẻ tag khác có thể là parent hoặc child tag.
Trong ví dụ này chúng ta sẽ sử dụng lớp component như là một lớp trừu tượng, trong đó bao gồm các method quan trọng được dùng trong các composite và leaf.
```java
public abstract class HtmlTag {  
    public abstract String getTagName();  

    public abstract void setStartTag(String tag);  

    public abstract void setEndTag(String tag);  

    public void setTagBody(String tagBody) {  
        throw new UnsupportedOperationException("Current operation is not support for this object");  
    }  

    public void addChildTag(HtmlTag htmlTag) {  
        throw new UnsupportedOperationException("Current operation is not support for this object");  
    }  

    public void removeChildTag(HtmlTag htmlTag) {  
        throw new UnsupportedOperationException("Current operation is not support for this object");  
    }  

    public List<HtmlTag> getChildren() {  
        throw new UnsupportedOperationException("Current operation is not support for this object");  
    }  

    public abstract void generateHtml();  
}
```
Trong lớp `HtmlTag` thì các method được định nghĩa đều sẽ được dùng bởi các lớp composite và leaf. Có một vài method nên được sử dụng cụ thể trong cả từng class con, vì vậy nên chúng ta sẽ giữ nó ở dạng abtract trong lớp cha. Ví dụ như _getTagName()_.
Một số method chỉ hữu dụng trong composite nhưng lại không mấy có tác dụng trong leaf như _removeChildTag()_. Chúng ta sẽ để chúng ở dạng default và cung cấp một loại Exception cho những object không sử dụng chúng.

Bây giờ chúng ta sẽ tạo một Composite class như sau:
```java
public class HtmlParentElement extends HtmlTag {  
    private String tagName;  
    private String startTag;  
    private String endTag;  
    private List<HtmlTag> childrenTag;  

    public HtmlParentElement(String tagName) {  
        this.tagName = tagName;  
        this.startTag = "";  
        this.endTag = "";  
        this.childrenTag = new ArrayList<>();  
    }  

    @Override  
  public String getTagName() {  
        return tagName;  
    }  

    @Override  
  public void setStartTag(String tag) {  
        this.startTag = tag;  
    }  

    @Override  
  public void setEndTag(String tag) {  
        this.endTag = tag;  
    }  

    @Override  
  public void addChildTag(HtmlTag htmlTag) {  
        childrenTag.add(htmlTag);  
    }  

    @Override  
  public void removeChildTag(HtmlTag htmlTag) {  
        childrenTag.remove(htmlTag);  
    }  

    @Override  
  public List<HtmlTag> getChildren() {  
        return childrenTag;  
    }  

    @Override  
  public void generateHtml() {  
        System.out.println(startTag);  
        for (HtmlTag tag : childrenTag) {  
            tag.generateHtml();  
        }  
        System.out.println(endTag);  

    }  

}
```
`HtmlParentElement` là lớp composite và nó cần implement các method như _addChildTag_, removeChildTag_, _getChildren_.

```java
public class HtmlElement extends HtmlTag {  
    private String tagName;  
    private String startTag;  
    private String endTag;  
    private String tagBody;  

    public HtmlElement(String tagName) {  
        this.tagName = tagName;  
        this.tagBody = "";  
        this.startTag = "";  
        this.endTag = "";  
    }  

    @Override  
  public String getTagName() {  
        return tagName;  
    }  

    @Override  
  public void setStartTag(String tag) {  
        this.startTag = tag;  
    }  

    @Override  
  public void setEndTag(String tag) {  
        this.endTag = tag;  
    }  

    @Override  
  public void setTagBody(String tagBody) {  
        this.tagBody = tagBody;  
    }  

    @Override  
  public void generateHtml() {  
        System.out.println(startTag + "" + tagBody + "" + endTag);  
    }  
}
```

`HtmlElement` là lớp leaf và nó có nhiệm vụ chính là implement các opearation method. Trong ví dụ này là _generateHtml_.

Cuối cùng là chạy test:
```java
public class TestCompositePattern {  
    public static void main(String[] args) {  
        HtmlTag parentTag = new HtmlParentElement("<html>");  
        parentTag.setStartTag("<html>");  
        parentTag.setEndTag("</html>");  

        HtmlTag p1 = new HtmlParentElement("<body>");  
        p1.setStartTag("<body>");  
        p1.setEndTag("</body>");  

        parentTag.addChildTag(p1);  

        HtmlTag child1 = new HtmlElement("<p>");  
        child1.setStartTag("<p>");  
        child1.setEndTag("</p>");  
        child1.setTagBody("Testing html tag library");  
        p1.addChildTag(child1);  

        child1 = new HtmlElement("<p>");  
        child1.setStartTag("<p>");  
        child1.setEndTag("</p>");  
        child1.setTagBody("Paragraph 2");  
        p1.addChildTag(child1);  

        parentTag.generateHtml();  

    }
```

Kết quả của đoạn test trên sẽ là:

```
<html>
<body>
<p>Testing html tag library</p>
<p>Paragraph 2</p>
</body>
</html>
```

# 4. Khi nào dùng Composite Pattern
- Khi bạn muốn tạo ra các đối tượng trong các cấu trúc cây để biểu diễn hệ thống phân lớp.
- Khi bạn muốn client có thể bỏ qua sự khác nhau giữa các thành phần cấu tạo object và bản thân object. Các client tác động đến từng đối tượng và các thành phần của đối tượng một cách thống nhất.

# 5. Source code
https://github.com/tubean/design-pattern/
