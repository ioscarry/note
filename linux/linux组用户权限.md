[TOC]

# 组

```bash
# 查看当前登录用户的组
groups
# 查看用户所在的组,以及组内成员
groups {username}
# 所有组
cat /etc/group
# 添加组
groupadd {groupname}
# 删除组
groupdel 用户组
# 重命名组名
groupmod -n 新组名 旧组名
# 切换组
newgrp 组名

```

```bash
# 将用户加到组，同时更改主要用户组
usermod -g 组名 用户名
# 将用户移出组，组名不是主组才行
gpasswd -d 用户名 组名
# 查看用户所在的组
groups  或  groups 用户名
```
# 用户

```bash
# 查看当前用户
whoami
# 查看当前在线用户
w
who
# 查看所有用户
cat /etc/passwd|grep -v nologin|grep -v halt|grep -v shutdown|awk -F":" '{ print $1"|"$3"|"$4 }'
# 新创建用户
useradd {username}
useradd -d /git -s /sbin/nologin git
# 查看用户信息
id {username}
# root修改普通用户密码，忘记密码
passwd {username}
# 普通用户修改密码
passwd
# 修改用户名
usermod -l 新用户名 原用户名
# 删除用户
userdel 用户名
userdel -r 用户名 # -r 注意会删除家目录
```


# 权限

```bash
# 分配读写与执行权限，拥有者权限、组权限、其它用户权限
# r=4 w=2 x=1
chmod 777 *.sh
# chown 文件属主转移，-R递归
chown [-R] 账号名称 文件或目录
chown [-R] 账号名称:用户组名称 文件或目录
# chgrp更改文件所属用户组，-R递归
chgrp [-R] 用户组名称 dirname/filename
chgrp -R user .
```





