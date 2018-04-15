# docker解决的问题

1. 我本地运行没问题啊！
2. 系统好卡，哪个哥们又写死循环了？
    限定cpu、硬盘
3. 双11来了，服务器撑不住啦
    docker标准化，快速扩展

# docker核心技术

运行一个程序的过程：去仓库把镜像拉到本地，然后用一条命令，把镜像运行起来变成容器

- build 构建镜像
- ship 运输镜像
- run 运行镜像

**镜像**：集将箱
联合文件系统：实现文件的分层，每一层都是只读的

**容器**：运行程序的地方
虚拟机

**仓库**：超级码头
中央服务器：
<https://hub.docker.com>
<https://c.163.com/hub>

# linux安装docker

在CentOS上安装docker
<https://docs.docker.com/engine/installation/linux/docker-ce/centos/>

To install Docker CE, you need the 64-bit version of CentOS 7.

卸载旧版本：`yum remove docker docker-common docker-selinux docker-engine`
卸载docker社区版本：`yum remove docker-ce`
删除镜像容器等：`rm -rf /var/lib/docker`

**yum源安装**

配置yum源
```shell
# 1. 安装yum工具
yum install -y yum-utils device-mapper-persistent-data lvm2

# 2. 配置yum源
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 3. (可选)启用edge与testing，从17.06版本之后，稳定版本也会发布到edge与testing中
yum-config-manager --enable docker-ce-edge
yum-config-manager --enable docker-ce-testing
```

安装docker-ce
```shell
# 1. 更新yum包索引
yum makecache fast
# 添加docker源后，首次更新，将会提示接受GPG key，确保指纹为：060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35

# 2. 安装最新版本
yum install docker-ce

# 3. 在生产环境，可能需要指定docker版本
yum list docker-ce.x86_64  --showduplicates | sort -r
yum install docker-ce-<VERSION>

# 4. 启动docker
systemctl start docker

# 5. 验证是否安装成功，下面命令会下载测试镜像，在一个容器中运行，输出一些信息后结束
docker run hello-world
```

**rpm包安装**

1. 下载rpm包
<https://download.docker.com/linux/centos/7/x86_64/stable/Packages/>

2. 安装rpm包
`yum install /path/to/package.rpm`

3. 启动服务
`systemctl start docker`

4. 验证是否安装成功
`docker run hello-world`


# docker操作

从仓库拉取镜像
`docker pull [OPTIONS] NAME[:TAG]`
`docker pull hello-world`

查看本机的镜像
`docker images [OPTIONS] [REPOSITORY[:TAG]]`

运行镜像
`docker run [OPTIONS] IMAGE[:TAG] [COMMAND] [ARG...]`
`docker run hello-world`


# docker运行nginx

拉取nginx镜像
`docker pull hub.c.163.com/library/nginx:latest`
前台执行
`docker run hub.c.163.com/library/nginx`
后台执行，执行命令后会输出一串容器ID
`docker run -d hub.c.163.com/library/nginx`
查看正在运行的容器，ID只显示前面一部分
`docker ps`

进入容器内部，跟一个linux差不多
`docker exec -it 名称或ID(可为前面部分) bash`
`docker exec -it 74bb bash`
查看容器中运行的进程
`ps -ef`
退出
`exit`


Bridge 生成虚拟网上，独立的IP，有独立的IP与端口
Host 使用主机IP，不分配IP

端口映射
使用Bridge时，通过端口映射，使得主机可以访问容器

`docker stop 74bb`

启动时，配置端口映射。主机端口:容器端口
`docker run -d -p 8080:80 hub.c.163.com/library/nginx`
这样就可以访问到容器中的nginx了
<http://192.168.1.103:8080/>

# 制作镜像

**准备一个war包**
jpress: http://jpress.io/

**拉取tomcat作为基础镜像**
`docker pull hub.c.163.com/library/tomcat:latest`

**编写Dockerfile**
tomcat的路径，可以在镜像仓库的tomcat镜像说明中查看

`vi Dockerfile`
```
from hub.c.163.com/library/tomcat:latest

MAINTAINER chencye chencye@163.com

COPY jpress-web-newest.war /usr/local/tomcat/webapps

```

**执行docker镜像构建**
`docker build -t jpress:latest .`


**运行自制的镜像**
`docker run -d -p 8888:8080 jpress`
<http://192.168.1.103:8888/jpress-web-newest>


**安装并运行mysql镜像**
`docker pull hub.c.163.com/library/mysql:latest`
`docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123654 -e MYSQL_DATABASE=jpress hub.c.163.com/library/mysql:latest`
可以镜像仓库中查看各`-e`参数的说明


# 命令小结

```shell
# 安装yum工具
yum install -y yum-utils device-mapper-persistent-data lvm2
# 配置yum源
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# 更新yum包索引
yum makecache fast
# 安装最新版本
yum install docker-ce

# 启动docker服务
systemctl start docker

# 从仓库拉取镜像
docker pull hub.c.163.com/library/nginx:latest
# 查看本机安装的镜像
docker images
# 后台运行指定镜像，并配置端口映射
docker run -d -p 8080:80 hub.c.163.com/library/nginx

# 查看正在运行的容器
docker ps
# 进入容器内部
docker exec -it 74bb bash

# 停止容器
docker stop 3b60dadf1706
# 重启容器
docker restart 3b60dadf1706

# 构建镜像
docker build -t jpress:latest .
```

# jetbrains授权

```shell
docker pull luamas/jetbrains-license-server
docker run --restart=always \
-p 22508:22508 \
--name jetbrains-license-server -d luamas/jetbrains-license-server
# jetbrains授权地址：http://192.168.1.103:22508
```


# 遇到的问题

## 执行exec报错

报错信息：

```bash
rpc error: code = 2 desc = oci runtime error: exec failed: container_linux.go:262: starting container process caused "exec: \"bash\": executable file not found in $PATH"
```

