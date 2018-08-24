[TOC]

# python

许多大型网站就是用Python开发的，例如YouTube、Instagram，还有国内的豆瓣。很多大公司，包括Google、Yahoo等，甚至NASA（美国航空航天局）都大量地使用Python。

google在2006年开始大力支持python的发展，python的开发生态成熟，有很多有用的库可以用。

python基本上可以说全能，系统运维、图形处理、数学处理、文本处理、网络编程、web编程、多媒体应用、黑客编程、爬虫编写、机器学习、人工智能等等。

不适用于贴近硬件(C)、手机APP、游戏(C,C++)。

**为何人工智能偏好python**：因为研究人员不都是码农，需要一种简单而有效的语言把想法快速实现，Python刚好是这样一种语言。如果真正需要更高的效率或者商用，完全可以把思想移植到c、c++或者Java语言上重新开发，说白了Python就是用来实现原型系统的一种语言。

**学习点**：语法，正则，IO，多线程，网络访问，数据库，爬虫库，图片识别......

**需求驱动**：爬虫、运维脚本

# 资料

## 文档

- 官网：[https://www.python.org](https://www.python.org)
- 廖雪峰：[https://www.liaoxuefeng.com](https://www.liaoxuefeng.com)
- python入门视频教程：https://www.imooc.com/learn/177
- python进价视频教程：https://www.imooc.com/learn/317
- python开发简单爬虫视频教程：https://www.imooc.com/learn/563
- python-走进Requests库：https://www.imooc.com/learn/736
- python数据分析-基础技术篇视频教程：https://www.imooc.com/learn/843
- python cookbook中文版：https://github.com/yidao620c/python3-cookbook


## 示例

python3-cookbook



# 语法

python入门视频教程：<https://www.imooc.com/learn/177>

python进阶视频教程：<https://www.imooc.com/learn/317>

## 基本数据类型

- 整数
- 浮点数
- 字符串 ，单引号或双引号
- 布尔值，**短路计算**，`True`与`False`，`and`、`or`、`not`。`0`、`''`、`None`都为`False`，其它为`True`
- 空值，`使用None来表示`

## raw字符串

```python
# 前缀r表示raw字符串，不需要转义
# 使用'''内容'''表示多行
print ('Line 1\nLine 2\nLine 3')
print (r'''Line 1
Line 2
Line 3''')
```

## 编码

在unicode字符串前加u或在文件开头加一行注释

`print (u'中文')`

```python
# -*- coding: utf-8 -*-
print ('中文')
```

## 条件判断与循环

Python代码的缩进规则。具有相同缩进的代码被视为代码块。缩进必须为4个空格（不能为tab）

`if`条件可以不需要括号，以`:`表示代码块开始

```python
if age >= 18:
    print 'adult'
elif age >= 6:
    print 'teenager'
elif age >= 3:
    print 'kid'
else:
    print 'baby'
```

**循环**与`if`类似，`:`表示代码块开始，缩进为代码块

`break`、`continue`、多重循环，正常使用

```python
L = [75, 92, 59, 68]
sum = 0.0
for score in L:
    sum += score
print sum / 4

sum = 0
x = 1
while x < 100:
    if x % 2 != 0:
        sum += x
    x += 1
print sum
```

## 集合

### list与tuple

顺序单列集合，类似java的List

list使用`[]`，创建后，可以修改。

tuple使用`()`，创建后，不能修改，但其元素自己内部不限制；类似java中final限制的数组。

集合大小`len(['Michael', 100, True])`

```python
# list
print (['Michael', 100, True])
L = ['Michael', 100, True]
print (L[0],L[1],L[2])
print (L[-1],L[-2],L[-3]) # 倒序
L.append('Paul') # 添加新元素
print (L)
L.insert(3,'Paul2') # 插入新元素到指定位置
print (L)
L.pop(3) # 删除指定位置的元素
print (L)
L.pop() # 删除最后的元素
print (L)
L[-1] = False # 替换元素
print (L)

# 遍历
for i in L:
    print (i)
    
# 遍历，包含索引
# enumerate函数把List中的每个元素  变成  索引与元素的tuple
for index, name in enumerate(L):
    print (index, '-', name)

# tuple
print (('Michael', 100, True))
print ((1,)) # 单元素，添加逗号，以避免歧义
```

### Dict

key-value集合，类似java的Map

- 速度快，以空间换时间
- 无顺
- key必须不可变，tuple中的每个元素都是不可变才可以

```python
# 定义Dict，无顺集合
d = {
    'Adam': 95,
    'Lisa': 85,
    'Bart': 59
}
print (d['Adam'])
print (d.get('Bart'))
print (d.get('Paul')) # None
# 先判断是否存在key
if 'Lisa' in d:
	print (d['Lisa'])

for (key,value) in d.items():
    print (key, str(value))

for key in d:
    print (key, str(d[key]))

# 添加
d['Paul'] = 72
print (d)
# 更新
d['Paul'] = 80
print (d)

```

### Set

自动去重，无顺，单例集合

与Dict的key类似，必须是不变对象

```python
# 定义有重复元素的Set集合
s = set(['A', 'B', 'C', 'C'])
print (s)  # 输出去掉了重复项

print ('A' in s) # 判断是否在Set集合中
print ('D' in s) 

# 添加
s.add('G')
print (s)
# 删除，若不存在会报错
s.remove('G')
print (s)

# 遍历
s = set([('Adam', 95), ('Lisa', 85), ('Bart', 59)])
for x in s:
    print (x[0], ":", x[1])

```

### 切片(Slice)

取集合的子集，List与Tuple都一样使用

`List[startIndex:endIndex:interval]`

- `startIndex`: 开始索引，包含该元素。从0开始，若为0，可省略，但冒号不能省
- `endIndex`: 结束索引，不包含该元素
- `interval`: 每多少个元素取一个，可选

**示例**：

```python
# 从1到100的数列
L = range(1,101)
# 取前10个数
L[:10]
# 取3的倍数
L[2::3]
# 取小于50的5的倍数
# 从0开始，不包含endIndex
L[4:49:5]
```

**倒序切片**

既然python支持L[-1]取倒数第一个元素，那么它同样支持倒数切片

```python
L = [1,2,3,4,5,6,7,8,9,10]
# 最后2位
L[-2:]  # 9,10
# 第一个到倒数第3个
L[:-2]  # 1,2,3,4,5,6,7,8
# 倒数第4个到倒数第2个
L[-4:-1]  # 7,8,9
#　倒数第4个到倒数第2个，每2个取1个
L[-4:-1:2]  # 7,9
```

**字符串切片**

unicode字符串可以看作是一种List，每个元素就是一个字符。

```python
# 返回只有首字母大写
def firstCharUpper(s):
    return s[:1].upper() + s[1:].lower()

print (firstCharUpper('hello'))
print (firstCharUpper('sunday'))
print (firstCharUpper('september'))
```

### 生成列表

一行语句生成集合

```python
# 生成[1x1, 2x2, 3x3, ..., 10x10]
[x * x for x in range(1, 11)]
# 生成列表 [1x2, 3x4, 5x6, 7x8, ..., 99x100]
[x * (x + 1) for x in range(1,100,2)]

# 生成['Adam:95', 'Lisa:85', 'Bart:59']
d = {
    'Adam': 95,
    'Lisa': 85,
    'Bart': 59
}
['%s:%s' % (name, score) for name, score in d.items()]

# 添加条件过滤
# 只生成偶数的平方 数列
[x * x for x in range(1, 11) if x % 2 == 0]

# 如果为字符串，则大写
L = ['Hello', 'world', 101]
[i.upper() for i in L if isinstance(i,str)]

# 多层for循环
# 对字符串ABC与123进行全排列
# ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']
[m + n for m in 'ABC' for n in '123']
```



##　函数

### 示例

- 函数定义
- 返回多值，tuple
- 默认参数，在最后
- 可变参数，tuple

```python
# 定义函数，返回列表各元素平方的和
def square_of_sum(L):
    s = 0
    for item in L:
        s += item * item
    return s

print square_of_sum([1, 2, 3, 4, 5])
print square_of_sum([-5, 0, 5, 15, 25])

# 返回多值，为一个tuple
def f():
    return 1,2,3

print (f())  # tuple

# 定义默认参数
# 默认参数只能定义在必需参数的后面
def greet(name='world'):
    print ('hello, ' + name + '.')

greet()
greet('Bart')

# 定义可变参数，参数名前加*号
# 在函数内部，参数就是一个tuple
def average(*args):
    if args:
        return sum(args) / len(args)
    return 0.0

print (average())
print (average(1, 2))
print (average(1, 2, 2, 3, 4))

```

### 自带函数

### 闭包

### 装饰器

```python
import time
from functools import reduce


def performance(unit):
    def performance_decorator(f):
        def wrapper(*args, **kw):
            print('call %s() in %s%s' % (f.__name__, time.time(), unit))
            return f(*args, **kw)
        return wrapper
    return performance_decorator


@performance('s')
def factorial(n):
    return reduce(lambda x, y: x * y, range(1, n + 1))


print(factorial(10))

```

# 面向对象



# 模块



https://pypi.python.org/pypi

```
pip install requests
```

## re



## os



## pymysql



## requests



# 爬虫

Scrapy



# web

vue + Django + mysql



# GUI

