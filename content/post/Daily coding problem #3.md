---
title: "[Daily Coding Problem] #3"
slug: daily-code-3
date: 2020-03-30
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

Câu hỏi hôm nay là về kiểu cấu trúc dữ liệu dạng cây:
# Problem
>
Given the root to a binary tree, implement serialize(root), which serializes the tree into a string, and deserialize(s), which deserializes the string back into the tree.

For example, given the following Node class
```
class Node:
    def __init__(self, val, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right
```        
The following test should pass:
```
node = Node('root', Node('left', Node('left.left')), Node('right'))
assert deserialize(serialize(node)).left.left.val == 'left.left'
```

# Method
Ý tưởng của bài toán chính là biểu diễn dữ liệu dạng cây dưới dạng một string và có thể từ string đó để tạo thành một cây ban đầu.
Chúng ta sẽ sử dụng đệ quy để thực hiện việc serialize, đối với node = null thì đánh dấu bởi ký tự "X" và các node sẽ phân tách bởi dấu ','.
Đối với việc deserialize, chúng ta sẽ sử dụng Queu để xử lý.

# Code implementation
```
    private static String serialize(TreeNode root) {
        // return X if node = null
        if(root == null) return "X";
        // get left tree
        String leftSerialized = serialize(root.left);
        // get right tree
        String rightSerialized = serialize(root.right);
        return root.val + "," + leftSerialized + "," + rightSerialized;
    }

    private static TreeNode deserialize(String str) {
        Queue<String> nodesLeft = new LinkedList<>(Arrays.asList(str.split(",")));
        return deserializeHelper(nodesLeft);
    }

    private static TreeNode deserializeHelper(Queue<String> nodesLeft) {
        String nodeVal = nodesLeft.poll();
        if(nodeVal.equals("X")) return null;
        TreeNode newNode = new TreeNode(Integer.valueOf(nodeVal));
        newNode.left = deserializeHelper(nodesLeft);
        newNode.right = deserializeHelper(nodesLeft);
        return newNode;
    }
```

# Source code
https://github.com/tubean/dailycode/tree/master/src/day3

# Reference
https://www.youtube.com/watch?v=suj1ro8TIVY
