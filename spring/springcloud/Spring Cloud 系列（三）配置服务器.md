# springcloud配置服务器

- springcoud Config Server

配置服务器提供分布式、动态化集中管理应用配置信息的能力

- 构建SpringCloud配置服务器

`@EnableConfigServer`

## 服务端Environment仓储

**`EnvironmentRepository`**

SpringCloud配置服务器管理多个客户端应用配置信息，然而这些配置信息需要通过一定的规则获取。Spring Cloud Config Server提供EnvironmentRepository接口供客户端应用获取，其中维度有三：

- `{application}`: 客户端应用名称，即`spring.application.name`
- `profile`: 客户端应用当前激活的Profile，即`spring.profiles.active`
- `{label}`: 服务端标记的版本信息，如Git中的分支名

## 搭建Spring Cloud Config server

**基于文件系统实现**

`spring.cloud.config.server.uri=${user.home}/configs`

**基于Git版本控制**

`spring.cloud.config.server.uri=https://github.com/chencye/springcloud-config.git`



