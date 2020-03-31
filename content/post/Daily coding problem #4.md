---
title: "[Daily Coding Problem] #4"
slug: daily-code-4
date: 2020-03-31
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
Given an array of integers, find the first missing positive integer in linear time and constant space. In other words, find the lowest positive integer that does not exist in the array. The array can contain duplicates and negative numbers as well.
>
For example, the input [3, 4, -1, 1] should give 2. The input [1, 2, 0] should give 3.
>
You can modify the input array in-place.
>
Vietsub: Tìm số nguyên dương nhỏ nhất còn không tồn tại trong một mảng số nguyên cho trước với độ phức tạp của thuật toán là O(n).

# Method
Giả sử chúng ta có mảng sau: [7, 4, -3, 8, 1, 2]. (6 phần tử)

1.  Dễ thấy rằng các số nguyên không dương sẽ không cần quan tâm vì chúng ta đang tìm một số nguyên dương. Số nguyên dương nhỏ nhất là 1 nên nếu không tồn tại số 1 trong mảng thì ngay lập tức có thể trả về 1. Hơn nữa những phần tử có giá trị lớn hơn số lượng các phần tử của mảng cũng không cần quan tâm.
Dựa vào những điều này chúng ta có thể lập thành một mảng mới -> [1, 4, 1, 1, 1, 2]
2. Đối với từng phần tử, chúng ta đánh số thứ tự cho chúng như sau: [1(1), 4(2), 1(3), 1(4), 1(5), 2(6)]
3. Giả sử các số trong ngoặc là giá trị các phần tử của một mảng mới, những số ngoài ngoặc là chỉ số index của các phần tử thì ta sẽ nhận được một mảng như sau: [ 5(1), 6(2), null(3), 2(4), null(5), null(6) ] (vị trí 1 lặp lại nhiều lần thì ta ghi đè bằng giá trị cuối cùng).
4. Dễ thấy vị trí thứ 3 là phần tử đầu tiên trong mảng mới bị null và do đó 3 là số nguyên dương ta cần tìm.

# Code implementation
```
public static int firstMissingPositive(int[] nums) {
    if(nums == null || nums.length == 0) return 1;

    int n = nums.length;
    boolean containsOne = false;

    // step 1: check array contains number 1 and replace all negative number or greater than n to 1.
    for(int i = 0; i < n; i++) {
        if(nums[i] == 1) {
            containsOne = true;
        } else if (nums[i] <= 0 || nums[i] > n) nums[i] = 1;
    }

    // return 1 when there is no number 1 in array
    if (!containsOne) return 1;

    // step 2: find index of each element in sequence array
    for(int i = 0; i < n; i++) {
        int index = Math.abs(nums[i]) - 1;
        if(nums[index] > 0) nums[index] = -1 * nums[index];

    }

    // step 3: in the new array, find the first number which greater than 0 then return its index + 1
    for(int i = 0; i < n; i++) {
        if(nums[i] > 0) return i+1;
    }

    // special case: 1,2,3 -> 4
    return n + 1;
}
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day4

# Reference
https://www.youtube.com/watch?v=9SnkdYXNIzM
