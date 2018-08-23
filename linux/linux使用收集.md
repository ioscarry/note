[TOC]

**Centos7**

# 命令

```bash
# 查看IP
hostname -I
# 

# 查询正运行的java进程，建议使用jps，使用ps会将tail也显示出来
jps -lvm | grep 'tomcat'
ps -ef | grep -v 'grep' | grep 'tomcat'

# 查看端口是否被占用
netstat -na | grep 8080
# 查看端口被哪个进程占用
lsof -i:8080

# 查看磁盘空间使用情况
df -lh
# 统计当前目录下，所有文件(包括文件夹)大小
du -smh * | sort -r

# 下载文件
curl -o ~/download/jdk.tar.gz http://download.oracle.com/jdk.tar.gz

# 读取输入的内容
read -p 'type yes/no: ' content
# 以空格间隔输入多个值
read -p 'type 2 value: ' v1 v2
echo $(($v1+$v2))

# 查找文件
find . -name "tomcat*"
# 查找并删除
find . -name "*.tmp" -exec rm -rf {} \;
# 查找大文件
find . -size +10M -exec ls -lh {} \;

# yum查询软件版本
yum list docker-ce --showduplicates | sort -r
```

# 解压缩

```bash
# zip 压缩
zip -r tomcat.zip tomcat
# zip 压缩，排除指定文件或文件夹
zip -r tomcat.zip tomcat -x tomcat/logs -x tomcat/work
# zip 不解压，直接查看压缩包中的文件名
zipinfo tomcat.zip
# zip 解压
unzip tomcat.zip
# zip 解压到指定路径
unzip -d bak/ tomcat.zip

# tar 压缩
tar zcvf tomcat.tar.gz tomcat
# tar 压缩，排除指定文件或文件夹
tar zcvf tomcat.tar.gz --exclude=tomcat/logs --exclude=tomcat/work tomcat
# tar 不解压，直接查看压缩包中的文件名
tar ztvf tomcat.tar.gz
# tar 解压
tar zxvf tomcat.tar.gz
# tar 解压到指定路径
mkdir -p tomcat
tar zxvf tomcat.tar.gz -C tomcat
```

# 内置参数

```bash
$# # 传递给程序的总参数数目
$0 # 当前程序名称，如./test.sh
$n # 表示第几个参数，从$1开始，大于$9的，数字用花括号括起，如${11}
$* # 传递给程序的所有参数组成的字符串
$@ # 以"参数1" "参数2" ...形式保存所有参数
 
$? # 上一个shell命令或程序在shell中退出的情况，若正常退出返回0，否则为1
$$ # 本程序的进程ID号PID，可用于创建临时文件
$! # 上一个命令的PID
```

# 文件类型判断

```bash
#!/bin/bash
# 文件夹判断
dir="test"
if [[ -d ${dir} ]]; then
    rm -rf ${dir}
fi
# 文件判断
file="/file/test.txt"
if [[ -f ${file} ]]; then
    rm -rf ${file}
fi
# 判断是否存在
path="~/test"
[[ -e ${path} ]] && echo "exist" || echo "not exist"
```

#循环遍历

## 一般遍历

```bash
#!/bin/bash
# 1到100的和
sum=0
# for i in $(seq 1 100)
# for i in {1..100}
for ((i=1; i<=100; i++))
do
    sum=$(( ${sum} + ${i} ))
done
echo ${sum}
```

## 文件夹遍历

```bash
#!/bin/bash
# 文件夹遍历
function walkDir() {
    curDir=$1
    # for seeFile in $(ls ${curDir}) # 无相对路径
    for seeFile in ${curDir}/*
    do
        if [[ ! -e ${seeFile} ]]; then
            continue
        fi
        if [[ -d ${seeFile} ]]; then
            walkDir ${seeFile}
        else
            echo "file in ${curDir}: ${seeFile}"
        fi
    done
}

dir="file"
if [[ ! -d ${dir} ]]; then
    exit 1;
fi
walkDir ${dir}
```

## 文件内容遍历

```bash
#!/bin/bash
# 文件内容遍历
file="file/download/upload_test_1.txt"
if [[ ! -f ${file} ]]; then
    exit 1
fi
# for line in `cat ${file}` # 取值的分隔符由$IFS确定，如果输入文本中包括空格或制表符，则不是换行读取
cat ${file} | while read line
do
    echo "${file}: ${line}"
done
```

##  数组遍历

```bash
#!/bin/bash
# 数组遍历
array=(1 2 "a" "b")
# echo "array length: ${#array[*]}"
echo "array length: ${#array[@]}"
# for data in ${array[*]}
for data in ${array[@]}
do
    echo ${data}
done
```

# case

```bash
option="${1}"
case ${option} in
	f | file | -f | -file )
		file="${2}"
		echo "file name is $file"
		;;
	d | dir | -d | -dir )
		dir="${2}"
		echo "dir name is $dir"
		;;
    * )
    	echo "basename ${0} :usage:[-f file ]| [-d  directory]"
		;;
esac
```

#文本处理

##字串匹配

##字串截取与替换

**说明：`$substring`可以是一个正则表达式**  

| 表达式                                | 含义                                       |
| ---------------------------------- | ---------------------------------------- |
| `${#string}`                       | `$string`的长度                             |
|                                    |                                          |
| `${string:index}`                  | 在`$string`中, 从位置`$index(0开始)`开始提取子串      |
| `${string:index:length}`           | 在`$string`中, 从位置`$index(0开始)`开始提取长度为`$length`的子串 |
|                                    |                                          |
| `${string#substring}`              | 从变量`$string`的开头, 删除最短匹配`$substring`的子串   |
| `${string##substring}`             | 从变量`$string`的开头, 删除最长匹配`$substring`的子串   |
| `${string%substring}`              | 从变量`$string`的结尾, 删除最短匹配`$substring`的子串   |
| `${string%%substring}`             | 从变量`$string`的结尾, 删除最长匹配`$substring`的子串   |
|                                    |                                          |
| `${string/substring/replacement}`  | 使用`$replacement`, 来代替第一个匹配的`$substring`  |
| `${string//substring/replacement}` | 使用`$replacement`, 代替所有匹配的`$substring`    |
| `${string/#substring/replacement}` | 如果`$string`的前缀匹配`$substring`, 那么就用`$replacement`来代替匹配到的`$substring` |
| `${string/%substring/replacement}` | 如果`$string`的后缀匹配`$substring`, 那么就用`$replacement`来代替匹配到的`$substring` |

### 示例

```bash
str="aaaa4444bbbb4444aaaa4444bbbb"

echo ${#str} # 28

echo ${str:2} # aa4444bbbb4444aaaa4444bbbb	# 从位置2开始到最后(位置0开始)
echo ${str:2:4} # aa44	# 从位置2开始截取2个字符

echo ${str#*a} # aaa4444bbbb4444aaaa4444bbbb # 删除最短前缀
echo ${str##*a} # 4444bbbb # 删除最长前缀
echo ${str%a*} # aaaa4444bbbb4444aaa # 删除最短后缀
echo ${str%%a*} # 无内容	 # 删除最长后缀
echo ${str%%b*} # aaaa4444	 # 删除最长后缀

echo ${str/b/c} # aaaa4444cbbb4444aaaa4444bbbb  # 替换首个
echo ${str//b/c} # aaaa4444cccc4444aaaa4444cccc # 替换所有
echo ${str/#a/c} # caaa4444bbbb4444aaaa4444bbbb # 前缀替换
echo ${str/#b/c} # aaaa4444bbbb4444aaaa4444bbbb # 前缀替换
echo ${str/%a/c} # aaaa4444bbbb4444aaaa4444bbbb # 后缀替换
echo ${str/%b/c} # aaaa4444bbbb4444aaaa4444bbbc # 后缀替换
```

##文件中匹配替换

```bash
# sed 命令
sed 's/123/456/g' file.txt # 只显示效果，不修改
sed -i 's/123/456/g' file.txt # 直接修改原文件

# vi 编辑器
# 替换
:%s/123/456/g
```

# shell脚本头

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  ---> $1$(tput sgr0)"
}
print "cd ${shell_home}"
cd ${shell_home}
print "begin execute ${shell}"
# export /home/chencye/jdk/jdk1.8.0_131
# export JAVA_OPTS="-server -Xms800m -Xmx800m"
# export JPDA_ADDRESS=7878 # catalina.sh jpda start
# JPDA_SUSPEND=y # 等待客户端连接，tomcat才继续启用，用于调试启动过程
# --------------------------------------------------------------------

```

# FTP

```bash
# 连接
ftp chencye@192.168.1.103
# 先定位远程目录
cd /home/chencye/ftp
# 下载远程目录中的文件
get test.txt

ip="192.168.1.103"
user="chencye"
password="chencye"
remote_dir="/home/chencye/ftp"
file_name="test.txt"
local_dir="/home/chencye/download"
# 自动ftp下载
ftp -n <<!
open ${ip}
user ${user} ${password}
binary
cd ${remote_dir}
lcd ${local_dir}
prompt
get ${file_name}
close
by
!
```

# 软件安装

## yum源及yum命令

```bash
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

yum list gcc    # 列出所指定的软件包
yum list updates   # 列出所有可更新的软件包
yum list installed    # 列出所有已安装的软件包
yum list extras    # 列出所有已安装但不在 Yum Repository 内的软件包
yum info gcc    # 获取指定软件包信息
yum search gcc    # 在源中查找指定软件
yum remove gcc   # 删除指定软件
yum clean all    # 清除缓存目录下的软件包及旧的headers
```

## 安装mysql

<http://blog.csdn.net/superchanon/article/details/8546254/>  
<http://www.cnblogs.com/chencye/p/6642602.html>  

## FTP服务安装

<http://www.cnblogs.com/chencye/p/7067916.html>  

## minimal安装时，配置网络连接

使用root账号登录  

用`nmtui`命令进入 Network Manager  
选择`Edit a connection`  
选择`Edit`进入DHCP配置  
选择`IPv4 CONFIGURATION`为`Automatic`，并且勾选`Automatically connect`选项  
最后返回命令行，输入: `service network restart`  

测试：`ping baidu.com`  

查看IP： `ip addr show ens33` (ens33上面配置时出现的对应网卡名)  

# 系统配置

## 为rm命令配置垃圾箱

<https://github.com/lagerspetz/linux-stuff/blob/master/scripts/saferm.sh>

`alias rm="~/.local/saferm.sh"`

设置定时任务，定时清空垃圾箱

`0 0 * * 0 rm -rfu ~/Trash`


## 配置别名alias与function

```bash
echo "alias l='ls -alh --color=auto --time-style=\"+%F %H:%M:%S\"'" >> ~/.bashrc && source ~/.bashrc
echo "alias ll='ls -lh --color=auto --time-style=\"+%F %H:%M:%S\"'" >> ~/.bashrc && source ~/.bashrc
echo "alias date='date \"+%F %H:%M:%S\"'" >> ~/.bashrc && source ~/.bashrc

# function示例：重置ping命令
# vi ~/.bashrc
function ping {
    local commandName="${FUNCNAME[0]}"
    local params=($@)
    echo "Original command: $commandName ${params[@]}"
    local num=${#params[@]}
    local params_new=()
    for ((i=0; i<$num; i=i+1))
    do
        param=${params[$i]}
        param=${param/"127.0.0.1"/"localhost"} # 替换参数
        params_new[$i]=$param
    done
    echo "new command: $commandName ${params_new[@]}"
    command $commandName ${params_new[@]}
}
function md5 {
    if [[ ! $# -eq 2 ]]; then
        echo -e "\n"
        echo "missing parameter. example:"
        echo "md5 test.txt ee69b061c627ec20991d4259cbcbfed4"
        echo -e "\n"
        return
    fi
    local file="$1"
    local theMd5="$2"
    local fileMd5=`md5sum "$file" | awk '{print $1}'`
    [[ "$fileMd5" = "$theMd5" ]] && echo true || echo false
}
# source ~/.bashrc
```

## vi编辑器配置

```bash
echo "syntax on" >> ~/.vimrc
echo "set number" >> ~/.vimrc
echo "set tabstop=4" >> ~/.vimrc
echo "set expandtab" >> ~/.vimrc
```

## 配置PS1提示符定义

`vi ~/.bashrc`  
`PS1="\[\e[32;1m\][\u@\h \w]$\[\e[m\]"`  
`export PS1`  

`\d`：代表日期，格式为weekday month date，例如："Mon Aug 1"  
`\H`：完整的主机名称。例如：我的机器名称为：fc4.linux，则这个名称就是fc4.linux  
`\h`：仅取主机的第一个名字，如上例，则为fc4，.linux则被省略  
`\t`：显示时间为24小时格式，如：HH：MM：SS  
`\T`：显示时间为12小时格式  
`\A`：显示时间为24小时格式：HH：MM  
`\u`：当前用户的账号名称  
`\v`：BASH的版本信息  
`\w`：完整的工作目录名称。家目录会以 ~代替  
`\W`：利用basename取得工作目录名称，所以只会列出最后一个目录  
`\#`：下达的第几个命令  

设置字符序列颜色的格式为：`\[\e[F;Bm\]`  
其中`F`为字体颜色，编号30~37；`B`为背景色，编号40~47  
可通过`\e[0m`关闭颜色输出；特别的，当B为1时，将显示加亮加粗的文字  

颜色表与代码表  

| 前景   | 背景   | 颜色   |
| ---- | ---- | ---- |
| 30   | 40   | 黑色   |
| 31   | 41   | 紅色   |
| 32   | 42   | 綠色   |
| 33   | 43   | 黃色   |
| 34   | 44   | 藍色   |
| 35   | 45   | 紫紅色  |
| 36   | 46   | 青藍色  |
| 37   | 47   | 白色   |

# 时间同步

<http://www.jianshu.com/p/fb32239ccf2b>  

```bash
su root
# 安装
yum -y install chrony
# 启用
systemctl start chronyd
systemctl enable chronyd
# 设置亚洲时区
timedatectl set-timezone Asia/Shanghai
# 启用NTP同步
timedatectl set-ntp yes
# 手动同步：重启chronyd即可
systemctl restart chronyd
exit
```

# 端口

```bash
netstat -tapen
# 放开端口
firewall-cmd --permanent --zone=public --add-port=27017/tcp
firewall-cmd --permanent --zone=public --remove-port=27017/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
# 开放一段端口
firewall-cmd --permanent --zone=public --add-port=499-65534/tcp 
# 启动停止
firewall-cmd --state
systemctl start firewalld.service
systemctl stop firewalld.service
systemctl disable firewalld.service
```

