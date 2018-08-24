[TOC]

# 镜像加速

> 预期是用不上的，若需要，配置aliyun的个人镜像加速，参考https://yq.aliyun.com/articles/29941

`vi /etc/docker/daemon.json`

```bash
{
    "registry-mirrors": ["https://xxxx.mirror.aliyuncs.com"]
}
```

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

# 配置不安全的私有镜像仓库

`vi /etc/docker/daemon.json`

```bash
{
    "registry-mirrors": ["https://xxxx.mirror.aliyuncs.com"],
    "insecure-registries" : ["http://prod.app:5000"]
}
```

# 集群操作

## 加入与离开集群

```bash
# 创建集群，创建后当前机器即为manage节点，多个网卡时，可能需要指定IP
docker swarm init [ --advertise-addr 当前机器IP]
# 在manage节点查看加入集群的命令，注意时间同步
docker swarm join-token [worker|manager]
# 主动离开集群
docker swarm leave [--force]
```

## 节点管理

```bash
# 查看节点列表
docker node ls
# 移除节点
docker node rm [--force] NODE [NODE...]
# 移除状态为DOWN的节点
docker node ls | grep Down | awk '{print $1}' | xargs -n 1 -I ID docker node rm -f ID
# 查看某个节点运行的容器，默认查当前机器节点
docker node ps [--filter name=redis] [NODE...]
# 查看节点信息
docker node inspect --pretty self|NODE
# 节点阶级，不再是manager
docker node demote NODE
# 节点升级为manager
docker node promote NODE
```

## 添加节点的处理

新节点机器上需要  配置不安全的私有镜像仓库  ，以获取应用镜像

为节点设置label，通过 --constants部署指定label的节点

## 集群中部署服务栈

一堆不同的服务一起组成服务栈，若要移除某个服务所有实例：`docker service scale -d tdportal=0`

```bash
# 部署或更新服务栈
docker stack deploy [OPTIONS] STACK
# 示例：通过compose file部署服务栈
docker stack deploy --compose-file docker-compose-tdapp.yml tdapp
# 查看部署的应用，及实例数量
docker stack ls
# 查看某个服务栈中所有执行过的实例，需在manager节点使用
docker stack ps [-f name=tdapp_tdportal -f node=node01] STACK
# 查看服务栈中的服务列表，及各服务实例数量
docker stack services tdapp
# 删除服务栈
docker stack rm tdapp
```

## 集群中服务管理

`docker service`可以管理`docker stack`部署的服务

```bash
# 查看服务列表
docker service ls
# 查看指定服务信息
docker service inspect --pretty tdportal
# 查看指定服务实例信息
docker service ps tdportal
# 删除指定服务
docker service rm tdportal
# 将服务规模化，即控制服务实例数量，可增加，也可减少
docker service scale -d tdportal=2
docker service scale tdportal=2
# 更新服务，参数与create差不多
docker service update [OPTIONS] SERVICE
# 示例
docker service update --constraint-rm 'node.role == manager' tdportal
docker service update --constraint-add 'node.role == worker' tdportal
# 恢复最近一次update的修改
docker service rollback SERVICE
# 查看服务日志，显示所有实例的日志，当logging driver为json-file或journald时有效
docker service logs 服务ID或服务名称
# 查看每个实例最后100行日志 
docker service logs --tail 100 tdportal
docker service logs --since 2018-08-10Z --tail 100 tdportal
docker service logs -f --since 2018-08-10T06:30Z --tail 100 tdportal
```

