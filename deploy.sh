#!/bin/bash

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  更多物品介绍页 - Linux 部署脚本${NC}"
echo -e "${GREEN}======================================${NC}"

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}请使用 sudo 运行此脚本${NC}"
    exit 1
fi

# 获取部署路径
read -p "请输入部署路径 (默认: /var/www/html/mod_intro): " DEPLOY_PATH
DEPLOY_PATH=${DEPLOY_PATH:-/var/www/html/mod_intro}

# 创建目录
echo -e "${YELLOW}创建部署目录...${NC}"
mkdir -p "$DEPLOY_PATH"

# 复制文件
echo -e "${YELLOW}复制项目文件...${NC}"
cp -r . "$DEPLOY_PATH/"
chown -R www-data:www-data "$DEPLOY_PATH"
chmod -R 755 "$DEPLOY_PATH"

# 询问使用哪种方式部署
echo ""
echo "请选择部署方式:"
echo "1) Nginx (推荐)"
echo "2) Python HTTP Server"
echo "3) Node.js http-server"
read -p "请输入选项 (1-3): " choice

case $choice in
    1)
        echo -e "${YELLOW}配置 Nginx...${NC}"
        apt update
        apt install -y nginx

        # 创建 Nginx 配置
        cat > /etc/nginx/sites-available/mod_intro << 'EOF'
server {
    listen 80;
    server_name _;

    root /var/www/html/mod_intro;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    location ~* \.(json|js|css)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

        ln -sf /etc/nginx/sites-available/mod_intro /etc/nginx/sites-enabled/
        rm -f /etc/nginx/sites-enabled/default

        nginx -t
        systemctl restart nginx
        systemctl enable nginx

        # 安装防火墙规则
        if command -v ufw &> /dev/null; then
            ufw allow 'Nginx Full'
        fi

        echo -e "${GREEN}✓ Nginx 部署完成！${NC}"
        echo -e "${GREEN}访问地址: http://$(hostname -I | awk '{print $1}')${NC}"
        ;;

    2)
        echo -e "${YELLOW}配置 Python HTTP Server...${NC}"
        apt update
        apt install -y python3 supervisor

        # 创建 supervisor 配置
        cat > /etc/supervisor/conf.d/mod_intro.conf << EOF
[program:mod_intro]
command=/usr/bin/python3 -m http.server 8000
directory=$DEPLOY_PATH
autostart=true
autorestart=true
user=www-data
EOF

        supervisorctl reread
        supervisorctl update
        supervisorctl start mod_intro

        # 安装防火墙规则
        if command -v ufw &> /dev/null; then
            ufw allow 8000/tcp
        fi

        echo -e "${GREEN}✓ Python HTTP Server 部署完成！${NC}"
        echo -e "${GREEN}访问地址: http://$(hostname -I | awk '{print $1}'):8000${NC}"
        ;;

    3)
        echo -e "${YELLOW}配置 Node.js http-server...${NC}"
        apt update
        apt install -y nodejs npm
        npm install -g http-server

        # 创建 systemd 服务
        cat > /etc/systemd/system/mod_intro.service << EOF
[Unit]
Description=More Items Introduction Page
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=$DEPLOY_PATH
ExecStart=/usr/bin/node /usr/local/bin/http-server . -p 8000
Restart=always

[Install]
WantedBy=multi-user.target
EOF

        systemctl daemon-reload
        systemctl enable mod_intro
        systemctl start mod_intro

        # 安装防火墙规则
        if command -v ufw &> /dev/null; then
            ufw allow 8000/tcp
        fi

        echo -e "${GREEN}✓ Node.js http-server 部署完成！${NC}"
        echo -e "${GREEN}访问地址: http://$(hostname -I | awk '{print $1}'):8000${NC}"
        ;;

    *)
        echo -e "${RED}无效选项${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}  部署完成！${NC}"
echo -e "${GREEN}======================================${NC}"
echo -e "部署路径: ${YELLOW}$DEPLOY_PATH${NC}"
echo -e "管理命令:"
echo -e "  Nginx: sudo systemctl {start|stop|restart|status} nginx"
echo -e "  Python: sudo supervisorctl {start|stop|restart|status} mod_intro"
echo -e "  Node.js: sudo systemctl {start|stop|restart|status} mod_intro"
