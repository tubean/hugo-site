---
title: "[Daily Coding Problem] #7"
slug: daily-code-7
date: 2020-04-03
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
A unival tree (which stands for "universal value") is a tree where all nodes under it have the same value.
>
Given the root to a binary tree, count the number of unival subtrees.
>
For example, the following tree has 5 unival subtrees:
>
```
   0
  / \
 1   0
    / \
   1   0
  / \
 1   1
```

# Code implementation
```
private static int getUnivalCount(TreeNode node){
        if (node == null)return 0;

        int count = getUnivalCount(node.left) + getUnivalCount(node.right);
        if(isUnivalTree(node)){
            count++;
        }

        return count;
    }

    private static boolean isUnivalTree(TreeNode node){
        if(node == null)
            return true;
        else if(node.left !=null && node.left.value == node.value)
            return true;
        else if (node.right !=null && node.right.value == node.value)
            return false;
        return isUnivalTree(node.left) && isUnivalTree(node.right);
    }
```


# Source code
https://github.com/tubean/dailycode/tree/master/src/day7
