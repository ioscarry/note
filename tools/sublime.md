<https://www.zybuluo.com/king/note/47271>

# 常用的快捷键

四种 Goto：
- Ctrl + P 文件定位
- Ctrl + ; 词语定位
- Ctrl + R 函数定位
- Ctrl + G 行号定位

括号前后移动光标：`Ctrl + M`
以单词为单位前后移动光标：Ctrl + Left/Right
Ctrl+→ 向右单位性地移动光标，快速移动光标。
重新打开刚刚关闭的标签页：Ctrl + Shift + T
当前行与上/下一行交换位置：Shift + Ctrl + Up/Down
向光标前插入一行：Shift + Ctrl + Enter
向光标后插入一行：Ctrl + Enter
复制光标所在整行，插入到下一行：Ctrl + Shift + D
合并选中的多行代码为一行：Ctrl + J
快速折叠文件内所有函数：Ctrl + K + 1 （数字表示级别）

# 配置

```json
{
    // 开启选中范围内搜索
    "auto_find_in_selection": true,
    // 侧边栏文件夹显示加粗，区别于文件
    "bold_folder_labels": true,
    "color_scheme": "Packages/Color Scheme - Default/Mariana.sublime-color-scheme",
    "default_encoding": "UTF-8",
    // 使用 unix 风格的换行符
    "default_line_ending": "unix",
    // 保证在文件保存时，在结尾插入一个换行符。
    // 这样 git 提交时不会生产额外的 diff
    "ensure_newline_at_eof_on_save": true,
    // 默认显示行号右侧的代码段闭合展开三角号
    "fade_fold_buttons": false,
    "font_face": "consolas",
    "font_size": 12,
    // 当前行高亮
    "highlight_line": true,
    // 窗口失焦立即保存文件
    "save_on_focus_lost": true,
    // 自动移除行尾多余空格
    "trim_trailing_white_space_on_save": true,
    "trim_automatic_white_space": true,
    "line_numbers": true,
    "show_encoding": true,
    "show_tab_close_buttons": true,
    "spell_check": false,
    // Tab转空格
    "translate_tabs_to_spaces": true,
    "tab_size": 4,
    // 不自动换行
    "word_wrap": "false",
    "theme": "Soda Dark 3.sublime-theme",
}
```

# 插件

sdf
