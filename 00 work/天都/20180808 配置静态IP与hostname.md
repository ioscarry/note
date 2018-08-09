# 配置hostname原因

注册中心，生产环境不使用ip配置

方便搭建高可用eureka

# 配置静态IP

> Centos 7 学习之静态IP设置 https://blog.csdn.net/johnnycode/article/details/40624403

```bash
# 查看网卡
ip addr
# 查看路由
route -n
# 编辑网卡配置
vi /etc/sysconfig/network-scripts/ifcfg-enp0s31f6
```

```properties
BOOTPROTO=static #dhcp改为static 
ONBOOT=yes #开机启用本配置
IPADDR=10.48.78.172 # 静态IP
GATEWAY=10.48.78.254 # 默认网关
NETMASK=255.255.255.0 # 子网掩码
```



# 配置hostname访问

`vi /etc/hosts`

```
127.0.0.1   localhost
10.48.78.172 node01
```



`/etc/sysconfig/network`

```
# Created by anaconda
HOSTNAME=node01
```



# 配置dns

`/etc/resolv.conf`

```
nameserver 114.114.114.114
nameserver 8.8.8.8
```



# 重启下网络服务

`service network restart `



# 测试

` ping node01`

