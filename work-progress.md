# CovScript 网站重设计 — 工作计划与实施进度

## 设计方向

以 **rust-lang.org** 为主要参考（大胆品牌表达、社区优先、强烈的明暗对比），吸收 python.org 和 go.dev 的内容组织方式。

### 配色方案（在现有青色基调上进化）

| Token | 旧值 | 新值 | 说明 |
|---|---|---|---|
| `--color-primary` | `#12b7a8` | `#00C4B4` | 电光青 |
| `--color-primary-hover` | `#087f74` | `#00A698` | 悬停态 |
| `--color-primary-deep` | `#0e8077` | `#06716A` | 深青 |
| `--color-accent` | `#ef7b4a` | `#FF5C35` | 活力珊瑚橙 |
| `--color-dark-bg` | — | `#081018` | 深色区块背景 |
| `--color-dark-surface` | — | `#101D2B` | 深色卡片 |
| `--color-code-bg` | — | `#060E18` | 代码块背景 |
| `--color-bg` | `#f7faf9` | `#FAFCFB` | 浅色背景 |
| `--color-text` | `#102a43` | `#0A1929` | 正文色 |

### 区块节奏（明暗交替）

```
Hero(深色) → CodeShowcase(深色) → Features(浅色) → InstallCTA(浅色) → Playground(深色) → Downloads(浅色) → CommunityPreview(深色) → Footer(深色)
```

### 页面结构（Hash 路由，6 个页面）

| Hash 路由 | 视图 | 内容 |
|---|---|---|
| `/#/` | HomePage.vue | Hero + CodeShowcase + Features + InstallCTA + Playground + Downloads + CommunityPreview |
| `/#/playground` | PlaygroundPage.vue | 全屏在线试用（带示例侧边栏） |
| `/#/download` | DownloadPage.vue | 平台下载 + 安装步骤 + 源码构建 |
| `/#/docs` | DocsPage.vue | 文档门户（6 张卡片 + 快速浏览 + 学习资源） |
| `/#/community` | CommunityPage.vue | 贡献指南 + 社区渠道 + 行为准则 |
| `/#/blog` | BlogPage.vue | 博客列表（静态数据） |

---

## 实施进度

### ✅ 阶段 1：基础建设 — 已完成

- [x] `package.json` — 添加了 `vue-router@4` 依赖（尚未 `npm install`）
- [x] `src/router/index.js` — Hash 路由配置，懒加载视图
- [x] `src/styles/variables.css` — CSS 设计令牌（新配色系统）
- [x] `src/components/Layout.vue` — 页面外壳（NavBar + router-view + Footer）
- [x] `src/main.js` — 注册 router 插件
- [x] `src/App.vue` — 重写为纯 Layout 包装

### ✅ 阶段 2：品牌刷新 — 已完成

- [x] `src/styles/main.css` — 引入 variables.css，更新全局样式
- [x] `src/components/HeroSection.vue` — 深色背景、电光青粒子、渐变标题、版本号徽章
- [x] `src/components/FeaturesSection.vue` — 渐变发光悬停、圆角、新配色
- [x] `src/components/PlaygroundSection.vue` — 深色面板配色更新
- [x] `src/components/QuickStartSection.vue` — 精简 + 链接到下载页
- [x] `src/components/FooterSection.vue` — 6px 珊瑚橙顶边、多列站点地图

### ✅ 阶段 3：导航与页脚 — 已完成

- [x] `src/components/NavBar.vue` — router-link 替换锚点、激活态下划线、"立即体验" CTA 按钮、移动端适配
- [x] `src/components/FooterSection.vue` — 三列布局（学习/社区/更多）

### ✅ 阶段 4：首页新组件 — 已完成

- [x] `src/components/SectionLabel.vue` — 可复用区块标签
- [x] `src/components/CodeBlock.vue` — 带语言标签和复制按钮的代码块
- [x] `src/components/DownloadCard.vue` — 可复用下载卡片
- [x] `src/components/CodeShowcase.vue` — 三标签代码展示（Hello World / Fibonacci / Async）
- [x] `src/components/InstallCTA.vue` — OS 标签选择 + 安装命令复制
- [x] `src/components/CommunityPreview.vue` — 统计数据 + 社区 CTA
- [x] `src/components/PageHero.vue` — 可复用内页横幅（渐变标题 + 强调线）

### ✅ 阶段 5：新页面 — 已完成

- [x] `src/views/HomePage.vue` — 组装全部首页区块
- [x] `src/views/PlaygroundPage.vue` — 全屏布局 + 示例侧边栏
- [x] `src/views/DownloadPage.vue` — OS 标签页 + 安装步骤 + 源码构建
- [x] `src/views/DocsPage.vue` — 文档卡片网格 + 可展开代码示例
- [x] `src/views/CommunityPage.vue` — 贡献步骤 + 渠道卡片 + 行为准则
- [x] `src/views/BlogPage.vue` — 博客列表（当前为空占位）

### ✅ i18n — 已完成

- [x] `src/i18n/index.js` — 所有 6 个页面的中英文内容完整翻译

### ✅ 其他文件

- [x] `index.html` — 更新 theme-color 和 meta description
- [x] `src/data/blog-posts.json` — 博客数据文件（空数组占位）

---

## 🔴 待完成：npm install + 验证

### 你需要做的

所有源代码已经写好了，但 **vue-router** 尚未安装到 `node_modules`。

在 WSL 中执行：

```bash
cd /mnt/c/Users/mikecovlee/work/covscript.org.cn
npm install
npm run dev     # 开发模式验证
npm run build   # 构建验证
```

### 验证清单

1. `npm run dev` — 是否正常启动
2. 浏览 `http://localhost:3000/#/` — 首页所有区块渲染正常
3. 点击导航链接 — 页面切换 + URL hash 变化
4. `/` → `/docs` → `/playground` → `/download` → `/community` → `/blog`
5. Playground 编辑器 — 写代码 → 运行 → 输出正常
6. 语言切换 EN↔ZH — 所有页面翻译正确
7. 移动端 375px / 平板 768px 响应式正常
8. `npm run build` — 无错误，检查 `wwwroot/` 输出

### 需要关注的点

- **QuickStartSection** 中的 `<router-link>` — Vue SFC 中 `<router-link>` 不应在 `scoped style` 外使用。如果样式不生效，可能需要 `:deep()` 包装。
- **PlaygroundSection** 中 `#playground` 的 anchor ID — 如果 playground 是独立页面，该 ID 可以移除或保留（不影响功能）。
- **index.html** 中的 `<script type="module" src="/src/main.js">` 已更新 — 确保 Vite dev server 能正确解析。

### 文件总数

| 类型 | 数量 |
|---|---|
| 新增文件 | 18 |
| 修改文件 | 11 |
| 删除文件 | 0 |

### 关键新增文件路径

```
src/router/index.js
src/styles/variables.css
src/components/Layout.vue
src/components/PageHero.vue
src/components/CodeBlock.vue
src/components/SectionLabel.vue
src/components/DownloadCard.vue
src/components/CodeShowcase.vue
src/components/InstallCTA.vue
src/components/CommunityPreview.vue
src/views/HomePage.vue
src/views/PlaygroundPage.vue
src/views/DownloadPage.vue
src/views/DocsPage.vue
src/views/CommunityPage.vue
src/views/BlogPage.vue
src/data/blog-posts.json
```

### 关键修改文件路径

```
package.json          — + vue-router@4
index.html            — theme-color, meta
src/main.js           — app.use(router)
src/App.vue           — 重写为 Layout 外壳
src/styles/main.css   — 新调色板，引入 variables.css
src/components/NavBar.vue
src/components/HeroSection.vue
src/components/FeaturesSection.vue
src/components/PlaygroundSection.vue
src/components/QuickStartSection.vue
src/components/FooterSection.vue
src/i18n/index.js
```
