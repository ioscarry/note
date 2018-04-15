# 快捷键

**`IntelliJ IDEA` 官方出的学习辅助插件：`IDE Features Trainer`**

`Ctrl+Alt+剪头`: 前进后退

`Ctrl+Alt+H`: 查询某方法被其它地方调用

`Ctrl+N`: 定位文件，文件名后加`:数字`跳到指定行

`psvm`: 快速输入main函数

` Ctrl+J`: 键入 main再按，快速输入main函数

`sout `: 快速输入System.out.println

`fori`: 快速生成普通for循环

`iter`: for-each循环

`F11`: 添加书签

# 配置

需要初始界面设置，不能打开项目后再设置，不然一此设置项目会不启作用  

0. 设置个性化配置目录及系统文件目录  
[IntelliJ IDEA 相关核心文件和目录介绍](http://www.phperz.com/article/15/0923/159061.html)  
`idea.config.path=${user.home}/.IntelliJIdea/config`，该属性主要用于指向 IntelliJ IDEA 的个性化配置目录，默认是被注释，打开注释之后才算启用该属性，这里需要特别注意的是斜杠方向，这里用的是正斜杠。  
`idea.system.path=${user.home}/.IntelliJIdea/system`，该属性主要用于指向 IntelliJ IDEA 的系统文件目录，默认是被注释，打开注释之后才算启用该属性，这里需要特别注意的是斜杠方向，这里用的是正斜杠。如果你的项目很多，则该目录会很大，如果你的 C 盘空间不够的时候，还是建议把该目录转移到其他盘符下。  
`idea.max.intellisense.filesize=2500`，该属性主要用于提高在编辑大文件时候的代码帮助。IntelliJ IDEA 在编辑大文件的时候还是很容易卡顿的。  
`idea.cycle.buffer.size=1024`，该属性主要用于控制控制台输出缓存。有遇到一些项目开启很多输出，控制台很快就被刷满了没办法再自动输出后面内容，这种项目建议增大该值或是直接禁用掉，禁用语句`idea.cycle.buffer.size=disabled`。  

1. 设置主题  
  `Settings | Appearance & Behavior | Appearance`  

2. 不自更新  
  `Settings | Appearance & Behavior | System Settings | Updates`  

3. 设置字体  
  `Settings | Editor | Colors & Fonts | Font`  Colsolas 16  
  `Settings | Editor | Colors & Fonts | Console Font`  

4. 设置github账号  
  `Settings | Version Control | GitHub`  

5. 设置Maven  
  `Settings | Build,Execution,Deployment | Build Tools | Maven`  
  设置 Maven home directory 为绝对路径地址  
  设置 User settings file为Maven home下的conf/settings.xml配置  
  设置 User settings file 与 Local repository 为Override  
  `Settings | Build,Execution,Deployment | Build Tools | Maven | Importing`  
  设置自动下载源码及文档 

6. 设置diff为Beyond Compared  

7. 不显示`.idea`与`iml`文件  
  `Settings | Editor | File Types --> Ingore files and folders`  
  在后面添加 `*.idea;*.iml;`  

8. 设置默认换行格式  
  `Settings | Editor | Code Style --> Line Separator`  

9. 设置propeties文件默认编码为UTF-8  
  `Settings | Editor | File Encodings `  

10. 安装markdown插件  
[IntelliJ IDEA Multi-MarkDown插件安装破J全过程](http://www.jianshu.com/p/a0550f81cbd1)  



# 注册

附 IntelliJ IDEA 2016.2.1 注册码  

[http://idea.lanyus.com/](http://idea.lanyus.com/)

https://www.imsxm.com



## 学生版本授权

<https://www.jetbrains.com/idea/buy>  （JetBrains购买页面）

<https://free.kirito.edu.rs>    （临时邮箱）



教程：<https://github.com/rogetsun/IdeaRegister>

