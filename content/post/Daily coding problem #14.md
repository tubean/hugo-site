---
title: "[Daily Coding Problem] #14"
slug: daily-code-14
date: 2020-04-10
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
Given a stream of elements too large to store in memory, pick a random element from the stream with uniform probability.
>
Vietsub: Cho một file chứa rất lớn số lượng số tự nhiên. Yêu cầu bạn chỉ được đọc qua file 1 lần (sequential read) và phải chọn được một số ngẫu nhiên trong đó sao cho xác suất mỗi phần tử được chọn là bằng nhau, và bằng 1/N, với N là số lượng phần tử trong file. Một cách hiểu khác là bạn được cho 1 stream of numbers, và khi stream kết thúc thì bạn phải in ra 1 số ngẫu nhiên trong các số đã nhận được với xác suất 1/N.

# Method

Những yêu cầu của bài toán là:

- Chỉ được scan qua file 1 lần
- Không được lưu lại mảng (vì dữ liệu rất rất lớn) vào bộ nhớ (memory lẫn external)
- Bạn không biết trước N
- Bạn được dùng hàm random(k) của hệ thống (trả về 1 số ngẫu nhiên trong [0, k-1]

Nếu cho bạn một mảng N phần tử với N biết trước, và kêu chọn một phần tử ngẫu nhiên bất kì trong N phần tử đó, thì chỉ cần gọi A[random(N)], thì xác suất mỗi phần tử được chọn sẽ bằng nhau và = 1/N - cái khó bài này là bạn không có mảng A trong bộ nhớ, và cũng không được scan file 2 lần.

Ý tưởng làm bài này như sau:

1. Tạo biến count là số lượng các số được scan trong stream.
2. Với mỗi số x trong stream, thực hiện các bước:
 - Tăng count thêm 1 đơn vị
 - Nếu count = 1, set kết quả là x và trả về
 - Tạo một số i ngẫu nhiên từ 0 đến `count-1`. Nếu `i = count - 1` thì update kết quả là x.


# Code Implementation

```
public class Main {
    public static void main(String[] args) {
        int stream[] = {1, 2, 3, 4};
        int n = stream.length;
        for(int i = 0; i < n; i++)
            System.out.println("Random number from first " + (i+1) +
                    " numbers is " + selectRandom(stream[i]));
    }

    static int res = 0;    // The resultant random number
    static int count = 0;  //Count of numbers visited so far in stream

    //A method to randomly select a item from stream[0], stream[1], .. stream[i-1]
    static int selectRandom(int x)
    {
        count++; // increment count of numbers seen so far

        // If this is the first element from stream, return it
        if (count == 1)
            res = x;
        else
        {
            // Generate a random number from 0 to count - 1
            Random r = new Random();
            int i = r.nextInt(count);

            // Replace the prev random number with new number with 1/count probability
            if(i == count - 1)
                res = x;
        }
        return res;
    }
}
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day14

# Reference
[Link](https://www.geeksforgeeks.org/select-a-random-number-from-stream-with-o1-space/)
