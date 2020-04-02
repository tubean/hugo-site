---
title: "[Daily Coding Problem] #6"
slug: daily-code-6
date: 2020-04-02
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
This problem was asked by Facebook.
>
Given the mapping a = 1, b = 2, ... z = 26, and an encoded message, count the number of ways it can be decoded.
>
For example, the message '111' would give 3, since it could be decoded as 'aaa', 'ka', and 'ak'.
>
You can assume that the messages are decodable. For example, '001' is not allowed.
>
Vietsub: Giả sử mỗi chữ cái trong bảng chữ cái tiếng anh được mã hóa bằng chỉ số index của nó trong bảng. Cho một đoạn string là đoạn mã hóa (chỉ gồm các chữ số), hãy tính xem có bao nhiêu trường hợp sau khi decode thỏa mãn đoạn mã hóa đó.
>
Ví dụ: '111' có thể được decode thành 'aaa', 'ka', 'ak', do đó 3 là đáp án cần tìm.

# Method
Hãy thử bắt đầu decode với chuỗi '54321'. Có một số điều chúng ta có thể nhận ra:

- Decode ký tự '1' -> chuỗi còn lại '5432'
- Decode ký tự '21' -> chuỗi còn lại '543'
- Decode ký tự '321' -> không có case này do bảng chữ cái chỉ có 26 ký tự

Từ đó suy ra ```decode("12345") = decode("5432") + decode("543").```

Tiếp tục chuỗi khác '27345'. Ta nhận ra ```decode("27345") = decode("2734")```

Như vậy bài toán có thể giải quyết bảng đệ quy. Chúng ta bắt đầu từ ký tự cuối cùng của chuỗi string có n ký tự và cứ i ký tự đầu tiên sẽ có số khả năng decode là count(i).

1. count(0) = count(1) = 1; -> trường hợp cơ sở
2. Nếu ký tự cuối cùng khác 0, chúng ta cộng thêm count(n-1) vào số khả năng có thể.
3. Nếu 2 ký tự cuối cùng < 27 thì chúng ta cộng thêm count(n-2) và số khả năng có thể.


# Code implementation
```
private static int numDecodings(String s) {
        int n = s.length();
        int[] count = new int[n + 1];
        count[0] = count[1] = 1;
        if(s.charAt(0) =='0')
            return 0;
        for (int i = 2; i <= n; i++)
        {
            count[i] = 0;

            if (s.charAt(i - 1) > '0')
                count[i] = count[i - 1];

            if (s.charAt(i - 2) == '1' || (s.charAt(i - 2) == '2' && s.charAt(i - 1) < '7'))
                count[i] += count[i - 2];
        }
        return count[n];
    }
```


# Source code
https://github.com/tubean/dailycode/tree/master/src/day6

# Reference
https://www.geeksforgeeks.org/count-possible-decodings-given-digit-sequence/
