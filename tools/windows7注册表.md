# 注册表

`C:\Windows\regedit.exe`

1. `HKEY_CLASSES_ROOT` 包含注册的所有OLE信息和文档类型，是从 `hkey_local_machine\software\classes`复制的。
2. `HKEY_CURRENT_USER` 包含登录的用户配置信息，是从`hkey_users\`当前用户子
  树复制的。
3. `HKEY_LOCAL_MACHINE` 包含本机的配置信息。其中config子树是显示器打印机信息； enum子树是即插即用设备信息；system子树是设备驱动程序和服务参数的控制集合；software子树是应用程序专用设置。
4. `HKEY_USERS` 所有登录用户信息。
5. `HKEY_CURRENT_CONFIG` 包含常被用户改变的部分硬件软件配置，如字体设置、显示器类型、打印机设置等。是从`hkey_local_machine\config`复制的。

`HKEY_CLASSES_ROOT\*\shell` 在任意文件或文件夹上右键菜单显示  
`HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Folder\MenuMgr\Shell` 右键文件夹时显示  
`HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell` 右键文件夹时显示  
`HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell` 右键文件夹内空白位置显示  
`Hkey_local_machine\software\microsoft\windows\currentVersion\run` 开机后自动启动的程序  

## 添加右键菜单

### 添加脚本

注意脚本编码要与系统编码一致，中文环境windows一般为GBK

```basic
Windows Registry Editor Version 5.00

; 添加【CMD】选项到右键菜单

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\01 cmd]
@="-----CMD-----"
; 可以类似如下添加图标
; "Icon"="C:\cmd.ico"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\01 cmd\command]
@="cmd.exe"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\01 cmd]
@="-----CMD-----"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\01 cmd\command]
@="cmd.exe"

; 添加【复制路】径选项到右键菜单

[HKEY_CLASSES_ROOT\*\shell\02 CopyAsPath]
@="-----复制路径-----"

[HKEY_CLASSES_ROOT\*\shell\02 CopyAsPath\command]
@="cmd.exe /c (echo.|set /p=\"%1\")|clip"
; 【cmd.exe /c echo "%1"|clip】为有双引号及CR与LF符号
; 【cmd.exe /c echo %1|clip】为无双引号，有CR与LF符号

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\02 CopyAsPath]
@="-----复制路径-----"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\02 CopyAsPath\command]
@="cmd.exe /c (echo.|set /p=\"%1\")|clip"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\02 CopyAsPath]
@="-----复制路径-----"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\02 CopyAsPath\command]
@="cmd.exe /c (echo.|set /p=\"%V\")|clip"
```

### 删除脚本

```basic
Windows Registry Editor Version 5.00

; 删除右键菜单自定义的【CMD】选项

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\01 cmd]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\01 cmd]


; 删除右键菜单自定义的【复制路】选项

[-HKEY_CLASSES_ROOT\*\shell\02 CopyAsPath]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\shell\02 CopyAsPath]

[-HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\02 CopyAsPath]
```

## 添加开机启动项

### 添加脚本

```basic
Windows Registry Editor Version 5.00

; 添加开机后自动启动程序

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]
"01 music"="C:\\Program Files (x86)\\网易云音乐PC版\\cloudmusic.exe"
"02 explorer"="C:\\Windows\\explorer.exe"
"03 chrome"="C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"
"04 wechat"="C:\\Program Files (x86)\\Tencent\\WeChat\\WeChat.exe"
```

### 删除脚本

```basic
Windows Registry Editor Version 5.00

; 删除开机后自动启动程序

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run]
"01 music"=-
"02 explorer"=-
"03 chrome"=-
"04 wechat"=-
```

## 隐藏资源管理器左侧各项

由于权限问题，需要手动添加权限后再修改。建议手动修改，修改完毕后，权限修改回去。  
1. `ShellFolder`项右键选择【权限】  
2. 选择`【Users (chencye-PC\Users)】`  
3. 勾选允许列下的`【完全控制】`  
4. 确定返回，之后再修改`Attributes`值  

### 隐藏脚本

```basic
Windows Registry Editor Version 5.00

; 隐藏资源管理器左侧各项

; 收藏夹，Attributes由a0900100变更为a9400100
; [HKEY_CLASSES_ROOT\CLSID\{323CA680-C24D-4099-B94D-446DD2D7249E}\ShellFolder]
; "Attributes"=dword:a9400100

; 库，Attributes由b080010d变更为b090010d
[HKEY_CLASSES_ROOT\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}\ShellFolder]
"Attributes"=dword:b090010d

; 家庭组，Attributes由b084010c变更为b094010c
[HKEY_CLASSES_ROOT\CLSID\{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}\ShellFolder]
"Attributes"=dword:b094010c

; 计算机，Attributes由b084010c变更为b094010c
[HKEY_CLASSES_ROOT\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\ShellFolder]
"Attributes"=dword:b094010c

; 网络，Attributes由b0040064变更为b0940064
[HKEY_CLASSES_ROOT\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder]
"Attributes"=dword:b0940064
```
