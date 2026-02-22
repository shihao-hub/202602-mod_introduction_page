# Linux 服务器部署指南

本文档记录如何将项目部署到 Linux Ubuntu 服务器上。

## 服务器信息

- **IP 地址**: 124.223.114.33
- **登录账号**: ubuntu（非 root 账号，需使用 sudo）
- **已验证部署方式**: 自动化部署脚本（方式一）

## 部署方式一：自动化脚本部署（已验证✓）

这是最简单的方式，使用项目自带的 `deploy.sh` 脚本进行自动化部署。

### 前提条件

- ubuntu 账号具有 sudo 权限
- 服务器可以访问外网（用于安装软件包）

### 步骤

```bash
# 1. 上传项目到服务器
scp -r . ubuntu@124.223.114.33:~/mod_introduction_page

# 2. SSH 登录服务器
ssh ubuntu@124.223.114.33

# 3. 进入项目目录
cd ~/mod_introduction_page

# 4. 运行部署脚本
sudo bash deploy.sh
```

### 脚本执行流程

部署脚本会引导你完成以下步骤：

1. **检查权限**: 要求使用 sudo 运行
2. **获取部署路径**: 默认为 `/var/www/html/mod_intro`
3. **创建部署目录**: 自动创建并设置权限
4. **复制项目文件**: 复制所有文件到部署目录
5. **选择部署方式**:
   - 1) Nginx（推荐）
   - 2) Python HTTP Server
   - 3) Node.js http-server

### 已验证的 Nginx 部署

选择选项 1 后，脚本会自动：

```bash
# 安装 Nginx
apt update && apt install -y nginx

# 创建 Nginx 配置文件
cat > /etc/nginx/sites-available/mod_intro

# 启用站点
ln -sf /etc/nginx/sites-available/mod_intro /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 测试并重启服务
nginx -t
systemctl restart nginx
systemctl enable nginx

# 配置防火墙
ufw allow 'Nginx Full'
```

### 访问地址

部署完成后访问：
```
http://124.223.114.33
```

### 实际部署记录

**日期**: 2026-02-22
**操作人**: ubuntu
**服务器**: Ubuntu 20.04.6 LTS

#### 本地操作

```powershell
# 使用 scp 上传项目到服务器
PS D:\Users\29580\ProgrammerAdvancedProjects\mod_introduction_page> scp -r . ubuntu@124.223.114.33:~/mod_introduction_page
```

上传成功传输了以下文件：
- 项目文件：`index.html`, `README.md`
- 数据文件：`data/config.json`, `data/items.json`, `data/qa.json`, `data/updates.json`
- 部署脚本：`deploy.sh`, `deploy-nginx.conf`, `deploy-systemd.service`
- Git 相关文件：`.git/`, `.gitignore`

#### 服务器操作

```bash
# SSH 连接服务器
ssh ubuntu@124.223.114.33

# 进入项目目录
cd ~/mod_introduction_page

# 运行部署脚本（使用 sudo）
sudo bash deploy.sh
```

#### 部署脚本执行流程

1. **部署路径选择**：使用默认路径 `/var/www/html/mod_intro`
2. **部署方式选择**：选择 `1) Nginx (推荐)`
3. **自动安装 Nginx**：
   - 更新软件包列表
   - 安装 nginx 及相关依赖：
     - libgd3
     - libnginx-mod-http-image-filter
     - libnginx-mod-http-xslt-filter
     - libnginx-mod-mail
     - libnginx-mod-stream
     - nginx-common
     - nginx-core
4. **配置 Nginx**：
   - 创建站点配置文件
   - 启用站点配置
   - 移除默认站点
   - 测试配置文件（语法检查通过）
   - 重启并启用 Nginx 服务
5. **配置防火墙**：
   - 允许 Nginx Full 规则

#### 部署结果

```
✓ Nginx 部署完成！
访问地址: http://10.0.12.4

======================================
  部署完成！
======================================
部署路径: /var/www/html/mod_intro
管理命令:
  Nginx: sudo systemctl {start|stop|restart|status} nginx
  Python: sudo supervisorctl {start|stop|restart|status} mod_intro
  Node.js: sudo systemctl {start|stop|restart|status} mod_intro
```

#### 服务器状态信息

部署时的服务器状态：
- 系统负载: 0.01
- 进程数: 177
- 磁盘使用: 29.9% of 39.27GB
- 内存使用: 50%
- 交换分区使用: 0%
- 内网 IP: 10.0.12.4

#### 注意事项

1. 服务器使用腾讯云镜像源 `mirrors.tencentyun.com`
2. Ubuntu 20.04 LTS 已于 2025年5月31日结束标准支持
3. 系统提示可升级至 Ubuntu 22.04.5 LTS
4. 部署成功后可通过内网 IP (10.0.12.4) 或公网 IP (124.223.114.33) 访问

## 部署方式二：手动 Nginx 部署（未测试）

如果需要更细粒度的控制，可以手动部署。

### 步骤

```bash
# 1. 创建部署目录
sudo mkdir -p /var/www/html/mod_intro

# 2. 复制文件
sudo cp -r ~/mod_introduction_page/. /var/www/html/mod_intro/

# 3. 设置权限
sudo chown -R www-data:www-data /var/www/html/mod_intro
sudo chmod -R 755 /var/www/html/mod_intro

# 4. 安装 Nginx
sudo apt update
sudo apt install -y nginx

# 5. 使用项目提供的 Nginx 配置
sudo cp ~/mod_introduction_page/deploy-nginx.conf /etc/nginx/sites-available/mod_intro
sudo nano /etc/nginx/sites-available/mod_intro  # 修改 server_name 和路径

# 6. 启用站点
sudo ln -sf /etc/nginx/sites-available/mod_intro /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 7. 测试并重启
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# 8. 配置防火墙
sudo ufw allow 'Nginx Full'
```

## 部署方式三：Python/Node.js 快速部署（未测试）

适用于临时测试或不需要 Nginx 的场景。

### Python HTTP Server

```bash
sudo apt install -y python3
cd /var/www/html/mod_intro
sudo python3 -m http.server 8000
# 访问 http://124.223.114.33:8000
```

### Node.js http-server

```bash
sudo apt install -y nodejs npm
sudo npm install -g http-server
cd /var/www/html/mod_intro
sudo http-server . -p 8000
# 访问 http://124.223.114.33:8000
```

## 常用管理命令

### Nginx 管理

```bash
# 查看状态
sudo systemctl status nginx

# 重启服务
sudo systemctl restart nginx

# 测试配置
sudo nginx -t

# 查看日志
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### 防火墙管理

```bash
# 查看状态
sudo ufw status

# 允许 HTTP
sudo ufw allow 80/tcp
sudo ufw allow 'Nginx Full'
```

## 项目文件说明

- `deploy.sh`: 自动化部署脚本（支持三种部署方式）
- `deploy-nginx.conf`: Nginx 配置文件模板
- `deploy-systemd.service`: systemd 服务配置模板（用于 Node.js 方式）

## 部署后检查清单

- [ ] 访问 http://124.223.114.33 可以正常显示页面
- [ ] 静态资源（CSS、JS、JSON）加载正常
- [ ] Nginx 服务已设置为开机自启
- [ ] 防火墙规则已正确配置

## 故障排查

### 无法访问页面

```bash
# 检查 Nginx 状态
sudo systemctl status nginx

# 检查端口是否监听
sudo netstat -tlnp | grep :80

# 检查防火墙
sudo ufw status
```

### 权限问题

```bash
# 确保文件所有者正确
sudo chown -R www-data:www-data /var/www/html/mod_intro
sudo chmod -R 755 /var/www/html/mod_intro
```

### 配置错误

```bash
# 测试 Nginx 配置
sudo nginx -t

# 查看错误日志
sudo tail -f /var/log/nginx/error.log
```

---

# Git 部署指南（推荐）

相比 scp 手动上传，使用 Git 进行部署更加高效和可控。

## 为什么选择 Git 部署

| 对比项 | SCP 部署 | Git 部署 |
|--------|----------|----------|
| 更新方式 | 手动上传全部文件 | 只传输变更内容 |
| 版本管理 | 无 | 完整的提交历史 |
| 回滚能力 | 困难 | 简单（git reset） |
| 协作支持 | 无 | 支持多人协作 |
| 部署速度 | 慢（上传全部文件） | 快（只传输差异） |

## 初次设置：从 SCP 迁移到 Git

### 前置条件

- 项目代码已推送到 Git 仓库（GitHub/GitLab/Gitee 等）
- 服务器可以访问 Git 仓库

### 步骤一：清理旧部署（可选）

如果你想完全替换现有的部署：

```bash
# SSH 登录服务器
ssh ubuntu@124.223.114.33

# 备份现有部署（可选）
sudo cp -r /var/www/html/mod_intro /var/www/html/mod_intro.backup

# 删除旧部署
sudo rm -rf /var/www/html/mod_intro
```

### 步骤二：安装 Git

```bash
# 在服务器上安装 git
sudo apt update
sudo apt install -y git

# 配置 git 用户信息（可选）
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### 步骤三：克隆项目

```bash
# 进入部署目录
cd /var/www/html

# 克隆项目
# 语法：git clone <仓库地址> <本地目录名>
# 本地目录名可以自定义，与远程仓库名无关
sudo git clone https://github.com/你的用户名/202602-mod_introduction_page.git mod_intro

# 如果使用 SSH 密钥（推荐）
# sudo git clone git@github.com:你的用户名/202602-mod_introduction_page.git mod_intro
```

**说明**：
- 最后的 `mod_intro` 是本地目录名，可以自定义
- 即使远程仓库名是 `202602-mod_introduction_page`，本地目录名仍可以是 `mod_intro`
- 这样部署路径保持为 `/var/www/html/mod_intro`，与文档后续命令一致

**注意**：
- HTTPS 方式：每次 pull 可能需要输入密码
- SSH 方式：需配置 SSH 密钥，免密登录

### 步骤四：设置 SSH 密钥（推荐）

避免每次 pull 都输入密码：

```bash
# 1. 生成 SSH 密钥（如果没有）
ssh-keygen -t ed25519 -C "your-email@example.com"
# 一路回车使用默认设置

# 2. 查看公钥
cat ~/.ssh/id_ed25519.pub

# 3. 将公钥添加到 GitHub/GitLab：
#    GitHub: Settings → SSH and GPG keys → New SSH key
#    粘贴刚才的公钥内容

# 4. 测试连接
ssh -T git@github.com
# 成功会显示：Hi username! You've successfully authenticated...
```

### 步骤五：设置权限

```bash
# 设置文件所有者
sudo chown -R www-data:www-data /var/www/html/mod_intro

# 设置文件权限
sudo chmod -R 755 /var/www/html/mod_intro

# 授予 ubuntu 用户 git pull 权限（无需 sudo）
sudo chown -R ubuntu:www-data /var/www/html/mod_intro
sudo chmod -R 775 /var/www/html/mod_intro
```

### 步骤六：创建一键更新脚本

```bash
# 创建更新脚本
sudo nano /usr/local/bin/update-mod-intro.sh
```

粘贴以下内容：

```bash
#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}开始更新...${NC}"
cd /var/www/html/mod_intro || exit 1

# 拉取最新代码（强制覆盖本地修改）
echo -e "${YELLOW}拉取最新代码...${NC}"
git fetch origin
git reset --hard origin/master

# 检查是否成功
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 更新完成！${NC}"
    echo -e "${GREEN}最新提交: $(git log -1 --pretty=format:'%h - %s')${NC}"
else
    echo -e "${RED}✗ 更新失败！${NC}"
    exit 1
fi
```

**nano 保存退出快捷键**：
- `Ctrl + O` 写入文件，按 Enter 确认
- `Ctrl + X` 退出编辑器

```bash
# 设置脚本权限
sudo chmod +x /usr/local/bin/update-mod-intro.sh

# 测试脚本
update-mod-intro.sh
```

## 日常更新流程

### 本地修改代码

```bash
# 1. 修改代码后提交
git add .
git commit -m "feat: 添加新功能"

# 2. 推送到远程仓库
git push
```

### 服务器更新

```bash
# 方式一：使用一键脚本（推荐）
update-mod-intro.sh

# 方式二：手动更新
ssh ubuntu@124.223.114.33
cd /var/www/html/mod_intro
git pull
```

### 查看更新状态

```bash
# 查看当前分支和提交
cd /var/www/html/mod_intro
git status
git log -1 --oneline

# 查看远程更新
git log origin/master -1 --oneline
```

## 高级操作

### 版本回滚

如果新版本有问题，可以快速回滚：

```bash
# 查看提交历史
git log --oneline -10

# 回滚到指定版本
git reset --hard <commit-hash>

# 强制推送（谨慎使用）
git push -f origin master

# 服务器上拉取回滚后的版本
git pull
```

### 切换分支

```bash
# 查看所有分支
git branch -a

# 切换到其他分支
git checkout develop

# 服务器切换分支
cd /var/www/html/mod_intro
git checkout develop
```

### 查看文件变更

```bash
# 查看本地修改
git diff

# 查看已暂存的修改
git diff --staged

# 查看文件修改历史
git log --follow -p filename
```

## 常见问题

### git pull 提示权限错误

```bash
# 问题：error: cannot open .git/FETCH_HEAD: Permission denied

# 解决：修复 .git 目录权限
sudo chown -R ubuntu:www-data /var/www/html/mod_intro/.git
sudo chmod -R 775 /var/www/html/mod_intro/.git
```

### git pull 提示冲突

```bash
# 如果服务器上有本地修改（不推荐），会提示冲突

# 解决方案一：放弃本地修改（推荐）
git reset --hard origin/master

# 解决方案二：暂存本地修改
git stash
git pull
git stash pop
```

### HTTPS 方式需要密码

```bash
# 使用 SSH 方式替代，修改远程仓库地址
cd /var/www/html/mod_intro
git remote set-url origin git@github.com:你的用户名/mod_introduction_page.git
```

### 服务器无法访问 GitHub

```bash
# 如果网络受限，可以使用 Gitee（国内镜像）

# 1. 在 Gitee 导入 GitHub 仓库
# 2. 修改远程仓库地址
git remote set-url origin https://gitee.com/你的用户名/mod_introduction_page.git
```

## 部署脚本对比

| 操作 | SCP 方式 | Git 方式 |
|------|----------|----------|
| 初次部署 | `scp + deploy.sh` | `git clone` |
| 更新代码 | `scp -r . server:/path` | `git pull` |
| 回滚版本 | 手动恢复备份 | `git reset --hard` |
| 查看历史 | 无 | `git log` |
| 切换分支 | 不支持 | `git checkout` |

## 最佳实践

1. **使用 SSH 密钥**：避免每次输入密码
2. **保护敏感信息**：不要将 `.env` 等文件提交到仓库
3. **使用 .gitignore**：排除不需要部署的文件
4. **定期备份**：虽然 Git 有历史，但重要数据仍需备份
5. **测试后再推送**：本地验证通过后再推送到服务器

## 总结

Git 部署的核心优势：

- **快速**：只传输变更的文件
- **安全**：有完整的版本历史，出错可回滚
- **简单**：一条命令完成更新
- **灵活**：支持多分支、多环境部署

推荐工作流程：

```
本地开发 → git commit → git push → 服务器 git pull
```
