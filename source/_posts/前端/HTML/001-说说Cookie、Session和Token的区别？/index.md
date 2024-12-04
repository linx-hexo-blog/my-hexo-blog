---
title: 说说Cookie、Session和Token的区别？
date: {{ date }}
categories: 
- HTML
tags: 
- 前端
- cookie
- session
- token
---

[京东面试：说说Cookie、Session和Token的区别？](https://www.51cto.com/article/775430.html)


## 1.Cookie、Session 和 Token 有什么区别？

Cookie、Session 和 Token 通常都是用来保存用户登录信息的技术，但三者有很大的区别，简单来说 Cookie 适用于简单的状态管理，Session 适用于需要保护用户敏感信息的场景，而 Token 适用于状态无关的身份验证和授权。

Token 状态无关性解析：在传统的基于会话的认证方式中，服务器需要在后端保存用户的会话状态，通过 Session ID 进行会话的管理。而 Token 机制不需要在服务器上保存任何关于用户的状态信息，只需要在登录成功时，服务器端通过某种算法生成一个唯一的 Token 值，之后再将此 Token 发送给客户端存储（存储在 localStorage 或 sessionStorage 中），注意此时服务端是不存储这个 Token 值的，服务器端只进行效验而不保存此 Token，这就叫“状态无关性”。这样就可以减轻服务器存储和管理会话状态的负担，所以它比较适用于大型系统和分布式系统。

具体来说，Cookie、Session 和 Token 的区别主要有以下几点区别：

存储位置不同：Cookie 存储在客户端，即浏览器中的文本文件，通过在 HTTP 头中传递给服务器来进行通信；Session 是服务器端的存储方式，通常存储在服务器的内存或数据库中；Token 也是存储在客户端，但是通常以加密的方式存储在客户端的 localStorage 或 sessionStorage 中。
数据安全性不同：Cookie 存储在客户端，可能会被窃取或篡改，因此对敏感信息的存储需要进行加密处理；Session 存储在服务器端，通过一个 Session ID 在客户端和服务器之间进行关联，可以避免敏感数据直接暴露；Token 通常使用加密算法生成，有效期较短且单向不可逆，可以提供较高的安全性。
跨域支持不同：为了防止安全事故，因此 Cookie 是不支持跨域传输的，也就是不同域名下的 Cookie 是不能相互访问的；而 Session 机制通常是通过 Cookie 来保存 Session ID 的，因此 Session ID 默认情况下也是不支持跨域的；但 Token 可以轻松实现跨域，因为 Token 是存储在客户端的 localStorage 或者作为请求头的一部分发送到服务器的，所以不同的域名 Token 信息传输通常是不受影响的。
状态管理不同：Cookie 是应用程序通过在客户端存储临时数据，用于实现状态管理的一种机制；Session 是服务器端记录用户状态的方式，服务器会为每个会话分配一个唯一的 Session ID，并将其与用户状态相关联；Token 是一种用于认证和授权的一种机制，通常表示用户的身份信息和权限信息。

## 2.Cookie 和 Session 有什么关系？

准确来说 Cookie 的实现和 Session 是没有任何关系的，但 Session 的实现需要借助于 Cookie。

Session 机制的实现流程如下：

会话创建：通常情况下，当用户登录成功后，服务器会为该用户创建一个新的会话。在创建会话过程中，服务器会为该会话生成一个唯一的标识符，通常称为 Session ID。
Session ID 传递：服务器将生成的 Session ID 通过响应的方式发送给客户端，使用 SetCookie 命令，将用户的 Session ID 保存在 Cookie 中，通常是一个名为 JSESSIONID 的 Cookie。
Session 数据存储：在服务器端，Session 数据会被存储在一个能够关联 Session ID 的数据结构中（例如内存、数据库或者文件存储等）。常用的方式是将 Session ID 作为键，与对应的 Session 用户身份数据进行关联。
Session ID 验证与检索：当用户发送一个新的请求时，客户端会将之前存储的 Session ID 携带在请求的 Cookie 或请求头中发送给服务器。服务器会根据 Session ID 找到对应的 Session 数据，从而获得用户的状态信息。
Session 数据使用：服务器在获取到 Session 数据后，可以根据具体需求读取、修改或删除其中保存的状态信息。服务器可以通过 Session 来管理用户的登录状态、购物车内容、用户配置等。
Session 过期与销毁：Session 有一个有效期限，一般通过设置一个固定的时间，或者在一定时间内没有用户活动时会将 Session 标记为过期。当 Session 过期时，服务器会销毁对应的 Session 数据，释放内存或其他资源。
所以默认情况下，Session 是借助 Cookie 来完成身份标识的传递的，这样服务器端才能根据 Session ID 和保存的会话信息进行关联，用于找到某个具体登录的用户，所以说：默认情况下，Session 机制是依赖 Cookie 实现的。

## 3.禁用 Cookie 之后 Session 还能用吗？

通过上文我们知道，默认情况下 Session 机制是依赖 Cookie 实现的，那么是不是禁用了 Cookie 之后，Session 机制也就无法使用了呢？其实不然。

除了默认情况下，我们可以使用 Cookie 来传递 Session ID 之外，我们可以通过一些特殊的手段来自行传递 Session ID，以此来摆脱禁用 Cookie 之后 Session 无法使用的情况，例如以下两种实现手段：

URL Rewriting：可以在每个请求的 URL 中附加 Session ID 参数。服务器在接收到请求时，解析 URL 中的 Session ID，并与对应的 Session 数据进行关联。这种方式适用于没有禁用地址栏中的参数传递的情况。
隐藏表单字段：可以将 Session ID 作为隐藏表单字段的方式传递给服务器。当用户提交表单时，Session ID 将随着表单数据一起发送给服务器，服务器据此建立与当前会话的关联。
通过以上手段都可以将 Session ID 传递到服务器端（虽然麻烦点），然后在服务器端，我们再对以上传递的 Session ID 进行获取和映射，这样就手动完成了传递和匹配登录用户的工作了，Session 机制也得已继续使用了。

## 小结

Cookie、Session 和 Token 通常都是用来保存用户登录信息的技术，但三者的区别很大：Cookie 适用于简单的状态管理，Session 适用于需要保护用户敏感信息的场景，而 Token 适用于状态无关的身份验证和授权。默认情况下 Session 使用了 Cookie 机制来传递 Session ID，但在禁用 Cookie 的情况下，使用特殊的手段依然可以传递 Session ID，依然可以继续使用 Session 机制。而 Token 是不在服务器端保存会话信息的，因此更适用于大型项目和分布式项目。
