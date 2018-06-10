# easy-mock

杭州大搜车汽车服务有限公司 开源的

Easy Mock 是一个可视化，并且能快速生成 模拟数据 的持久化服务

- 支持 RESTful
- 支持 Swagger
- 支持自定义响应配置
- 支持 Mock.js 语法

# 源码地址

<https://github.com/easy-mock/easy-mock>

<https://github.com/easy-mock/easy-mock/blob/dev/README.zh-CN.md>

# 搭建easy-mock环境

## 安装node

```bash
# 下载
curl -o ~/download/node-v10.3.0-linux-x64.tar http://cdn.npm.taobao.org/dist/node/v10.3.0/node-v10.3.0-linux-x64.tar.xz

# 配置环境变量
vi /etc/profile
export PATH=$PATH:/root/node/node-v10.3.0-linux-x64

source /etc/profile
node -v
npm -v

# 设置国内镜像
npm config set registry https://registry.npm.taobao.org
npm config set prefix "/root/node/modules_global"
npm config set cache "/root/node/cache"
# 查看配置
npm config list

# 查看配置文件位置
npm config get userconfig
npm config get globalconfig
```

## 安装mongodb

```bash
# 下载需要代理，迅雷下载不需要代理
curl -o ~/download/mongodb-linux-x86_64-rhel62-3.6.5.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel62-3.6.5.tgz

# 配置环境变量
vi /etc/profile
export PATH=$PATH:/root/mongodb/mongodb-linux-x86_64-rhel70-3.6.5

source /etc/profile
mongod -v

# 运行 MongoDB 服务
nohup mongod --dbpath=/root/mongodb/data/db1 >> /root/mongodb/mongod.log 2>&1 &
```

## 安装redis

```bash
curl -o ~/download/redis-4.0.9.tar.gz http://download.redis.io/releases/redis-4.0.9.tar.gz

cd redis-4.0.9
make

nohup /root/redis/redis-4.0.9/src/redis-server >> /root/redis/redis-server.log 2>&1 &
```

## 安装git

```bash
# 安装一堆依赖
sudo yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker

curl -o ~/download/git-v2.17.1.tar.gz https://codeload.github.com/git/git/tar.gz/v2.17.1

cd git-v2.17.1
make prefix=/usr/local/git all
sudo make prefix=/usr/local/git install

git -v
```

## 安装easy-mock

```bash
git clone https://github.com/easy-mock/easy-mock.git
cd easy-mock
npm install --unsafe-perm --verbose

npm run dev

# 放开端口
firewall-cmd --permanent --zone=public --add-port=7300/tcp
firewall-cmd --permanent --zone=public --remove-port=7300/tcp
firewall-cmd --reload
firewall-cmd --zone=public --list-ports

curl http://localhost:7300
```
