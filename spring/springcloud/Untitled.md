
java -jar eureka-server-1.0-SNAPSHOT.jar --spring.profiles.active=8081
java -jar eureka-server-1.0-SNAPSHOT.jar --spring.profiles.active=8082
java -jar eureka-server-1.0-SNAPSHOT.jar --spring.profiles.active=8083

http://www.cnblogs.com/ityouknow/p/6859802.html  
http://blog.didispace.com/Spring-Cloud基础教程/


独立模式使用
    registerWithEureka: false
    fetchRegistry: false

