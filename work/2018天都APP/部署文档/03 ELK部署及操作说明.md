[TOC]

# 准备linux用户

```bash
useradd elk
passwd elk

# 配置sudo权限，翻到最后，加入
# elk     ALL=(ALL)       ALL
visudo

su elk
```

# elasticsearch

## 作用

索引引擎，存储仓库

## 安装

```bash
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.rpm
sudo rpm -ivh elasticsearch-6.3.2.rpm
# 开机启动
sudo chkconfig --add elasticsearch
# 配置/etc/elasticsearch/elasticsearch.yml  配置内网IP
# 启动
sudo service elasticsearch start
sudo service elasticsearch status
sudo service elasticsearch stop
```

## 配置

文件：`/etc/elasticsearch/elasticsearch.yml`

只需配置IP地址即可：`network.host: 内网IP`

## 验证启动成功及日志 

```bash
# 检查
# 需修改/etc/elasticsearch/elasticsearch.yml配置network.host为IP
curl -X GET IP:9200
# 数据/var/lib/elasticsearch
# 日志
tail -100f /var/log/elasticsearch/elasticsearch.log
```

# kibana

## 作用及页面操作

供用户查询elasticsearch的可视化web页面

需要先创建索引`Index Patterns`，之后才能查询`Dicover`，查询时注意选择日志查询时间

需要有索引文件`Index management`之后，才能创建索引

## 安装nodejs

`Since Kibana runs on Node.js`

## 安装kibana

```bash
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.3.2-x86_64.rpm
sudo rpm -ivh kibana-6.3.2-x86_64.rpm
# 开机启动
sudo chkconfig --add kibana
# 启动停止
sudo service kibana start
sudo service kibana stop
sudo service kibana status
```

## 配置

配置文件：`/etc/kibana/kibana.yml`

配置`server.host: 内网IP`

配置`elasticsearch.url: "http://内网IP:9200"`

## 验证及日志 

```bash
curl -X GET 内网IP:5601/status
# 日志 
tail -100f /var/log/kibana/kibana.stdout
```

配置slb入口后，可以在浏览器访问对应的配置地址，如http://slbIP/kibana

# logstash

## 作用

解析及中转日志到elasticsearch

## 安装

```bash
wget https://artifacts.elastic.co/downloads/logstash/logstash-6.3.2.rpm
sudo rpm -ivh logstash-6.3.2.rpm
# 开机启动
sudo chkconfig --add logstash
# 启停及状态
sudo service logstash start
sudo service logstash status
sudo service logstash stop
vi /etc/logstash/conf.d/filebeat-pipeline.conf

```

## 配置

`/etc/logstash/conf.d`下添加`filebeat-pipeline.conf`

注意配置`output`中`elasticsearch`的内网IP

```json
input {
    beats {
        port => "5044"
    }
}
filter {
    mutate {
        split => ["message", " | "]
        add_field => {
            "timestamp" => "%{[message][0]}"
        }
        add_field => {
            "app" => "%{[message][1]}"
        }
        add_field => {
            "hostname" => "%{[message][2]}"
        }
        add_field => {
            "level" => "%{[message][3]}"
        }
        add_field => {
            "thread" => "%{[message][4]}"
        }
        add_field => {
            "class" => "%{[message][5]}"
        }
        add_field => {
            "msg" => "%{[message][6]}"
        }
    }
    date {
        match => ["timestamp", "yyyy-MM-dd HH:mm:ss.SSS"]  
        timezone => "Asia/Shanghai"
    }
}
output {
    elasticsearch {
        hosts => [ "10.48.78.172:9200" ]
        index => "tdapp-%{app}-%{+YYYY.MM.dd}"
    }
}
```

## 日志

`tail -100f /var/log/logstash/logstash-plain.log`

# filebeat

## 作用

收集应用日志，当前统一应用文件均保存在`/logs`目录下

需要安装到所有docker集群的机器上

## 安装

```bash
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.2-x86_64.rpm
sudo rpm -vi filebeat-6.3.2-x86_64.rpm
# 启停及状态
sudo service filebeat start
sudo service filebeat status
sudo service filebeat stop
```

## 配置

`/etc/filebeat/filebeat.yml`

主要需要修改的配置如下

```yaml
- type: log
  paths:
    - /logs/*.log
#================================ Outputs =====================================
#----------------------------- Logstash output --------------------------------
output.logstash:
  hosts: ["logstash内网IP:5044"]
#============================== Xpack Monitoring ===============================
xpack.monitoring.elasticsearch:
  hosts: ["http://elasticsearch内网IP:9200"]
```

## 日志

`tail -100f /var/log/filebeat/filebeat`

# metricbeat

## 作用

收集系统信息，包括CPU，内存使用等

安装到每台机器上

## 安装

```bash
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-6.3.2-x86_64.rpm
sudo rpm -vi metricbeat-6.3.2-x86_64.rpm
# 启停及状态
sudo service metricbeat start
sudo service metricbeat status
sudo service metricbeat stop
```

## 配置

`/etc/metricbeat/metricbeat.yml` 主要需要修改的配置如下：

```yaml
#============================== Kibana =====================================
setup.kibana:
  host: "http://10.48.78.172:5601"
#================================ Outputs =====================================
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  hosts: ["10.48.78.172:9200"]
```

## 日志 

`tail -100f /var/log/metricbeat/metricbeat`

## 导入默认图表

```bash
# 导入metricbeat默认图表
metricbeat setup --dashboards
```

## 添加不同的监控模块

```bash
# 添加不同监控模块，将以下目录对应配置文件的disable去掉
/etc/metricbeat/modules.d
```

