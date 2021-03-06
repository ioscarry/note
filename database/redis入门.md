[TOC]

# nosql概述

**no only sql**  

为什么需要nosql  

- 高并发读写  
- 海量数据的高效率存储与访问  
- 高可扩展性和高可用性  

|   分类   |  相关产品   | 典型应用                           | 数据模型              | 优点                     | 缺点                            |
| :----: | :-----: | ------------------------------ | ----------------- | ---------------------- | ----------------------------- |
|  键值对   |  redis  | 内容缓存，主要用于处理大量数据的高访问负载          | 一系列键值对            | 快速查询                   | 存储的数据缺少结构化                    |
| 列存储数据库 |  hbase  | 分布式的文件系统                       | 以列簇式存储，将同一列数据存在一起 | 查找数据快，可扩展性强，更容易进行分布式扩展 | 功能相对局限                        |
| 文档型数据库 | mongodb | web应用(与key-value类似，value是结构化的) | 一系键值对             | 数据结构要求不严格              | 查询性能不高，缺乏统一语法                 |
| 图形数据库  |  Graph  | 社交网络，推荐系统等，专注于构建关系图谱           | 图结构               | 利用图结构相关算法              | 需要对整个图做计算才能得出结果， 不容易做分布式的集群方案 |

# 安装redis


# 操作命令

**通用操作**  

```bash
# 连接
redis-cli
# 选择库，有16个库，由0到15
select 1
# 查所有key
keys *
# 当前库中key数量
dbsize
# 删除当前库所有key
flushdb
```

**keyvalue操作**

**list操作**

**set操作**

**sorted set操作**


# redis持久化


