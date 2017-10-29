[TOC]

# 思考

找出关于 Spring Boot 启动参数 PropertySource处理，提示在 Spring Framework 里面找！



# 笔记

## 关闭env 安全

```properties
# 关闭，才能使用actuator直接访问http://localhost:8080/env
endpoints.env.sensitive=false
```



## Environment

`Environment`:`PropertySources` 1:1

`PropertySources`:`PropertySource` 1:N

前面的会把后面的覆盖



## springboot 配置文件

配置读取`org.springframework.boot.context.config.ConfigFileApplicationListener.Loader`  

`application.properties`加载器为`org.springframework.boot.env.PropertiesPropertySourceLoader`

`application.yml`加载器为`org.springframework.boot.env.YamlPropertySourceLoader`



## Environment端点

`/env`

数据来源：`EnvironmentEndpoint`

Controller源：`EnvironmentMvcEndpoint`



修改内部配置

`post http://localhost:8080/env?endpoints.env.sensitive=true`



## Boostrap配置属性

参考`BootstrapApplicationListener`实现

```java
String configName = environment	.resolvePlaceholders("${spring.cloud.bootstrap.name:bootstrap}");
```

当`spring.cloud.bootstrap.name:bootstrap`

不存在时，默认取`bootstrap`



```yaml
spring:
  cloud:
    bootstrap:
      # 关闭bootstrap上下文
      enabled: false
```

> 注意：`BootstrapApplicationListener`加载实际早于`ConfigFileApplicationListener`
>
> 原因是：
>
> `ConfigFileApplicationListener`的`Order=Ordered.HIGHEST_PRECEDENCE + 10`(第十一位)
>
> `BootstrapApplicationListener`的`Order=Ordered.HIGHEST_PRECEDENCE + 5`(第六位)

如果需要调整控制Bootstrap上下文件行为配置，需要更高优先级，也就是Order需要`Ordered.HIGHEST_PRECEDENCE + 5`

```properties
--spring.cloud.bootstrap.enbaled=true
```



### 调整boostrap配置文件名称

调整程序启动参数

```properties
--spring.cloud.bootstrap.name=spring-cloud
```

启动时，读取`application.properties`与`spring-cloud.properties`



### 调整bootstrap配置文件路径

调整程序启动参数

```properties
--spring.cloud.bootstrap.name=spring-cloud
--spring.cloud.bootstrap.location=config
```

启动时，读取`application.properties`、`config/spring-cloud.properties`与`spring-cloud.properties`



### 覆盖远程配置属性

默认情况，springcloud是允许覆盖的，`spring.cloud.allowOverride=true`

调整程序启动参数

```properties
--spring.cloud.bootstrap.name=spring-cloud
--spring.cloud.bootstrap.location=config
--spring.cloud.allowOverride=false
```



### 自定义bootstrap配置

1. 创建配置文件`META-INF/spring.factories`(类似于springboot自定义Starter)

2. 自定义Bootstrap配置类，实现`ApplicationContextInitializer`，可以通过`@Order`来保证顺序

   ```java
   import org.springframework.context.ApplicationContextInitializer;
   import org.springframework.context.ConfigurableApplicationContext;
   import org.springframework.context.annotation.Configuration;
   import org.springframework.core.env.ConfigurableEnvironment;
   import org.springframework.core.env.MapPropertySource;
   import org.springframework.core.env.MutablePropertySources;
   import org.springframework.core.env.PropertySource;

   import java.util.HashMap;
   import java.util.Map;

   @Configuration
   public class MyConfiguration implements ApplicationContextInitializer {
       @Override
       public void initialize(ConfigurableApplicationContext applicationContext) {
           ConfigurableEnvironment environment = applicationContext.getEnvironment();
           MutablePropertySources propertySources = environment.getPropertySources();
           // 定义一个新的PropertySource，并放置到首位
           propertySources.addFirst(createPropertySource());
       }

       private PropertySource createPropertySource() {
           Map<String, Object> source = new HashMap<>();
           source.put("name", "test1");
           PropertySource propertySource = new MapPropertySource("my-property-source", source);
           return propertySource;
       }
   }
   ```

   ​

3. 配置`META-INF/spring.factories`文件，关联Key

   ```properties
   org.springframework.cloud.bootstrap.BootstrapConfiguration=com.github.chencye.demo.springcloudclient.bootstrap.MyConfiguration
   ```

   ​

### 自定义Bootstrap配置属性源

1. 实现`PropertySourceLocator`

```java
import org.springframework.cloud.bootstrap.config.PropertySourceLocator;
import org.springframework.core.env.*;

import java.util.HashMap;
import java.util.Map;

public class MyPropertySourceLocator implements PropertySourceLocator {
    @Override
    public PropertySource<?> locate(Environment environment) {

        if (environment instanceof ConfigurableEnvironment)
        {
            ConfigurableEnvironment configurableEnvironment = ConfigurableEnvironment.class.cast(environment);
            MutablePropertySources propertySources = configurableEnvironment.getPropertySources();
            // 定义一个新的PropertySource，并放置到首位
            propertySources.addFirst(createPropertySource());
        }

        return null;
    }

    private PropertySource createPropertySource() {
        Map<String, Object> source = new HashMap<>();
        source.put("spring.application.name", "test2");
        PropertySource propertySource = new MapPropertySource("over-bootstrap-source", source);
        return propertySource;
    }
}
```

2. 配置`META-INF/spring.factories`

```properties
org.springframework.cloud.bootstrap.BootstrapConfiguration=\
com.github.chencye.demo.springcloudclient.bootstrap.MyConfiguration,\
com.github.chencye.demo.springcloudclient.bootstrap.MyPropertySourceLocator
```

