﻿---
title: "[Daily Coding Problem] #1"
slug: daily-code-1
date: 2020-03-28
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

Nhân dịp rảnh rỗi do dịch COVID-19, tôi quyết định đào mộ lại cái blog này sau một năm bận các công việc cá nhân.

Như tiêu đề thì series này sẽ tổng hợp một số câu hỏi phỏng vấn về thuật toán kinh điển trong các công ty cũng như cách giải quyết vấn đề cho mỗi câu hỏi. Mọi bài toán đều có cách giải riêng cho nó. Vì vậy tôi rất hoan nghênh sự đóng góp của các bạn trong việc phân tích và đưa ra những lời giải độc đáo cho mỗi vấn đề.

Khởi đầu chúng ta sẽ cùng xem xét một câu hỏi tương đối dễ thường được hỏi bởi Google:
# Problem
```
Given a list of numbers and a number  `k`, return whether any two numbers from the list add up to  `k`.

For example, given  `[10, 15, 3, 7]`  and  `k`  of  `17`, return true since  `10 + 7`  is  17.

Bonus: Can you do this in one pass?
```
Đối với câu hỏi này, cách đơn giản nhất mà chúng ta có thể nghĩ ngay là đối với từng phần tử của mảng, chúng ta sẽ lấy hiệu số của `k` và phần tử đó, sau đó duyệt tìm xem có tồn tại hiệu số đó trong mảng hay không. Tuy nhiên cách này sẽ không giải quyết được câu hỏi bonus là thực hiện trong một lần duyệt duy nhất.

# Method
Dưới đây sẽ là một đáp án sử dụng HashSet để thực hiện giải thuật với độ phức tạp O(n):
```
1) Tạo một hashset S
2) Duyệt từng phần tử i của mảng như sau
   (a)    Nếu [k - A[i]] có trong hashset thì chúng ta có cặp số (A[i], k - A[i]) thỏa mãn
   (b)    Thêm phần tử A[i] vào S.
```
# Coding implementation

    private static void printPairs(int[] initArr, int sum) {
    HashSet<Integer> hs = new HashSet<>();
     boolean isExist = false;
      for (int value : initArr) {
        int temp = sum - value;
         if (hs.contains(temp)) {
            System.out.println("System found " + value + " and " + temp);
            isExist = true;
            }
         hs.add(value);
         }
      if(!isExist) {
        System.out.println("There is no satisfiable pair");
        }
      }

# Source code
https://github.com/tubean/dailycode/tree/master/src/day1
