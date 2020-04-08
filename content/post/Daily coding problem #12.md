---
title: "[Daily Coding Problem] #12"
slug: daily-code-12
date: 2020-04-08
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
Given an integer k and a string s, find the length of the longest substring that contains at most k distinct characters.
>
For example, given s = "abcba" and k = 2, the longest substring with k distinct characters is "bcb".__

# Method
Ý tưởng của bài này là:

- Bắt đầu một chuỗi substring đầu tiên là ký tự đầu, sau đó thêm dần các ký tự tiếp của chuỗi sao cho số lượng ký tự unique không vượt quá k.

- Nếu đến vị trí chuỗi substring có nhiều hơn k ký tự unique thì chúng ta ghi nhận kết quả độ dài chuỗi trước đó, sau đó kiểm tra chuỗi substring mới bằng cách loại bỏ dần các ký tự bên trái.

- Cuối cùng là so sánh các độ dài ghi nhận được và in kết quả lớn nhất.

# Code Implementation

```
private static int lengthOfLongestSubstring(String s, int k) {
        Map<Character,Integer> map = new HashMap<>();
        int begin = 0, end = 0;
        // The number of distinct character.
        int counter = 0;
        // The length of longest substring.
        int maxLen = 0;

        while (end < s.length()) {
            char cEnd = s.charAt(end);
            map.put(cEnd, map.getOrDefault(cEnd, 0) + 1);
            if (map.get(cEnd) == 1) {
                counter++;  //new char
            }
            end++;

            // counter > k means that
            // there are more than k distinct characters in the current window.
            // So we should move the sliding window.
            while (counter > k) {
                char cBegin = s.charAt(begin);
                map.put(cBegin, map.get(cBegin) - 1);
                if (map.get(cBegin) == 0) {
                    counter--;
                }
                begin++;
            }
            // Pay attention here!
            // We don't get/update the result in while loop above
            // Because if the number of distinct character isn't big enough, we won't enter the while loop
            // eg. s = "abc" (We'd better update the result here to avoid getting 0 length)
            maxLen = Math.max(maxLen, end - begin);
        }

        return maxLen;
    }
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day12

# Reference
[Link](https://github.com/cherryljr/LeetCode/blob/master/Longest%20Substring%20with%20At%20Most%20Two%20Distinct%20Characters.java)
