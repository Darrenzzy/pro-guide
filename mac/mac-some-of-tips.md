## MAC常用

### 终端输出到剪贴板
 echo test | pbcopy
粘贴打印：
 pbpaste

### chrome 

- 快速清除网络日志
	按两下 cmd+e 
- 快速打开网络network
	cmd+opt+i


### macOS的开机启动脚本所在位置
```
~/Library/LaunchAgents
/System/Library/LaunchAgents/
/System/Library/LaunchDaemons/
/Library/LaunchAgents/
/Library/LaunchDaemons/
```

mac下面pdf转jpg:

sips -s format jpeg xxx.pdf --out xxx.jpg

ffmpeg压缩视频:

ffmpeg -i concat_ns.mp4 -vcodec libx264 -preset slow -crf 28 -y -vf "scale=1280:-1" -acodec libmp3lame -ab 128k a.mp4

合并视频:
##list.txt内容格式
file a.mp4
file b.mp4
...

ffmpeg -f concat -i list.txt -c copy concat.mp4

yum install perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker

快速查询配置文件:
strace -eopen /usr/local/nginx/sbin/nginx 2>&1 | grep conf

配置sudo免密码:

sudo vim /etc/sudoers
在最后加入
username            ALL = (ALL) NOPASSWD: ALL

查看当前mac硬件信息cpu
sysctl machdep.cpu