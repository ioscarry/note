# 安装及配置nodejs

```bash
# 下载
# 版本太新会有问题
# curl -o ~/download/node-v10.3.0-linux-x64.tar http://cdn.npm.taobao.org/dist/node/v10.3.0/node-v10.3.0-linux-x64.tar.xz
curl -o ~/download/node-v8.11.2-linux-x64.tar.xz https://nodejs.org/dist/v8.11.2/node-v8.11.2-linux-x64.tar.xz

# 配置环境变量
vi /etc/profile
export PATH=$PATH:/root/node/node-v8.11.2-linux-x64/bin

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

