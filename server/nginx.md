[TOC]

**centos7**



正向代理：代理客户端，与客户端在同一个局域网，隐藏客户端真实IP

反向代理：代理服务端，与服务端在同一个局域网，隐藏服务端真实IP



# 源码安装

```bash
# 安装gcc，输入gcc -v 查询版本信息,看系统是否已经安装
yum install gcc
# 安装pcre
yum install pcre-devel -y
# 安装zlib
yum install zlib zlib-devel -y
# 安装openssl，如需支持ssl,才需安装openssl
yum install openssl openssl-devel -y
# 安装wget
yum install wget
# 下载nginx源码包
wget https://nginx.org/download/nginx-1.12.2.tar.gz
tar -zxvf nginx-1.12.2.tar.gz
rm -rf nginx-1.12.2.tar.gz
# 安装nginx
cd nginx-1.12.2
./configure
make
make install
```

# 启动命令

```bash
# 测试配置文件
/usr/local/nginx/sbin/nginx -t
# 启动
/usr/local/nginx/sbin/nginx
# 停止
/usr/local/nginx/sbin/nginx -s stop # 或者是 nginx -s quit
# 重新加载配置
/usr/local/nginx/sbin/nginx -s reload
```



`restart.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  $1$(tput sgr0)"
}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

bash ${shell_home}/check.sh
bash ${shell_home}/kill.sh
bash ${shell_home}/start.sh
bash ${shell_home}/check.sh

# --------------------------------------------------------------------
print "end ${shell}\n"
```

`check.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m    $1$(tput sgr0)"
}
cd ${shell_home}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

app_name="nginx.*process"

print "ps -ef | grep -v 'grep' | grep --color ${app_name}"
ps -ef | grep -v 'grep' | grep --color ${app_name}
count=$(ps -ef | grep -v 'grep' | grep --color ${app_name} | wc -l)

# --------------------------------------------------------------------
print "end ${shell}: count=${count}\n"
exit ${count}
```

`start.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m    $1$(tput sgr0)"
}
cd ${shell_home}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

/usr/local/nginx/sbin/nginx

# --------------------------------------------------------------------
print "end ${shell}\n"
```



`kill.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m    $1$(tput sgr0)"
}
cd ${shell_home}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

app_name="nginx.*process"

print "ps -ef | grep -v 'grep' | grep --color ${app_name} | awk '{print \$2}' | xargs -I {} kill -9 {}"
ps -ef | grep -v 'grep' | grep --color ${app_name} | awk '{print $2}' | xargs -I {} kill -9 {}

# --------------------------------------------------------------------
print "end ${shell}\n"
```



# 开放端口

```bash
firewall-cmd --permanent --zone=public --add-port=8090/tcp
firewall-cmd --permanent --zone=public --remove-port=8080/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
```

# 配置

## 简单示例

```
    server {
        listen       8090;
        server_name  192.168.1.104;
        location / {
            proxy_pass http://192.168.1.103:8080/;
        }
    }
```

关闭8080端口后，访问<http://192.168.1.103:8080>失败，访问<http://192.168.1.104:8090/>正常

## 解决302后IP不正确问题

```
    server {
        listen       192.168.1.104;
        server_name  localhost;
        location /order/ {
            proxy_pass http://192.168.1.103:8080/order/;
            proxy_redirect http://192.168.1.104:8080/ http://$host:$server_port/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Real-PORT $remote_port;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
```

