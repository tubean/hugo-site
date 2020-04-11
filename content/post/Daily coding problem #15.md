---
title: "[Daily Coding Problem] #15"
slug: daily-code-15
date: 2020-04-11
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
You run an e-commerce website and want to record the last N order ids in a log. Implement a data structure to accomplish this, with the following API:
>
- record(order_id): adds the order_id to the log
- get_last(i): gets the ith last element from the log. i is guaranteed to be smaller than or equal to N.
>
You should be as efficient with time and space as possible.

# Code

```
public class LogDataStructure {
    private int maxSize;
    private int[] circularBuffer;
    private int currIdx;

    public LogDataStructure(int n) {
        this.maxSize = n;
        this.circularBuffer = new int[n];
        this.currIdx = 0;
    }

    public void record(int orderId) {
        circularBuffer[currIdx] = orderId;
        currIdx = (currIdx + 1) % maxSize;
    }

    public int getLast(int i) {
        return circularBuffer[(currIdx - i + maxSize) % maxSize];
    }
}
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day15

# Reference
[Link](https://www.cnblogs.com/lz87/p/10111902.html)
