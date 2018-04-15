`check.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  $1$(tput sgr0)"
}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

app_home=${TOMCAT_HOME}
count=$(jps -lvm | grep ${app_home} | wc -l)
jps -lvm | grep --color ${app_home}

# --------------------------------------------------------------------
print "end ${shell}! count=${count}\n"
exit ${count}
```

`start.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  $1$(tput sgr0)"
}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------
export JAVA_OPTS="-server -Xms800m -Xmx800m"
export JPDA_ADDRESS=7878
# export JPDA_SUSPEND=y
# --------------------------------------------------------------------

app_home=${TOMCAT_HOME}
app_log=${app_home}/logs/catalina.out

print "rm -rf ${app_home}/work/*"
rm -rf ${app_home}/work/*
print "rm -rf ${app_home}/temp/*"
rm -rf ${app_home}/temp/*

echo -e "\n  `date "+%F %H:%M:%S"` start  ---> bash ${app_home}/bin/catalina.sh jpda start <--- \n" >> ${app_log}
print "bash ${app_home}/bin/catalina.sh jpda start"
bash ${app_home}/bin/catalina.sh jpda start

print "tail -10f ${app_log}"
tail -10f ${app_log}

# --------------------------------------------------------------------
print "end ${shell}\n"
```

`kill.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  $1$(tput sgr0)"
}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------
export JAVA_OPTS="-server -Xms800m -Xmx800m"
export JPDA_ADDRESS=7878
# export JPDA_SUSPEND=y
# --------------------------------------------------------------------

app_home=${TOMCAT_HOME}
app_log=${app_home}/logs/catalina.out

echo -e "\n  `date "+%F %H:%M:%S"` stop  ---> jps -lvm | grep ${app_home} | awk 'print \$1' | xargs -I {} kill -9 {} <--- \n" >> ${app_log}
print "jps -lvm | grep ${app_home} | awk '{print \$1}' | xargs -I {} kill -9 {}"
jps -lvm | grep ${app_home} | awk '{print $1}' | xargs -I {} kill -9 {}

# --------------------------------------------------------------------
print "end ${shell}\n"
```

`restart.sh`

```bash
#!/bin/bash
shell_home=$(cd `dirname $0`;pwd)
shell_name=`basename $0`
shell=${shell_home}/${shell_name}
function print() {
    echo -e "\e[36;1m  $1$(tput sgr0)"
}
print "\nbegin ${shell_name}"
# --------------------------------------------------------------------

bash ${shell_home}/check.sh
bash ${shell_home}/kill.sh
bash ${shell_home}/start.sh

# --------------------------------------------------------------------
print "end ${shell}\n"
```

