# centos7中安装ftp服务

配置yum镜像  
<http://mirrors.aliyun.com/help/centos>

0、搜索vsftpd  
`yum search vsftpd`  

1、安装vsftpd，需要root身份  
`yum install -y vsftpd`  

2、编辑ftp配置文件  
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

3、开启21端口与pasv的端口  
`firewall-cmd --permanent --zone=public --add-port=21/tcp`  
`firewall-cmd --permanent --zone=public --add-port=6000-7000/tcp`  
`firewall-cmd --reload`  

或直接修改配置：`cat /etc/firewalld/zones/public.xml`  

当前开启的端口：`firewall-cmd --zone=public --list-ports`  

4、重启及开机启动  
`systemctl restart vsftpd`  
`systemctl enable vsftpd` 

windows7的CMD的FTP命令采用主动模式连接，dir与ls命令使用不了，可以使用图形界面的软件，如WinSCP进行FTP连接  
