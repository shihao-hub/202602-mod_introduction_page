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
