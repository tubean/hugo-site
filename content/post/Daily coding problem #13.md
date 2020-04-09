---
title: "[Daily Coding Problem] #13"
slug: daily-code-13
date: 2020-04-09
categories:
- Daily Code Problems
- Java
tags:
- daily code
- interview
- algorithms
- java
keywords:
- daily
- coding
- java
- problems
- algorithms
- tutorial
- intelij
autoThumbnailImage: true
thumbnailImagePosition: "left"
thumbnailImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1585475653/daily-code.png
coverImage: https://res.cloudinary.com/deop9ytsv/image/upload/v1541273502/Black_flag.svg.png
metaAlignment: center
---
Chào các bạn.

Câu hỏi hôm nay như sau:
# Problem
>
The area of a circle is defined as πr^2. Estimate π to 3 decimal places using a Monte Carlo method.
>
Hint: The basic equation of a circle is x2 + y2 = r2.

# Method
Phương pháp Monte Carlo là dựa vào xác suất thống kê để tính toán số Pi. Theo đó thì :

- Giả sử ta có 1 bảng mục tiêu hình vuông 1x1. Tâm là gốc tọa độ O(0,0). Từ gốc tọa độ ta vẽ một đường tròn nội tiếp hình vuông.

- Một xạ thủ bắn phi tiêu vào bảng mục tiêu (Giả sử tất cả đều trúng mục tiêu nhưng có thể trong hoặc ngoài hình tròn.)

- Sau n phát ta thống kê được k phát bắn nằm trong hình tròn. Công thức tính số pi là `pi = (k/n)/4`.

- Với n càng lớn thì ta càng tiến sát tới số pi.

![Ví dụ minh họa](https://res.cloudinary.com/deop9ytsv/image/upload/v1586329960/e9xI1.gif)

# Code Implementation

```
public static void main(String[] args)
    {
        int i;
        int nThrows = 0;
        int nSuccess = 0;

        double x, y;

        for (i = 0; i < 1000000 ; i++)
        {
            x = Math.random();      // Throw a dart
            y = Math.random();

            nThrows++;

            if ( x*x + y*y <= 1 )
                nSuccess++;
        }

        System.out.println("Pi/4 = " + (double)nSuccess/(double)nThrows );
        System.out.println("Pi = " + 4*(double)nSuccess/(double)nThrows );
    }
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day13

# Reference
[Link](http://www.mathcs.emory.edu/~cheung/Courses/170/Syllabus/07/compute-pi.html)
