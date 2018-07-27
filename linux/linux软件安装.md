[TOC]

# 软件包管理简介

软件包分类：源码包、二进制包(RPM包、系统默认包)

# rpm命令管理

## RPM包基础知识准备

在系统安装盘的`Packages`中，有RPM包  
挂载光盘: `mkdir /mnt/cdrom`、`mount /dev/sr0 /mnt/cdrom`  

**RPM包命令原则** 以`httpd-2.4.6-40.el7.centos.x86_64.rpm`示例  
httpd: 软件包名  
2.4.6: 软件版本  
40: 软件发布次数  
el7.centos: 适合的Linux平台  
x86_64: 适合的硬件平台  
rpm: 包扩展名  

**RPM包依赖性**  
查询网站： 
<http://www.rpmfind.net/>  

包全名：操作的包是还没有安装的软件包时，使用包全名。而且需要注意路径  
包名：操作已安装的软件包时，使用包名，是搜索`/var/lib/rpm`中的数据库

## 安装命令  

`rpm -ivh 包全名`  
`i`: install 安装  
`v`: verbose 显示详细信息  
`h`: hash 显示进度  
`--nodeps`: 不检测依赖性  

示例： `rpm -ivh httpd-2.4.6-40.el7.centos.x86_64.rpm`  

## 升级与卸载  

`rpm -Uvh 包全名`  
`U`: upgrade 升级  

`rpm -e 包名`  
`e`: 卸载  
`--nodeps`: 不检测依赖性  

## RPM包查询  

`rpm -q 包名` 查询包是否已安装  

**查询已安装的RPM包**  

`rpm -qa` 查询所有已经安装的RPM包  
`rpm -qa | grep 'ssh'`  

**查询安装包信息**  

`rpm -qi 包名` 查询软件包详细信息  
`i`: information 查询软件信息  
`p`: package 查询未安装包信息  
`rpm -qip 包全名` 查询未安装包信息  

**查询文件安装位置**  

`rpm -ql 包名`  查询包中文件安装位置  
`l`: list 列表  
`p`: package 查询未安装包安装位置  
`rpm -qlp 包全名` 查询未安装包安装位置  

**RPM包默认安装位置**  

| 位置              | 安装文件类型               |
|-------------------|----------------------------|
| `/etc/`           | 配置文件安装目录           |
| `/usr/bin/`       | 可执行的命令安装目录       |
| `/usr/lib/`       | 程序所使用的函数库保存位置 |
| `/usr/share/doc/` | 基本的软件使用手册保存位置 |
| `/usr/share/man/` | 帮助文件保存位置           |

**查询某个文件属于哪个RPM包**  

`rpm -qf 系统文件名`  
`f`: file 查询系统文件属于哪个软件包  

**查询软件包的依赖性**  

`rpm -qR 包名`  
`R`: 查询软件包的依赖性 requires  
`p`: 查询未安装包的信息 package  

## RPM包校验  

`rpm -V 已安装的包名`  
`-V`: 检验指定RPM包中的文件 verify  

| 验证信息 | 说明                                            |
|----------|-------------------------------------------------|
| S        | 文件大小是否改变                                |
| M        | 文件类型或文件权限是否被改变                    |
| 5        | 文件MD5检验和是否改变，可以看成文件内容是否改变 |
| D        | 设备的主从代码是否改变                          |
| L        | 文件路径是否改变                                |
| U        | 文件的属主（所有者）是否改变                    |
| G        | 文件的属级是否改变                              |
| T        | 文件修改时间是否改变                            |

**RPM包中的文件提取**  

`rpm2cpio 包全名 | cpio -idv .文件绝对路径`  
`rpm2cpio`: 将RPM包转换为cpio格式的命令  
`cpio`: 是一个标准工具，它用于创建软件档案文件和从档案文件中提取文件  

 `cpio 选项 < [文件|设备]`  
 `i`: copy-in模式，还原  
 `d`: 还原时自动新建目录  
 `v`: 显示还原过程  

 **误删ls的还原过程**  

```shell
# 查询ls命令属于哪个软件包
rpm -qf /bin/ls
# 造成ls命令删除
mv /bin/ls /tmp/
# 提取RPM包中ls命令到当前目录的/bin/ls下
rpm2cpio /mnt/cdrom/Packages/coreutils-8.22-15.el7.x86_64.rpm | cpio -idv ./bin/ls
# 把ls命令复制到/bin/目录，修复文件丢失
cp /root/bin/ls /bin/
```

# yum在线管理

redhat的yum在线安装需要付费  

## yum源文件  

`cat /etc/yum.repos.d/CentOS-Base.repo`  

| 标识         | 使用                                                                                              |
|--------------|---------------------------------------------------------------------------------------------------|
| `[base]`     | 容器名称，一定要放在`[]`中                                                                        |
| `name`       | 容器说明，可以自己随便写                                                                          |
| `mirrorlist` | 镜像站点，这个可以注释掉                                                                          |
| `baseurl`    | yum源服务器地址。默认是CentOS官方yum源服务器，是可以使用的。如果觉得慢可以改成自己喜欢的yum源地址 |
| `enabled`    | 此容器是否生效，如果不写或写成`enabled=1`都是生效，写成`enabled=0`就是不生效                      |
| `gpgcheck`   | 1指RPM的数字证书生效，0则不生效                                                                   |
| `gpgkey`     | 数字证书的公钥文件保存位置。不用修改                                                              |

## 光盘搭建yum源  

```shell
# 挂载光盘
mkdir /mnt/cdrom
/dev/cdrom /mnt/cdrom/
# 使网络yum源失效
cd /etc/yum.repos.d
mv CentOS-Base.repo CentOS-Base.repo.bak
# 使光盘yum源生效
# baseurl=file:///mnt/cdrom/
# enabled=1
vi CentOS-Media.repo
# 查看
yum list
```

## yum命令  

```shell
# 查询所有可用软件包列表
yum list
# 列出所有可更新的软件包 
yum list updates
# 列出所有已安装的软件包 
yum list installed
# 列出所有已安装但不在 Yum Repository 内的软件包 
yum list extras

# 搜索服务器上所有和关键字相关的包
yum search 关键字

# 安装，y自动回答yes或no
yum -y install 包名
# 安装C语言编译器
yum -y install gcc
# 升级
yum -y update 包名
# 卸载
yum -y remove 包名 # 不推荐使用

# 列出所有可用的软件组列表
yum grouplist 
# 显示英文，原zh_CN.UTF-8
LANG=en_US
# 安装指定软件组，组名可以由grouplist查询出来
yum groupinstall 软件组名(英文)
# 制裁指定软件组
yum groupremove 软件组名
```

**服务器使用最小化安装，用什么软件安装什么，尽量不制裁**  

# 源码包管理

## 源码包和RPM包的区别  

安装之前的区别：概念上的区别  
安装之后的区别：安装位置不同，RPM安装在默认位置(`rpm -qi 包名`)  

RPM包也可以安装到指定位置  
`rpm --help | grep prefix`  

**RPM包安装时，不建议指定安装位置**  
RPM包安装的服务可以使用系统服务管理命令`service`来管理，例如RPM包安装的apache的启动方法是：  
`/etc/rc.d/init.d/httpd start`  
`service httpd start`  

**源码包安装时，需要指定位置**  
一般是安装在`/usr/local/软件名/`  
源码包没有卸载命令  
源码包安装的服务则不能被服务管理命令管理，因为没有安装到默认路径中。所以只能绝对路径进行服务的管理：  
`/usr/local/apache2/bin/apachectl start`  

## 源码包安装过程  

**安装准备**  

- 安装C语言编译器 `rpm -qa | grep gcc`  
- 下载源码包 <http://mirror.bit.edu.cn/apache/httpd/>  

**RPM包与源码包安装，选择哪一个**  
源码包: 开源、自定义、编译效率更高，如果是给成千上成的客户端访问的，建议使用源码码包安装，例如apache  
RPM包: 厂商编译好的，不一定在自已电脑中执行效率高  

**安装注意事项**  
源码保存位置：`/usr/local/src/`  
软件安装位置：`/usr/local/`  
如何确定安装过程报错： 安装过程停止，并出现error、warning或no的提示  

**安装过程**  

- 下载源码包  
- 解压缩下载的源码包  
- 进入解压缩目录  
- `./configure --prefix=/usr/local/apache2`软件配置与检查 (`./configure --help`)  
定义需要功能选项  
检测系统环境是否符合安装要求  
把定义好的功能选项和检测系统环境的信息都写入Makefile文件，用于后续的编辑  
- `make` 编译，若出现异常，执行`make clean`还原为未编译的样子  
- `make install` 安装  

如果是安装httpd，则在`INSTALL`文件中，有详细的安装步骤说明  

## 源码包的卸载  

不需要卸载命令，直接删除安装目录即可。不会遗留任何垃圾文件。  

# 脚本安装  

所谓的一键安装包，实际上还是安装的源码包与RPM包，只是把安装过程写成了脚本，便于初学者安装  
优点：简单、快速、方便  
缺点：不能定义软件版本，不能定义软件功能，源码包的优势丧失  

nginx  

**准备工作**  
关闭RPM包安装的httpd和MySQL  
保证yum源正常使用  
关闭SELinux和防火墙  

<https://lnmp.org/>
