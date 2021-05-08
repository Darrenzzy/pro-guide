mac下查看打开文件数
查看：sysctl kern.maxfiles
修改：sudo sysctl -w kern.maxfiles=1048600

查看：sysctl kern.maxfilesperproc
修改：sudo sysctl -w kern.maxfilesperproc=1048576

查看：ulimit -n
修改：ulimit -n 1048576
