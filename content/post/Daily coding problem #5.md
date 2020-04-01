---
title: "[Daily Coding Problem] #5"
slug: daily-code-5
date: 2020-04-01
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
This problem was asked by Google.

>An XOR linked list is a more memory efficient doubly linked list. Instead of each node holding next and prev fields, it holds a field named both, which is an XOR of the next node and the previous node. Implement an XOR linked list; it has an add(element) which adds the element to the end, and a get(index) which returns the node at index.
>
If using a language that has no pointers (such as Python), you can assume you have access to get_pointer and dereference_pointer functions that converts between nodes and memory addresses.

>
Vietsub: Thử triển khai kiểu cấu trúc dữ liệu XOR Linked List.

# Method
Trước tiên để hiểu đề bài chúng ta sẽ tìm hiểu khái niệm về toán tử `XOR` và một `linked list`.

## __XOR__

  Phép toán XOR trong logic có input là 2 bit a và b, output là 1 khi mà a != b và 0 trong trường hợp ngược lại.

Các tính chất của XOR như sau:

- A XOR 0 = A
- A XOR A = 0
- (A XOR B) XOR C = A XOR (B XOR C)
- (B XOR A) XOR A = B XOR 0 = B

Nhân tiện tìm hiểu về XOR thì chúng ta xem một ví dụ sau:

>
Given a non-empty array of integers, every element appears twice except for one. Find that single one.
>
Exp: Input: [4,1,2,1,2]
Output: 4

Bài toán trên có thể sử dụng nhiều cách khác nhau để giải. Tuy nhiên cách nhanh nhất chính là sử dụng XOR với các mệnh đề 1,2 và 3.

```
public int singleNumber(int[] nums) {
    int a = 0;
    for (int i : nums) {
      a ^= i;
    }
    return a;
  }
```

## __Linked List__
Đây là kiểu cấu trúc dữ liệu quá phổ biến và được ứng dụng rộng rãi với 2 cách Implement là:

1. __Singly-linked list__: Mỗi element bao gồm 1 ô chứa data và 1 con trỏ đến phần tử tiếp theo. Do chỉ có con trỏ đi tiếp nên Singly-linked list chỉ có thể duyệt theo một chiều.
2. __Doubly-linked list__: để khắc phục hạn chế của singly-linked list, người ta tạo thêm một con trỏ nữa để tham chiếu đến phần tử trước đó của một element. Do đó doubly-linked list có thể duyệt xuôi ngược tùy thích.
![Ví dụ minh họa](https://res.cloudinary.com/practicaldev/image/fetch/s--kuwbU5e8--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/vagix3khf5q0655ykyna.png)

3. __XOR Linked List__:

Giống như `Singly` hay `Doubly` thì tại mỗi node của kiểu cấu trúc này cũng chứa phần data và phần tham chiếu đến các node khác. Tuy nhiên `XOR Linked List` không sử dụng 2 con trỏ như Doubly mà chỉ sử dụng thêm một 'con trỏ' giống như `Singly`. Tuy nhiên `XOR Linked List` lại có khả năng duyệt xuôi ngược 2 chiều như `Doubly`. Vậy nó thực hiện việc này như thế nào?

Giả sử bạn có 4 nodes trong một `XOR linked list` có địa chỉ tham chiếu lần lượt là A, B, C, D

- A là head, chỉ chứa con trỏ tới B (0 XOR B): chỉ có thể duyệt tiến.
- B, C là middle, là phần tử ở giữa nên B lưu trữ dữ liệu tham chiếu đến cả A và C (A XOR C), C lưu dữ liệu đến B và D (B XOR D)
- D là tail, phần tử cuối nên nó chỉ cần chứa dữ liệu tham chiếu đến C (C XOR 0).

Chúng ta thực hiện việc duyệt như sau:

- Từ A -> B ta lấy: (B XOR 0) XOR 0 = B
- Từ B -> C ta lấy: (C XOR A) XOR A = C
- Từ C -> D ta lấy: (D XOR C) XOR C = D

![Ví dụ minh họa](https://res.cloudinary.com/deop9ytsv/image/upload/v1585732551/xor_list.png)

Tương tự với việc duyệt ngược lại. Tuy nhiên chúng ta thấy nếu thực hiện duyệt với XOR Linked List thì bắt buộc chúng ta phải duyệt từ head hoặc tail, nếu chỉ duyệt từ giữa thì không có đủ thông tin đi đến các node tiếp theo.

Do đó mặc dù XOR có lợi thế là tiết kiệm bộ nhớ nhưng nó không thực sự hữu ích bằng doubly và còn có thể gây nhiều khó khăn trong triển khai. (Trong Java thậm chí còn không sử dụng con trỏ như C để tránh việc lạm dụng và can thiệp vào cách quản lý bộ nhớ garbage collection).

# Code implementation
Việc thực hiện một implementation của XOR linked list bằng Java xin phép được lấy từ một bài viết sưu tập được trên mạng. (Link dưới phần Reference).

Các bạn có thể tìm thấy các cách implementation tốt hơn nếu sử dụng C hoặc C++ (miễn là có con trỏ để nghịch :D). Chúc các bạn code vui vẻ!


# Source code
https://github.com/tubean/dailycode/tree/master/src/day5

# Reference
https://dev.to/awwsmm/java-daily-coding-problem-006-2l98
