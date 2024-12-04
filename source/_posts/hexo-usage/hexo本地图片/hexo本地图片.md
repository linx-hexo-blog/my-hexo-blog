---
title: hexo本地图片
date: {{ date }}
categories: 
- hexo实践
tags: 
- hexo
---

# Hexo 官方插入本地图片方法

* [hexo官网 - 资源文件夹](https://hexo.io/zh-cn/docs/asset-folders)

## 1. 绝对路径（全局图片）

如果你的Hexo项目中只有少量图片，那最简单的方法就是将它们统一放在 `source/images` 文件夹中。然后通过以下方法进行访问。

```
![](/imges/image.jpg)
```

图片既可以在首页内容中访问到，也可以在文章正文中访问到。

## 2. 相对路径（文章图片）

图片除了可以放在统一的 `source/images` 文件夹中，还可以放在文章自己的目录中。文章的目录可以通过配置 `_config.yml` 来生成。

```
post_asset_folder: true
```

将 `_config.yml` 文件中的配置项 `post_asset_folder` 设为 `true` 后，执行命令 `hexo new post_name`，在 `source/_posts` 中会生成文章 `post_name.md` 和同名文件夹 `post_name`。将图片资源放在 `post_name` 中，文章就可以使用相对路径引用图片资源了。引用图片的方法如下：

```
![](image.jpg)
```

以上这种引用方法，图片只能在文章中显示，但无法在首页中正常显示。如果希望图片在文章和首页中同时显示，可以使用标签插件语法。


# 3. 标签插件


通过常规的 markdown 语法和相对路径来引用图片和其它资源可能会导致它们在存档页或者主页上显示不正确。在Hexo 2时代，社区创建了很多插件来解决这个问题。但是，随着Hexo 3 的发布，许多新的标签插件被加入到了核心代码中。这使得你可以更简单地在文章中引用你的资源。

引用语法如下：

```
{% asset_path slug %}
{% asset_img slug [title] %}
{% asset_link slug [title] %}
```

在上述语法下，引用图片的方法如下：

```
{%  asset_img example.jpg This is an example image %}
```

通过这种方式，图片将会同时出现在文章和主页以及归档页中。

# 二、图床


### a. 图床设置

> 使用 `Picgo` + `Github`

![](https://raw.githubusercontent.com/lionsom/imagesRepo/hexo/001-hexo-usage/202407221550864.png)

# 三、插件

六种图片引入方式：
```
# 文件夹名称不一样
![1](A.gif)
![2](assets/A.gif)
![3](./assets/A.gif)

# 文件夹名称一样
![4](myhead.jpg)
![5](hexo本地图片/myhead.jpg)
![6](./hexo本地图片/myhead.jpg)
```

* 未安装 `hexo-asset-image` 插件，图片无法显示。
  * 本地：1 4 不显示，2 3 5 6 显示
  * 远程：4 显示，其他不显示
* 安装 `hexo-asset-image`





![1](A.gif)

![2](assets/A.gif)

![3](./assets/A.gif)


![4](myhead.jpg)

![5](hexo本地图片/myhead.jpg)

![6](./hexo本地图片/myhead.jpg)