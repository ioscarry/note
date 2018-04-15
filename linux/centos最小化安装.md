# 安装

[http://www.centos.org](http://www.centos.org/) 中下载`Minimal ISO`

安装到VMware

# 网络设置

使用root账号登录  

用`nmtui`命令进入 Network Manager  

选择`Edit a connection`  

选择`Edit`进入DHCP配置  

选择`IPv4 CONFIGURATION`为`Automatic`，并且勾选`Automatically connect`选项  

最后返回命令行，输入: `service network restart`  

测试：`ping baidu.com`  

查看IP： `ip addr show ens33` (ens33上面配置时出现的对应网卡名)  

#  配置yum源为阿里源  

```shell
# 安装base reop源
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
# 安装epel repo源
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
# curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-5.repo
# 清理缓存
yum clean all
# 重新生成缓存
yum makecache
```

# 创建用户组与用户

```shell
groupadd user
# 使用-p参数指定密码，是不行的，需要使用passwd命令设置密码
useradd -m -g user chencye
passwd chencye
```

最开始使用useradd的-p参数指定密码，一直登录不了，xshell报`ssh服务器拒绝了密码`

root使用`passwd`指定为新用户指定新密码才正常登录

# 配置别名与提示符

`vi ~/.bashrc`

```shell
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1="\[\e[32;1m\][\u@\h \w]$\[\e[m\]"
export PS1

export JAVA_HOME="/home/chencye/jdk/jdk1.8.0_151"
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib

export TOMCAT_HOME="/home/chencye/tomcat/apache-tomcat-8.5.24"

alias rm="~/.local/saferm.sh"
alias l='ls -alh --color=auto --time-style="+%F %H:%M:%S"'
alias ll='ls -lh --color=auto --time-style="+%F %H:%M:%S"'
alias date='date "+%F %H:%M:%S"'
alias grep='grep --color'

alias 1="cat /home/chencye/1.sh"
alias h="cat /home/chencye/help.txt"

```

# 配置定时器

`crontab -e`

```shell
# 分 时 日 月 星期(0或7表示星期天) 命令

# clean trash every sunday
0 0 * * 0 rm -rf /home/chencye/Trash

```



# vi编辑器配置

```shell
echo "syntax on" >> ~/.vimrc
echo "set number" >> ~/.vimrc
echo "set tabstop=4" >> ~/.vimrc
echo "set expandtab" >> ~/.vimrc
```

