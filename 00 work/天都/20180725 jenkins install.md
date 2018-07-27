# docker images

```bash
# jenkins
docker stop jenkins && docker rm jenkins
docker run --detach \
  -u root \
  --restart always \
  --name jenkins \
  -p 10111:8080 \
  -v jenkins_home:/var/jenkins_home \
  -v /usr/local/jdk1.8.0_171:/usr/local/jdk1.8.0_171 \
  -v /usr/local/apache-maven-3.5.4:/usr/local/apache-maven-3.5.4 \
  -v /var/maven/repo:/var/maven/repo \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

# 问题

```
Cannot run program "mvn"
```

解决：

在全局工具配置中添加maven。

在项目的构建中增加Invoke top-level Maven targets中的Maven Version里面选中刚刚添加的Maven ID



