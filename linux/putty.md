
# putty

<https://www.putty.org/>

# 密码登录bat脚本

在`putty.exe`所在目录创建子目录

文件命名： `xxx(username[password]@host).bat` 其中username为用户，password为密码，host为IP

示例：

- centos6.5(chencye[chen123]@192.168.1.101).bat
- centos7(chencye@192.168.1.102).bat

```bash
@echo off

set filename=%~n0
set char1="("
set char2="["
set char3="]"
set char4="@"
set char5=")"

call :last_index %filename% %char1% result1
call :last_index %filename% %char2% result2
call :last_index %filename% %char3% result3
call :last_index %filename% %char4% result4
call :last_index %filename% %char5% result5

if %result2% equ 0 (call :resolveWithoutPwd username password host) else (call :resolve username password host)
goto startPutty

:resolve
setlocal EnableDelayedExpansion
    set /a username_len=%result2%-%result1%-1
    set username=!filename:~%result1%,%username_len%!
    set /a password_len=%result3%-%result2%-1
    set password=!filename:~%result2%,%password_len%!
    set /a host_len=%result5%-%result4%-1
    set host=!filename:~%result4%,%host_len%!
endlocal & set %1=%username% & set %2=%password% & set %3=%host%
goto :EOF

:resolveWithoutPwd
setlocal EnableDelayedExpansion
    set /a username_len=%result4%-%result1%-1
    set username=!filename:~%result1%,%username_len%!
    set /a host_len=%result5%-%result4%-1
    set host=!filename:~%result4%,%host_len%!
endlocal & set %1=%username% & set %2=%username% & set %3=%host%
goto :EOF

:strlen
setlocal
    set /a len=0
    set content=%~1
    :_strlen_next
    if not "%content%"=="" (
        set /a len+=1
        set "content=%content:~1%"
        goto _strlen_next
    )
endlocal & set %2=%len%
goto :EOF

:last_index
setlocal EnableDelayedExpansion
    set content=%~1
    set char=%~2
    set len=0
    call :strlen %content% len
    :_last_index_next
        if not "%content%"=="" (
        if "!content:~-1!"=="%char%" goto _last_index_last
        set /a len-=1
        set "content=%content:~0,-1%"
        goto _last_index_next
        )
        set /a len=0
    :_last_index_last
endlocal & set %3=%len%
goto :EOF

:startPutty
cd ..
start putty.exe %host% -l %username% -pw %password%
```
