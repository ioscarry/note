[TOC]

# 使用域名

为何使用域名：

- 方便不同docker节点获取镜像，也方便开发环境推送镜像。
- 不然以后IP有变化，那所有镜像都用不了了

`/etc/hosts`

```
xx.xx.xx.xx prod.app
```

# 镜像仓库

暂不考虑安全与集群，所以不以服务方式启动

```bash
# 启动私有镜像仓库
docker run -d \
  -p 5000:5000 \
  --restart always \
  --name registry \
  registry
# 查看仓库中的镜像列表
curl http://prod.app:5000/v2/_catalog
curl http://prod.app:5000/v2/{image}/tags/list
```

由于未考虑安全，所以，需要在各个docker中配置 不安全的镜像仓库

` vi /etc/docker/daemon.json` 

```json
{
    "registry-mirrors": ["https://xxxx.mirror.aliyuncs.com"],
    "insecure-registries" : ["http://prod.app:5000"]
}
```

