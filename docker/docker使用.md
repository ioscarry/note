[TOC]

[Docker — 从入门到实践](https://yeasy.gitbooks.io/docker_practice/content/)

# 镜像加速

[https://yq.aliyun.com/articles/29941](https://yq.aliyun.com/articles/29941)

`vi /etc/docker/daemon.json`

```bash
{
    "registry-mirrors": ["https://xghzrpf2.mirror.aliyuncs.com"]
}
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

# docker run 与 start的区别

docker run 只在第一次运行时使用，将镜像放到容器中，以后再次启动这个容器时，只需要使用命令docker start 即可。

docker run相当于执行了两步操作：将镜像放入容器中（docker create）,然后将容器启动，使之变成运行时容器（docker start）。

# 安装mysql

```bash
# 安装mysql
docker pull mysql/mysql-server
# 启动mysql，需要指定root密码
docker container run --name=mysql --publish=3306:3306 --env=MYSQL_ROOT_PASSWORD=root -d mysql/mysql-server
# 删除容器
docker container rm mysql
# 启动mysql后，远程使用navicat访问root用户，是访问不了的，需要进入容器内部，创建个新用户
docker exec -it c3bd32e48b21 bash
# 登录mysql的root用户
mysql -u root -p
# 创建数据库
CREATE DATABASE IF NOT EXISTS testdb DEFAULT CHARSET utf8;
# 用户密码30天过期
CREATE USER IF NOT EXISTS 'test' IDENTIFIED BY 'test' PASSWORD EXPIRE INTERVAL 30 DAY;
# 用户密码永不过期
CREATE USER IF NOT EXISTS 'test' IDENTIFIED BY 'test' PASSWORD EXPIRE NEVER;
# 授权testdb库的所有权限给用户test
GRANT ALL ON testdb.* TO 'test';
# 刷新系统权限表
flush privileges;
# jdbc:mysql://{ip}:3306/testdb?useUnicode=true&characterEncoding=UTF-8

```

# 安装gitlab

[https://docs.gitlab.com/omnibus/docker/](https://docs.gitlab.com/omnibus/docker/)

```bash
# 提取gitlab社区版本
docker pull gitlab/gitlab-ce
# 查看镜像
docker images

# 启动需要几分钟，未启动完毕，会显示
# 5002 GitLab is taking too much time to respond
sudo docker stop fc87abc3cd6c
sudo docker container rm gitlab
sudo docker run --detach \
    --publish 8080:80 \
    --publish 1122:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest

```

# 安装redis

```bash
docker pull redis
docker run --name redis -d redis
docker run --name redis --publish=6379:6379 -d redis
# 放开端口
firewall-cmd --permanent --zone=public --add-port=6379/tcp
firewall-cmd --permanent --zone=public --remove-port=6379/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-ports

```

# 安装mongodb

```bash
# https://hub.docker.com/_/mongo/
docker pull redis
docker run --name mongo --publish=27017:27017 -d mongo
# 进入monggodb并创建数据库
mongo
use easy-mock
# 放开端口
firewall-cmd --permanent --zone=public --add-port=27017/tcp
firewall-cmd --permanent --zone=public --remove-port=27017/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-ports
```

