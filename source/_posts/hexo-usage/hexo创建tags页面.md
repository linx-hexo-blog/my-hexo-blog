---
title: hexo创建tags页面
date: {{ date }}
categories: 
- hexo实践
tags: 
- hexo
---

hexo如何生成“标签”页并添加tpye属性？

<!-- more -->

# 创建“标签”选项

## 1 生成“标签”页并添加tpye属性
打开命令行，进入博客所在文件夹。执行命令

```
$ hexo new page tags
```

成功后会提示：

```
INFO  Created: ~/Documents/blog/source/tags/index.md
```

根据上面的路径，找到index.md这个文件，打开后默认内容是这样的：

```
---
title: 标签
date: 2017-05-27 14:22:08
---
```

添加type: "tags"到内容中，添加后是这样的：

```
---
title: 文章分类
date: 2017-05-27 13:47:40
type: "tags"
---
```

保存并关闭文件。

## 2 给文章添加“tags”属性

打开需要添加标签的文章，为其添加tags属性。下方的tags:下方的- jQuery - 表格
- 表单验证就是这篇文章的标签了

```
---
title: jQuery对表单的操作及更多应用
date: 2017-05-26 12:12:57
categories: 
- web前端
tags:
- jQuery
- 表格
- 表单验证
---
```

至此，成功给文章添加分类，点击首页的“标签”可以看到该标签下的所有文章。当然，只有添加了tags: xxx的文章才会被收录到首页的“标签”中。