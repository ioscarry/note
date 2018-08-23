[TOC]

# 部署情况

当前直接使用docker启动

后续建议移出docker

```bash
# 注意配置external_url后，容器启动的gitlab页面的仓库地址会使用10080端口
# 启动需要几分钟，未启动完毕，会显示 5002 GitLab is taking too much time to respond
# gitlab: http://10.48.78.172:10080 root/g3@@2018
docker run --detach \
    --env GITLAB_OMNIBUS_CONFIG="external_url 'http://10.48.78.172:10080/'; gitlab_rails['lfs_enabled'] = true;" \
    --publish 10080:10080 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```



# ci/cd



