[TOC]

# crontab

`crontab`: (cron table)周期性执行任务的工具  

系统服务CROND：每分钟都会从配置文件刷新定时任务  

```shell
# 检查crontab工具是否安装
crontab -l

# 查看crond服务是否启动
service crond status

# 若未安装，则（centos7最小化安装时，已自带cron）
yum install vixie-cron
yum install crontabs
```

**示例：每分钟执行**  

```shell
# 逻辑计划任务列表
crontab -e
# 在最后添加下面一行
# */1 * * * * date >> /tmp/date.txt
```

# crontab配置格式

`* * * * * command`  
`分钟  小时  日期  月份  星期(0或7表示星期天)  命令`  

`*` 表示任何时间都匹配  
`A,B,C` 表示A或B或C时间执行命令  
`A-B` 表示A到B之间执行命令  
`*/A` 表示每A分钟（小时等）执行一次命令  

```shell
# 每晚的21:30重启apahce
30 21 * * * service httpd restart
# 每月1、10、22日的4:45重启apache
45 4 1,10,22 * * service htppd restart
# 每月1到10日的4:45重启apacche
45 4 1-10 * * service httpd restart

# 每隔两分钟重启apache
*/2 * * * * service httpd restart
# 在每奇数分钟重启apache
1-59/2 * * * * service httpd restart

晚上11点到早上7点这间，每隔一小时重启apache
0 23-7/1 * * * service httpd restart

# 每天18:00到23:00之间每隔30分钟重启apache
0,30 18-23 * * * service httpd restart
0-59/30 18-23 * * * service httpd restart
```

# crontab执行日志

```shell
# 计划任务执行日志文件，会每天自动备份
ll /var/log/cron*
# 查看任务执行日志
tail -f /var/log/cron
```

**实cron际执行任务**： `cat /var/spool/cron/用户名`  

# crontab 常见错误

```
# 1. 环境变量
# 环境变量在计划任务命令中，是不起作用的

# 2. 第三和第五个域之间执行的是 “或” 操作，即日期或星期
# 3. 命令行中的 % 需要加上 \

# 四月的第一个星期日早晨1:59分运行
# 错误写法：59 1 1-7 4 0 /root/a.sh
59 1 1-7 4 * test `date +\%w` -eq 0 && a.sh

# 4. 分钟设置误用  
# 两个小时运行一次，注意第一个为具体分钟数
0 */2 * * * date
```

# 秒级定时的实现

crontab中最小只能设置到每分钟执行一个命令  
通过sleep命令的配合，可以实现秒级的计划任务  

```shell
crontab -e
*/1 * * * * date >> /tmp/date.log
*/1 * * * * sleep 30s;date >> /tmp/date.log
```