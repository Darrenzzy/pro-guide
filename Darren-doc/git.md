# git 基本操作



```
生成ssh秘钥
ssh-keygen -t rsa -C "darren@wx.com" -f ~/.ssh/id_rsa.wx

查看当前本地全部秘钥
ssh-add -l

检查ssh连接问题
ssh -T Host

清空，重启ssh
eval `ssh-agent`
```

```
# 快速看出哪个分支是最新的
git for-each-ref --sort='-committerdate' --format="%(refname:short)%09%(committerdate)"
```

变基其他分支到当前分支，<当前分支>的 commit 更换到 <其他分支> 的后面且重定义新 commit 名字(一般用于非 master 分支，常用于自己的开发多分支上)

 1. git rebase <其他分支> 正常情况没有冲突就直接完事了，有冲突就走第二步
 2. git diff/ status 当前先处理冲突，选用自己或其他code，然后 commit 一下，
 3. git rebase --skip 直接回到当前分支，且在<其他分支> 后自动跟上了

```
添加远程仓库地址
拉取指定分支
git clone -b name http://......
仅拉取最新一次提交 只克隆最新的提交记录
git clone --branch <branch_name> <remote-address> --depth 1

显示出branch1和branch2中差异的部分
git diff branch1 branch2 --stat

显示指定文件的详细差异
git diff branch1 branch2 具体文件路径

查看branch1分支有，而branch2中没有的log
git log branch1 ^branch2
git log branch1...branch2

本地已提交看变动
git diff --cached

删除已经add提交的缓存，让git status 回归
git rm -rf --cached path/

回退指定文件
git checkout ./filename
若文件删除 从指定分支回退
git checkout develop -- filename
强制切换分支
git checkout -f
回退文件到指定版本号
git checkout commitId file
将在未push提交的撤销  一次
git reset --soft HEAD^
重置当前分支
git reset --hard origin/master
当前分支回退版本(回退3个版本 就用HEAD~3 )
git reset --hard HEAD\^
撤回重定义历史制定本版内容，不影响该版本后面的提交，可以重新 commit
git revert -n commitId
清空当前本地所有变更
git clean -df
则可以使用-u选项指定一个默认主机，这样后面就可以不加任何参数使用git push
git push -u origin master
本地A分支推送到远程B分支
git push -u origin A:B
git push  -f 强推版本覆盖远程
git push origin tag  标签推送到远程

git commit --amend 更新上次提交的massage文案

更改上次提交的作者
git commit --amend  --author 'zhangsan <zhangsan@gmail.com>'

git 配置全局信息：
git config --global user.name "darren"
git config --global user.email "darren@alibaba.com"
git config --list  查看当前配置情况
git config --local -e  更新本仓库配置信息
git remote rename origin old-origin
git remote add github https://darrenzzy:password@github.com/Darrenzzy/deploy.git
git remote -v 查看远程版本库信息
git remote rm origin 删除远程库

git tag -a 0.0.1 -m 'something....' 打标签
上传标签
git push origin 0.0.1
或者上传全部标签:git push origin --tags

本地删除标签
git tag -d v1.0
删除远程标签
git push origin :refs/tags/v1.0

拉取远程分支到本地分支
 git pull origin dev:Darren
 拉取远程到当前分支
 git pull origin master:
 拉取最新，并归到当前提交的后面
 git pull --rebase
 git pull --rebase origin master

从远程获取最新版本到本地
git fetch origin aaa
具体到拉某一个分支
git fetch origin branch1:branch2

批量删除本地无用分支
 gb |grep -v feat |grep -v hotfix |xargs  -I {} git branch -D {}

查看本地所有分支
git branch  -vv
查看所有分支 和信息
git branch -avvv
绑定当前分支到远程分支
git branch --set-upstream-to=<remote>/<branch> other_bramch

创建分支
git branch new | git checkout -b new  等效
删除本地分支
branch -D old
删除远程分支 先删除本地该分支，在覆盖远程
git branch -r -d origin/branch-name
真正删除远程分支：
git push origin --delete branchname
git push origin :branchname :branch2

git拉取远程分支到本地分支或者创建本地新分支
git checkout origin/remoteName -b localName
或者：git checkout -b new origin/new
git指定tag签出一个分支
git checkout -b [new_branch_name] [tag_name]

git撤销本地所有为更改的提交
git clean -df

仅显示最近的两次更新
git log -p -2
查看历史提交日志
git log --pretty=oneline
或者： git log -p app/Http/Controllers/Admin/AdminController.php

查看每一次提交的详细内容
git log --stat --abbrev-commit

查看历史每个人提交的具体行数
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
可视化查看文件历史提交记录
gitk --follow file


清空历史提交记录：重置仓库，
git add -a
git commit -am 'init'
git branch -D master
git checkout -b master
git push -f origin master

比较远程分支和本地分支
 git log -p aaa origin/aaa
合并远程分支到本地
git merge origin/aaa

合并其他分支 多个提交合并为未提交状态
git merge --squash branch

如果显示拒绝合并和提交时： 在你操作命令后面加--allow-unrelated-histories
eg:  git merge master --allow-unrelated-histories
```

暂存功能
```
git stash 将当前所有修改项(未提交的)暂存，压栈。此时代码回到你上一次的提交
git stash list将列出所有暂存项。
git stash clear 清除所有暂存项。
git stash apply 将暂存的修改重新应用，
git stash drop 2  删除指定暂存版本
```

git提交规范：
```
Message格式：
[type][module]:subject (例如:[feature][大转盘]: 这是一个新的Feature)
Type标识：
feature - 新功能 feature
fix - 修复 bug
docs - 文档注释
style - 代码格式(不影响代码运行的变动)
refactor - 重构、优化(既不增加新功能，也不是修复bug)
Xperf - 性能优化
test - 增加测试
chore - 构建过程或辅助工具的变动
revert - 回退
```

### 规范细则
1. 单次commit只针对单个功能，不要对多个功能进行调整优化
2. 一个功能尽可能合成一次commit
3. commit中必须说明所有改动项
