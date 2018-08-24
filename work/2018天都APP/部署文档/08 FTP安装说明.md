[TOC]

# centos7中安装ftp服务

## 配置yum镜像 
<http://mirrors.aliyun.com/help/centos>

## 安装

```bash
# 查询vsftpd
yum list vsftpd
# 安装
sudo yum install -y vsftpd
# 开机启动
systemctl enable vsftpd
# 启停及状态
systemctl restart vsftpd
systemctl status vsftpd
```

## 配置

`vi /etc/vsftpd/vsftpd.conf` 

```properties
anonymous_enable=NO
# 关闭日志
xferlog_enable=NO

# 配置被动模式
pasv_enable=YES
pasv_min_port=6000
pasv_max_port=7000
```

## 开启端口

```bash
# 开启21端口与被动模式pasv的端口 
firewall-cmd --permanent --zone=public --add-port=21/tcp
firewall-cmd --permanent --zone=public --add-port=6000-7000/tcp
firewall-cmd --reload

# 查看已开启的端口
firewall-cmd --zone=public --list-ports
```

