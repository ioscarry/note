# 使用

## 配置文件


## spring-boot

示例中使用的是1.5.3.RELEASE版本，无需特殊的依赖包  

启用schedule并配置线程池  
```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

@SpringBootApplication(scanBasePackages = "com.github.chencye")
@EnableScheduling
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    /**
     * 配置spring scheduling使用的的线程池
     *
     * @param size
     *            线程池大小
     * @return
     */
    @Bean
    public Executor taskExecutor(@Value("${spring.taskExecutor.poolSize}") int size) {
        return Executors.newScheduledThreadPool(size);
    }
}
```

配置定时任务  
```java
import org.springframework.scheduling.annotation.SchedulingConfigurer;
import org.springframework.scheduling.config.ScheduledTaskRegistrar;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * <pre>
 * spring scheduling 定时执行任务
 * 线程池，在com.github.chencye.app.ftp.Application中配置
 * </pre>
 *
 * @author chencye 2017-07-01 22:39:22
 */
@Component
public class ScheduledTask implements SchedulingConfigurer {

    @Override
    public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
        taskRegistrar.addCronTask(() -> {
            System.out.println("task begin... " + Thread.currentThread().getName());
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("task end!!!!! " + Thread.currentThread().getName());
        }, "0/1 * * * * *");
    }

}
```

# 问题

设置线程池为3，

添加60000个crontask，定时1秒，每个crontask中休眠1分钟

dump堆，没发现特殊情况

