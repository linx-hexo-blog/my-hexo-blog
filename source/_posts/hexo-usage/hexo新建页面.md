---
title: hexo new page xxx
date: {{ date }}
categories: 
- hexo实践
tags: 
- hexo 
- new page
---


使用 Hexo 生成一个新页面，可以通过命令行输入以下命令：

```sh
hexo new page <page_name>
```

其中，`<page_name>` 是你希望新页面的名称。例如，如果你想创建一个名为 "about" 的页面，你可以输入：

```sh
hexo new page about
```

这将会在 `source` 目录下创建一个名为 `about` 的文件夹，其中包含一个 `index.md` 文件，你可以在这个文件中编写页面的内容。

### 完整步骤

1. **确保你在 Hexo 博客的根目录下**：你需要在 Hexo 项目的根目录下运行命令。你可以使用 `cd` 命令导航到你的 Hexo 项目根目录。例如：

    ```sh
    cd /path/to/your/hexo/project
    ```

2. **生成新页面**：运行以下命令生成新页面。

    ```sh
    hexo new page <page_name>
    ```

    例如：

    ```sh
    hexo new page about
    ```

3. **编辑新页面**：生成的新页面会在 `source` 目录下创建一个以页面名称命名的文件夹，并包含一个 `index.md` 文件。你可以编辑这个文件来添加页面内容。

    ```sh
    vi source/about/index.md
    ```

    在这个文件中，你可以编写 Markdown 格式的内容。默认情况下，文件内容如下：

    ```markdown
    ---
    title: about
    date: 2024-07-30 12:00:00
    ---

    ```

    你可以在 `---` 下面添加页面的实际内容。

4. **生成和部署**：完成编辑后，你可以生成静态文件并将其部署到你的服务器或托管平台。

    ```sh
    hexo generate
    hexo deploy
    ```

    或者可以简化为：

    ```sh
    hexo g -d
    ```

### 示例

假设你想创建一个 "contact" 页面，步骤如下：

1. **导航到 Hexo 项目根目录**：

    ```sh
    cd /path/to/your/hexo/project
    ```

2. **生成 "contact" 页面**：

    ```sh
    hexo new page contact
    ```

3. **编辑 `source/contact/index.md`** 文件：

    ```markdown
    ---
    title: contact
    date: 2024-07-30 12:00:00
    ---

    # Contact Us

    Feel free to reach out via email at example@example.com.
    ```

4. **生成并部署**：

    ```sh
    hexo g -d
    ```

这样，你的 Hexo 博客将会有一个新的 "contact" 页面，你可以通过 `http://your-blog-url/contact` 来访问它。