# 更多物品介绍页

饥荒联机版《更多物品》模组的官方介绍页面，提供最新最全的物品信息展示。

## 功能特性

- **物品展示** - 卡片式展示所有物品的详细信息
- **搜索功能** - 支持按物品名称和代码搜索
- **主题筛选** - 按袋子、武器、建筑、装备、食物、工具等主题分类
- **响应式设计** - 支持桌面端和移动端访问
- **深色主题** - 精美的深色界面设计
- **交互动画** - 流畅的卡片悬停和页面切换动画
- **动态数据加载** - 从 JSON 文件异步加载数据

## 页面结构

- **道具介绍** - 展示所有物品的详细信息
- **模组说明** - 模组功能介绍
- **常见问题** - FAQ 常见问题解答
- **更新日志** - 模组版本更新记录
- **作者留言** - 作者寄语

## 项目结构

```
mod_introduction_page/
├── index.html          # 主页面文件
├── data/               # 数据目录
│   ├── config.json     # 配置数据（主题、颜色、文本）
│   ├── items.json      # 物品数据
│   ├── updates.json    # 更新日志
│   └── qa.json         # 常见问题
├── README.md           # 项目说明
└── .gitignore          # Git 忽略文件
```

## 使用方法

### 本地开发

由于页面使用 `fetch` API 异步加载数据，需要通过 HTTP 服务器访问：

#### Python 方式

```bash
# Python 3
python -m http.server 8000

# Python 2
python -m SimpleHTTPServer 8000
```

#### Node.js 方式

```bash
# 使用 npx (无需安装)
npx http-server -p 8000

# 或安装后使用
npm install -g http-server
http-server -p 8000
```

#### VS Code 方式

安装 "Live Server" 扩展，右键 `index.html` 选择 "Open with Live Server"。

然后在浏览器中访问 `http://localhost:8000`

### 直接打开

直接双击 `index.html` 文件也可以打开，但部分浏览器可能会因 CORS 限制无法加载数据。

## 数据文件说明

### data/config.json

包含主题分类、颜色风格、作者留言和模组说明等配置信息。

### data/items.json

包含所有物品的详细数据，每个物品包含：
- `id`: 物品ID
- `name`: 物品名称
- `code`: 物品代码
- `theme`: 主题分类
- `themeName`: 主题名称
- `colorIndex`: 颜色索引
- `description`: 描述信息
- `features`: 特性列表

### data/updates.json

包含模组的版本更新日志。

### data/qa.json

包含常见问题和解答。

## 修改数据

只需编辑 `data/` 目录下的 JSON 文件即可，无需修改代码。修改后刷新页面即可看到更新。

## 技术栈

- 纯 HTML/CSS/JavaScript
- 响应式 CSS Grid 布局
- CSS 变量主题系统
- Fetch API 数据加载
- 异步数据渲染

## 版权信息

Copyright © 2019 by Hengzi. All Rights Reserved.
