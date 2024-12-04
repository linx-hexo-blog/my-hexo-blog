---
title: hexo创建categories页面
date: {{ date }}
categories: 
- hexo实践
tags: 
- hexo
---

hexo如何生成“分类”页并添加tpye属性？

<!-- more -->

# 创建“分类”选项
## 1 生成“分类”页并添加tpye属性
打开命令行，进入博客所在文件夹。执行命令

```
$ hexo new page categories
```

成功后会提示：

```
INFO  Created: ~/Documents/blog/source/categories/index.md
```

根据上面的路径，找到index.md这个文件，打开后默认内容是这样的：

```
---
title: 文章分类
date: 2017-05-27 13:47:40
---
```
添加type: "categories"到内容中，添加后是这样的：

```
---
title: 文章分类
date: 2017-05-27 13:47:40
type: "categories"
---
```
保存并关闭文件。

## 2 给文章添加“categories”属性
打开需要添加分类的文章，为其添加categories属性。下方的categories: web前端表示添加这篇文章到“web前端”这个分类。注意：hexo一篇文章只能属于一个分类，也就是说如果在“- web前端”下方添加“-xxx”，hexo不会产生两个分类，而是把分类嵌套（即该文章属于 “- web前端”下的 “-xxx ”分类）。

```
---
title: jQuery对表单的操作及更多应用
date: 2017-05-26 12:12:57
categories: 
- web前端
---
```

至此，成功给文章添加分类，点击首页的“分类”可以看到该分类下的所有文章。当然，只有添加了categories: xxx的文章才会被收录到首页的“分类”中。