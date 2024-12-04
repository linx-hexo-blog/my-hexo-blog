---
title: VueRouter路由跳转有哪几种方式？
date: {{ date }}
categories: 
- Vue2
tags:
- 前端
- Vue2
---



在 Vue 2 中使用 Vue Router 进行路由跳转的方式有多种。以下是几种常见的跳转方式：

### 1. **使用 `<router-link>` 组件**
`<router-link>` 是 Vue Router 提供的一个内置组件，用于创建导航链接。点击链接时会触发路由跳转。

#### 示例：
```vue
<template>
  <div>
    <!-- 跳转到 /home -->
    <router-link to="/home">Go to Home</router-link>

    <!-- 跳转到 /about -->
    <router-link :to="{ name: 'about' }">Go to About</router-link>

    <!-- 使用动态参数 -->
    <router-link :to="{ name: 'user', params: { userId: 123 }}">Go to User 123</router-link>
  </div>
</template>
```

### 2. **编程式导航（使用 `$router` 实例）**
编程式导航是指通过 JavaScript 代码来触发路由跳转。Vue Router 提供了 `$router` 实例来实现这一功能。

#### 2.1 使用 `this.$router.push()`
`push` 方法将一个新的路由入栈，表示跳转到新页面。

##### 示例：
```javascript
this.$router.push('/home');
// 或者
this.$router.push({ name: 'about' });
// 或者使用动态参数
this.$router.push({ name: 'user', params: { userId: 123 } });
```

#### 2.2 使用 `this.$router.replace()`
`replace` 方法与 `push` 类似，但不会向历史记录中添加新记录，而是替换当前的记录。

##### 示例：
```javascript
this.$router.replace('/home');
// 或者
this.$router.replace({ name: 'about' });
// 或者使用动态参数
this.$router.replace({ name: 'user', params: { userId: 123 } });
```

#### 2.3 使用 `this.$router.go()`
`go` 方法允许你在浏览器的历史记录中前进或后退。

##### 示例：
```javascript
this.$router.go(1); // 前进一页
this.$router.go(-1); // 后退一页
```

### 3. **在模板中使用 `v-bind` 动态绑定 `to` 属性**
通过 `v-bind` 动态绑定 `to` 属性，可以根据不同的条件来跳转到不同的路由。

#### 示例：
```vue
<template>
  <div>
    <router-link :to="dynamicRoute">Go to Dynamic Route</router-link>
  </div>
</template>

<script>
export default {
  data() {
    return {
      userId: 123
    }
  },
  computed: {
    dynamicRoute() {
      return { name: 'user', params: { userId: this.userId } };
    }
  }
}
</script>
```

### 4. **路由重定向**
你可以通过配置路由规则来进行重定向，当用户访问某个路径时，自动跳转到另一个路径。

#### 示例：
```javascript
const routes = [
  { path: '/', redirect: '/home' },
  { path: '/home', component: Home },
  { path: '/about', component: About }
];

const router = new VueRouter({
  routes
});
```

在这个例子中，当用户访问 `/` 路径时，会自动重定向到 `/home`。

### 5. **使用导航守卫**
导航守卫可以在路由跳转前或跳转后执行一些逻辑，甚至可以控制是否允许跳转。

#### 示例：
```javascript
router.beforeEach((to, from, next) => {
  if (to.path === '/protected') {
    if (isAuthenticated()) {
      next(); // 允许跳转
    } else {
      next('/login'); // 跳转到登录页
    }
  } else {
    next(); // 总是允许跳转
  }
});
```

### 6. **直接修改 URL**
直接在浏览器的地址栏中输入新的 URL，或者使用 JavaScript 修改 `window.location.href`，也会触发路由跳转，不过这属于浏览器的默认行为，不推荐使用在 Vue 项目中控制导航。

#### 示例：
```javascript
window.location.href = '/home';
```

这种方式会导致页面刷新，不像 Vue Router 的跳转是无刷新操作。

---

这些方法都可以用来在 Vue 2 应用中实现路由跳转。根据你的需求和使用场景，选择合适的方式进行路由控制。

