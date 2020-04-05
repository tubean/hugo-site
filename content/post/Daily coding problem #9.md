---
title: "[Daily Coding Problem] #9"
slug: daily-code-9
date: 2020-04-05
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
Implement a job scheduler which takes in a function f and an integer n, and calls f after n milliseconds.

# Code
```
public class Main {
    public static void main(String[] args) {
        solution(() -> System.out.println("Hello World"), 10000);
    }

    public static void solution(Command command, int n) {
        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                command.execute();
            }
        }, n);

    }

    interface Command {
        void execute();
    }

}
```


# Source code
https://github.com/tubean/dailycode/tree/master/src/day9

#Reference
https://codereview.stackexchange.com/questions/214538/implement-a-job-scheduler-which-takes-in-a-function-f-and-an-integer-n-and-call
