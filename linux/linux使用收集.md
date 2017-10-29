[TOC]

**Centos7**

# shell处理

## 文件类型判断

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

## 循环遍历

```bash
# 文件夹遍历
#!/bin/bash
function walkDir() {
    curDir=$1
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

```bash
# 文件内容遍历
#!/bin/bash

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

```bash
# 数组遍历

```

## 文本处理

### 字串匹配

### 字串截取

**说明：$substring可以是一个正则表达式**  

| 表达式                                      | 含义   |
| ---------------------------------------- | ---- |
| ${#string}                       | $string的长度 |      |
|                                          |      |
| ${string:position}               | 在$string中, 从位置$position开始提取子串 |      |
| ${string:position:length}        | 在$string中, 从位置$position开始提取长度为$length的子串 |      |
|                                          |      |
| ${string#substring}              | 从变量$string的开头, 删除最短匹配$substring的子串 |      |
| ${string##substring}             | 从变量$string的开头, 删除最长匹配$substring的子串 |      |
| ${string%substring}              | 从变量$string的结尾, 删除最短匹配$substring的子串 |      |
| ${string%%substring}             | 从变量$string的结尾, 删除最长匹配$substring的子串 |      |
|                                          |      |
| ${string/substring/replacement}  | 使用$replacement, 来代替第一个匹配的$substring |      |
| ${string//substring/replacement} | 使用$replacement, 代替所有匹配的$substring |      |
| ${string/#substring/replacement} | 如果$string的前缀匹配$substring, 那么就用$replacement来代替匹配到的$substring |      |
| ${string/%substring/replacement} | 如果$string的后缀匹配$substring, 那么就用$replacement来代替匹配到的$substring |      |

### 子字串替换

### 文件中匹配替换

```bash
# sed 命令
sed 's/123/456/g' file.txt # 只显示效果，不修改
sed -i 's/123/456/g' file.txt # 直接修改原文件

# vi 编辑器
# 替换
:%s/123/456/g
```

## 脚本

[根据svn日志提取补丁包](https://files.cnblogs.com/files/chencye/extractBySvnLog.sh)

[md5生成与校验]()

[tomcat重启]()

[tomcat检查]()

[tomcat停止]()

[jar程序重启]()

[jar程序检查]()

[jar程序停止]()



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

# 网络命令

## curl

```bash
# 下载文件
curl -o ~/download/jdk.tar.gz http://download.oracle.com/jdk.tar.gz
```

