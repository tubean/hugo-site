---
title: "[Daily Coding Problem] #11"
slug: daily-code-11
date: 2020-04-07
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
There exists a staircase with N steps, and you can climb up either 1 or 2 steps at a time. Given N, write a function that returns the number of unique ways you can climb the staircase. The order of the steps matters.
>
For example, if N is 4, then there are 5 unique ways:
>
- 1, 1, 1, 1
- 2, 1, 1
- 1, 2, 1
- 1, 1, 2
- 2, 2
>
What if, instead of being able to climb 1 or 2 steps at a time, you could climb any number from a set of positive integers X? For example, if X = {1, 3, 5}, you could climb 1, 3, or 5 steps at a time.

# Method
Bằng việc thử các test case, chúng ta xác định được một số trường hợp như sau:

- N = 1, có 1 cách là : [1]
- N = 2, có 2 cách là : [1, 1], [2]
- N = 3, có 3 cách là : [1, 2], [1, 1, 1], [2, 1]
- N = 4, có 5 cách là : [1, 1, 2], [2, 2], [1, 2, 1], [1, 1, 1, 1], [2, 1, 1]

Các bạn nhận ra dãy số quen thuộc 1,2,3,5 chứ? Vâng chúng chính là dãy __Fibonacci__. Từ đó chúng ta mạnh dạn dự đoán quy luật của dãy số sẽ được xây dựng trên function: `f(n) = f(n-1) + f(n-2)`.

Đối với câu hỏi thêm, chúng ta có quy luật như sau:

`f(n) = f(n-X[0]) + f(n-X(1)) + f(n-X(2)) + ... + f(n-X(k)) với k = X.length và k < n.`

# Code Implementation

```
private static int countCase(int n, int[] X) {
        int[] cache = new int[n+1];

        cache[0] = 1;
        for (int i = 0; i < n + 1; i++) {
            boolean isExist = false;
            for (int x : X) {
                if(i == x) isExist = true;
                if(i > x) cache[i] += cache[i-x];
            }
            if(isExist) cache[i] += 1;
        }

        return cache[n];
    }
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day11

# Reference
https://www.dailycodingproblem.com/blog/staircase-problem/
