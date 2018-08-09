[TOC]

<https://git-scm.com/book/zh>

# 配置

```bash
git config --global core.autocrlf input
git config --global pull.rebase true
```

## 配置用户名密码

```bash
cat ~/.gitconfig
# cat .git/config

git config --list

git config --global user.name "example"
git config --global user.email "example@example.com"

git config --global credential.helper store read-only
cat ~/.git-credentials
```

## 配置别名

```bash
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

git config --global alias.new 'checkout -b'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --color --graph --pretty=format:"%Cred%h %Cgreen%ad%Creset %s %C(bold blue)<%cn>" --date=format:"%Y-%m-%d %H:%M:%S" -5'

git log --pretty=format:"%h %ad %cn %s" -3 --name-status

git config --global alias.pl 'pull --rebase main master'
git config --global alias.ps 'push origin HEAD'

```

# 命令

## 提交

```bash
git commit -m "commit"
git add readme.md
# 添加到最后的提交中
git commit --amend
```

## 撤消

```bash
git reset HEAD <file>...
git reset remoteName/branchName <file>...

git reset --hard <file>...  # 危险命令 可能导致工作目录中所有当前进度丢失！
git checkout -- <file>... # 危险命令 拷贝了另一个文件来覆盖它
```

## 推送

```bash
# 强制推送
git push --force origin master
```

# 分支

```bash
# 添加远程主库，并设定不允许推送
git remote -v
git remote add main http://github.com/main.git
git remote set-url --push main no-push

git branch --unset-upstream

# 创建并切换到新分支
git checkout -b newBranchName

# 查看分支列表
git branch -v
git branch -vv

# 从main库的master分支更新到当前本地分支
git fetch main
git rebase main/master

# 删除远程分支
git push origin :branchName
```

## 变基

```bash
git config --global pull.rebase true
# 相当于
git fetch
git rebase remoteName/branchName
```

# 历史

```bash
git log --since="2018-05-01"
git log --before="2018-05-01"
git log -S 搜索文件内容
git log --grep 搜索日志内容

```
