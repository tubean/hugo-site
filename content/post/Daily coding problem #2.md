---
title: "[Daily Coding Problem] #2"
slug: daily-code-2
date: 2020-03-29
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

Ngày hôm nay chúng ta sẽ xem xét một câu hỏi của **Uber**:
# Problem
>
Given an array of integers, return a new array such that each element at index i of the new array is the product of all the numbers in the original array except the one at i.
>
For example, if our input was [1, 2, 3, 4, 5], the expected output would be [120, 60, 40, 30, 24]. If our input was [3, 2, 1], the expected output would be [2, 3, 6].
>
Follow-up: what if you cant use division?
>
Vietsub: Cho một mảng gồm các số nguyên, hãy in ra một mảng mới sao cho mỗi vị trí i của mảng mới bằng tích của tất cả các số của mảng ban đầu ngoại trừ số ở vị trí i.
>
Câu hỏi thêm: thực hiện mà không sử dụng phép chia

Đối với bài toán này, cách tự nhiên nhất mà mọi người có thể nghĩ tới là duyệt một lần để tìm tích của tất cả các số, sau đó thực hiện phép chia tích đó cho mỗi số ở vị trí i (lưu ý check = 0 trước khi chia).

Tuy nhiên cách này không giải quyết được câu hỏi thêm là không sử dụng phép chia. Hoặc có thể đối với từng vị trí, ta thực hiện phép nhân tìm tích của tất cả các số còn lại. Tuy vậy cách này có vẻ phải duyệt quá nhiều lần dẫn đến độ phức tạp lớn.

# Method
Dưới đây sẽ một ý tưởng thành lập 2 mảng mới, một mảng sẽ bao gồm tích của tất cả các số bên trái số tại vị trí i (prefix), mảng còn lại là tích của tất cả các số bên phải số tại vị trí i (suffix). Từ đó tạo ra mảng cần tìm bằng cách nhân các số ở cùng vị trí với nhau.

1.  Tạo một mảng **product** có size bằng mảng A ban đầu, khởi tạo các vị trí đều bằng 1. Tạo một biến **temp** = 1.
2.  Duyệt các phần tử của mảng A từ trái sang phải
3.  Đối với từng vị trí i của mảng **product**, chúng ta update giá trị bằng tích của các số mảng A từ vị trí đầu tiên đến vị trí **i - 1**.
4.  Duyệt các phần tử của mảng A từ phải sang trái
5.  Cập nhật lại giá trị của mảng **product**: với mỗi vị trí i ta nhân nó với tích của các số mảng A từ vị trí **i + 1** đến vị trí cuối cùng.
6.  In mảng **product**


# Coding implementation
```
private static void printProduct(int[] arr) {

  int n = arr.length;

  // Trường hợp mảng có 1 phần tử -> trả về 0
  if (n == 1) {
      System.out.print("0");
      return;
  }

  int i, temp = 1;

  // Tạo mảng prod
  int[] prod = new int[n];

  // Fill các giá trị của prod = 1
  Arrays.fill(prod, 1);

  // Trong lần duyệt này, giá trị temp sẽ bằng tích của tất cả phần tử bên trái ngoại trừ arr[i]
    for (i = 0; i < n; i++) {
      prod[i] = temp;
      temp *= arr[i];
    }

  // Gán temp = 1 để sử dụng cho lần duyệt bên phải
    temp = 1;

  // Trong lần duyệt này, giá trị temp sẽ bằng tích của tất cả các phần tử bên phải ngoại trừ arr[i]
    for (i = n - 1; i >= 0; i--) {
      prod[i] *= temp;
      temp *= arr[i];
    }

   // In ra mảng product
   System.out.println(Arrays.toString(prod));
}
```
# Source code
https://github.com/tubean/dailycode/tree/master/src/day2
