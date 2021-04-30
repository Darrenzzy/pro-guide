source ~/.profile


##################### chubao ###########################

alias wk='/Users/darren/Downloads/xmrig-6.8.2/xmrig'


#其他内部框架依赖的环境变量
export ELETE_PROXY_HOST=elete-proxy-dev.cootekos.com:1921 #访问测试环境其他模块的
export CUSTOM_RUNTIME_ENV=dev #开发环境
export LOCATION=cn #中国区
export CONF_SERVER=not-conf-server # 配置服务器地址, 本次开发用不到
export CONF_ELETE_HTTP_SERVER_PORT=8080   #http 模块启动后的默认监听地址.如果没有设置这个变量,默认是 80 端口
export CUSTOM_RUNTIME_ENV=DEV
export CONF_SERVER=not-conf-server
export SERVICE=..........安全第一
export APOLLO_ACCESSKEY_SECRET=..........安全第一
export STDERR_REDIRECT=0
export HOSTNAME=127.0.0.1

export CUSTOM_RUNTIME_ENV=DEV
alias www='/Users/darren/go/src/caishenweather'
alias cdswag='/Users/darren/go/src/testgo/modgo/swag'
alias sscc='ssh jumper'

function coollog(){
#	ddssh jumper "$(cat);" 
		typeset $1 | ssh jumper "$(cat); $1"
	 $1
	
	
}

function autoproto(){
	cd protobuf;
	./protoc.sh;
	1
}

function tflog {
	cd ~/ssd/..........安全第一;
	if [[ $1 = "tf" ]] ;then
	tail -f $(ls ~/ssd/..........安全第一darweather  |grep $2 |head -n 1)
	else
		less $(ls ~/ssd/..........安全第一darweather  |grep $2 |head -n 1)
	fi

}

##################### chubao end ###########################
##################### source something ###########################

#批量更新指定脚本 #for file in ~/.{path,bash,exports,aliases,functions,extra}; do
for file in {/Users/darren/projects/baolei/lib/completion.bash,~/.profile}; do
[ -r "$file" ] && source "$file"
done
unset file


##################### start  alias ###########################

#docker
alias docll='cat /Users/darren/.oh-my-zsh/plugins/docker-compose/docker-compose.plugin.zsh'
alias dockerlog='docker logs -tf --tail 10 '
alias dockerps='docker ps -a  --format "table {{.ID}}\t{{.Names}}\t{{.Ports}}\t{{.Status}}"'

#golang 相关
alias go-guide='/Users/darren/go/src/build-web-application-with-golang/zh'
alias go-deploy='/Users/darren/go/src/deploy'
alias govendor='/Users/darren/go/src/vendor/laoyuegou.pb'
alias gateway='/Users/darren/go/src/iceberg/gateway'
alias gosrc='/Users/darren/go/src'
alias goss='/Users/darren/go/src/gitlab.corp.laoyuegou.com/go'
alias gotest='/Users/darren/go/src/testgo'
alias pbgen="protoc --go_out=plugins=irpc:. *.proto"
alias pbg="protoc --go_out=plugins=grpc:. *.proto"
alias pbgenswagger="pbgen && swagger generate spec -o ./$(basename $(pwd)).json"
alias cdswag="/Users/darren/go/src/testgo/modgo/swag"

#ssh快速链接
alias sshxihe='ssh root@47.52.75.114'
alias sshkepin='ssh root@121.43.101.28'
alias sshnewu='ssh root@119.28.10.43'

#go服务器
alias go-dev='ssh land@172.16.164.220'
alias go-test='ssh land@172.16.164.248'
alias go-stag1='ssh land@172.16.164.179'
alias go-game='ssh land@121.43.39.155'
alias go-gameserver='ssh land@172.16.164.139'


#自定义快捷命令
alias ppp='cd ~/projects'
alias guide='cd ~/projects/guide'
alias duhd='du -h -d 1'
alias ppsql='psql -U postgres'
alias rrm='rm -rf '
alias sss_bash_profile='source ~/.bash_profile'
alias pps='ps -ef |grep '
alias tf='tail -f '
alias ll='ls -alh'
alias kk='ls -all'
alias cc='clear'
alias ls='ls -G'
alias vimbash_pro='vim ~/.bash_profile'
alias ppc='php cli.php'
alias varlog='cd /usr/local/var/log'
alias mamplog='/Applications/MAMP/logs'
alias 查的='cd '
alias dul='du -d 1 -h' #查看当前目录下所有目录大小
alias wgetfile='wget --no-check-certificate --content-disposition '
alias curlfile='curl  -LJO '


# 公司项目
alias lyg_ceshi='ssh land@118.178.128.61'
alias lyg_order_prod='ssh land@172.16.34.15' #./jumpto lyg_php_gray
alias activity_lyg_test='ssh land@172.16.164.39' # ./jumpto lyg-activity-test
alias hui-proxy='ssh land@172.16.164.40 ' #./jumpto zentao-pms-p-01
alias log_lyg='ssh land@172.16.163.58' #'./jumpto vpcplayground_01' oxpp后台
alias order_php_ssh_lyg='ssh land@172.16.164.209' # './jumpto  vpcplayground_10'
alias play_admin_lyg_ssh='ssh land@172.16.163.255'  #./jumpto peiwan_om_test

#redis地址
alias rdscool_test='redis-cli  -h 192.168.10.15 -p 8101'
alias rdweather='redis-cli  -h 192.168.10.15 -p 8111'


###################### end  alias ###########################




##################### start  export ###########################

#golang
export GOPATH=/Users/darren/go
#export GOPATH=/Users/darren/go/src/elete_go
export GOROOT=/usr/local/go
#export GOPRIVATE=gitlab.corp.laoyuegou.com
#export GO111MODULE=auto
#导入 GO111MODULE=on  不使用GOPATH运行否则请手动下载下一步的包 用于go get 命令
export GO111MODULE=on
export PATH=$PATH:/Users/darren/go/bin
export GOPROXY=https://goproxy.cn,direct
export GOPRIVATE="gitla.....安全第一.....om"
export GONOPROXY="gitla.....安全第一.....om"
export GONOSUMDB="gitla.....安全第一.....om"

#python
alias py="/usr/local/opt/python@3.9/Frameworks/Python.framework/Versions/3.9/bin/python3"
alias python="/usr/local/opt/python@3.9/Frameworks/Python.framework/Versions/3.9/bin/python3"
alias python-config="/usr/local/opt/python@3.9/Frameworks/Python.framework/Versions/3.9/bin/python3-config"


#快速brew源
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

#使用到的环境变量
export PATH=$PATH:/usr/local/sbin
export PATH=/usr/local/openresty/nginx/sbin:$PATH
export PATH=/Users/darren/src/kafka2.11-1.1.1/bin:$PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/Users/darren/src/apache-maven-3.5.4/bin  #maven的路径
export PATH=$PATH:~/src/apache-tomcat-8.5.34/bin 
export PATH=$PATH:/usr/local/lib/node_modules/eslint/bin
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:/Users/darren/src/icomet-master
export PATH=$PATH:/usr/local/nginx/sbin
export PATH=$PATH:/Users/darren/src/redis-5/src
# ruby brew 
export PATH=/usr/local/opt/ruby/bin:$PATH
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export DISPLAY=:0


###################### end  export ###########################


###################### start  function ###########################


function redis-start(){
	redis-server /Users/darren/projects/guide/config-files/redis.conf
}


function sshinit(){
#遍历添加用户登录时添加本地秘钥
	for file in `ls ~/.ssh/id_rs* |grep -v pub`
		do
			[ -r "$file" ] && ssh-add  "$file"
				done
					unset file
}


#自动导入 vimrc 配置
function open_vimrc(){
	echo "先导入vim配置文件";
	cp /Users/darren/projects/guide/config-files/vimrc.conf ~/.vimrc;
	source ~/.vimrc;

}
###################### end  function ###########################

###################### start other ###########################

#终端代理配置 开启后每次打开终端都生效
function proxy {
	if [[ $1 = "on" ]]; then
		export http_proxy=http://127.0.0.1:8002
			export https_proxy=http://127.0.0.1:8002
			curl ifconfig.co
#      curl ip.gs
			echo -e "已开启代理" http_proxy=$http_proxy https_proxy=$https_proxy

			elif [[ $1 = "off" ]]; then
			unset http_proxy
			unset https_proxy
			echo -e "已关闭代理"
			elif [[ $1="git" ]];then
			git config --global http.https://github.com.proxy https://127.0.0.1:8002
			git config --global https.https://github.com.proxy https://127.0.0.1:8002
			echo -e "已经开启 git"
	else
		echo -n "Usage: proxy [on|off] "
			fi
}

#/Users/darren/.oh-my-zsh/themes/robbyrussell.zsh-theme 这里是直接篡改主题显示的配置 以下任意终端都生效：
PROMPT='$(date "+%H:%M:%S") ${ret_status}%{$fg[cyan]%}%d$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

###################### end  other ###########################
