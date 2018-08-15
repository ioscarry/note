[TOC]

# 启动完毕检查

- 注册中心
  - http://10.48.78.172:7082/
  - http://10.48.78.172:7082/
  - http://10.48.78.172:7083/
- 配置中心
  - http://10.48.78.172:7070/TdPortal/dev/master
- 网关
  - http://10.48.78.172:8080/actuator/routes


# docker stack yaml

## start.sh

```bash
#!/bin/bash

networkcount=`docker network ls -f name=tdapp -q | wc -l`
if [[ ${networkcount} == 0 ]]; then
    docker network create --driver overlay tdapp
fi

docker stack deploy -c docker-stack-tdapp.yml tdapp
```

## docker-stack-tdapp.yml

```yaml
version: '3'

services:
  tdservicecenter01:
    image: dev.app:5000/tdapp/tdservicecenter
    environment:
      - SERVER_PORT=7080
      - SPRING_PROFILES_ACTIVE=dev
      - EUREKA_SERVERS=http://tdservicecenter02:7080/eureka/,http://tdservicecenter03:7080/eureka/
    networks:
      tdapp:
        aliases:
          - eureka
    ports:
      - 7081:7080
      - 7080:7080
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdservicecenter02:
    image: dev.app:5000/tdapp/tdservicecenter
    environment:
      - SERVER_PORT=7080
      - SPRING_PROFILES_ACTIVE=dev
      - EUREKA_SERVERS=http://tdservicecenter01:7080/eureka/,http://tdservicecenter03:7080/eureka/
    networks:
      tdapp:
        aliases:
          - eureka
    ports:
      - 7082:7080
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdservicecenter03:
    image: dev.app:5000/tdapp/tdservicecenter
    environment:
      - SERVER_PORT=7080
      - SPRING_PROFILES_ACTIVE=dev
      - EUREKA_SERVERS=http://tdservicecenter01:7080/eureka/,http://tdservicecenter02:7080/eureka/
    networks:
      tdapp:
        aliases:
          - eureka
    ports:
      - 7083:7080
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdconfig:
    image: dev.app:5000/tdapp/tdconfig
    deploy:
      replicas: 1
    networks:
      tdapp:
        aliases:
          - gitconfig
    ports:
      - 7060:80

  tdconfigcenter:
    depends_on:
      - tdservicecenter01
    image: dev.app:5000/tdapp/tdconfigcenter
    environment:
      - SERVER_PORT=7070
      - SPRING_PROFILES_ACTIVE=dev
      - EUREKA_SERVERS=http://eureka:7080/eureka
      - CONFIG_GIT_URL=http://gitconfig/git/TdConfig.git
    networks:
      tdapp:
        aliases:
          - config
    ports:
      - 7070:7070
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdportal:
    depends_on:
      - tdconfigcenter
    image: dev.app:5000/tdapp/tdportal
    environment:
      - SERVER_PORT=8080
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_CLOUD_CONFIG_ENABLED=true
      - SPRING_CLOUD_CONFIG_DISCOVERY_ENABLED=true
      - EUREKA_CLIENT_ENABLED=true
      - EUREKA_SERVERS=http://eureka:7080/eureka
    networks:
      tdapp:
        aliases:
          - portal
    ports:
      - 8080:8080
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdsystemservice:
    depends_on:
      - tdconfigcenter
    image: dev.app:5000/tdapp/tdsystemservice
    environment:
      - SERVER_PORT=8081
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_CLOUD_CONFIG_ENABLED=true
      - SPRING_CLOUD_CONFIG_DISCOVERY_ENABLED=true
      - EUREKA_CLIENT_ENABLED=true
      - EUREKA_SERVERS=http://eureka:7080/eureka
    networks:
      tdapp:
        aliases:
          - systemservice
    ports:
      - 8081:8081
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

  tdappservice:
    depends_on:
      - tdconfigcenter
    image: dev.app:5000/tdapp/tdappservice
    environment:
      - SERVER_PORT=8082
      - SPRING_PROFILES_ACTIVE=dev
      - SPRING_CLOUD_CONFIG_ENABLED=true
      - SPRING_CLOUD_CONFIG_DISCOVERY_ENABLED=true
      - EUREKA_CLIENT_ENABLED=true
      - EUREKA_SERVERS=http://eureka:7080/eureka
    networks:
      tdapp:
        aliases:
          - appservice
    ports:
      - 8082:8082
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure

networks:
  tdapp:
    external:
      name: tdapp

```

# 手动操作

```bash
# network
docker network create --driver overlay tdapp
docker network ls
docker network rm tdapp

# stack
docker stack ls
docker stack ps tdapp
docker stack rm tdapp

# tdservicecenter
docker service rm tdapp_tdservicecenter01 tdapp_tdservicecenter02 tdapp_tdservicecenter03
docker service ls
docker service ps tdapp_tdservicecenter01
docker service logs -f --tail 100 tdapp_tdservicecenter01
# tdservicecenter start
mvn clean package && docker build -t dev.app:5000/tdapp/tdservicecenter .
docker push dev.app:5000/tdapp/tdservicecenter
docker stack deploy -c docker-stack-tdapp-tdservicecenter.yml tdapp
# 检查：http://10.48.78.172:7081/
# 	   http://10.48.78.172:7082/
# 	   http://10.48.78.172:7083/

# tdconfigcenter
mvn clean package && docker build -t dev.app:5000/tdapp/tdconfigcenter .
docker push dev.app:5000/tdapp/tdconfigcenter
docker stack deploy -c docker-stack-tdapp-tdconfigcenter.yml tdapp
docker service logs -f --tail 100 tdapp_tdconfigcenter
docker service ps tdapp_tdconfigcenter
# 检查：http://10.48.78.172:7070/TdPortal/dev/master
docker service rm tdapp_tdconfigcenter

# tdportal
mvn clean package
docker build -t dev.app:5000/tdapp/tdportal .
docker push dev.app:5000/tdapp/tdportal
docker stack deploy -c docker-stack-tdapp-tdportal.yml tdapp
docker service logs -f --tail 100 tdapp_tdportal
# 检查：http://10.48.78.172:8080/actuator/routes
docker service rm tdapp_tdportal

```
