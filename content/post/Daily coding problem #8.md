---
title: "[Daily Coding Problem] #8"
slug: daily-code-8
date: 2020-04-04
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
Given a list of integers, write a function that returns the largest sum of non-adjacent numbers. Numbers can be 0 or negative.
>
For example, [2, 4, 6, 2, 5] should return 13, since we pick 2, 6, and 5. [5, 1, 1, 5] should return 10, since we pick 5 and 5.
Follow-up: Can you do this in O(N) time and constant space?
>

# Code
```
private static int detectSum(int[] num) {
        int a = 0;
        int b = 0;
        for (int n : num) {
            int temp = a;
            a = Math.max(a, b);
            b = n + temp;
        }
        return Math.max(a, b);
    }
```


# Source code
https://github.com/tubean/dailycode/tree/master/src/day8
