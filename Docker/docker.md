## Docker 

### 运行docker中容器拥有sudo权限
	docker run  --privileged ...

### mac本地运行docker，用指定目录：
	docker run --platform=linux/amd64 -v /Users/darren/go/src:/root/works -it go120:aaa /bin/bash

### docker 用基础镜像没有telnet问题：
	apk add busybox-extras
* 因为包里没有直接telnet，需要用这个软件会自带telnet 来代替

### docker 本地使用ubuntu系统，已完善各功能组件，直接使用，相当于本地环境
	docker pull darrenzzy/ubunto-git-zsh:latest
	docker run --platform=linux/amd64 -v /go/src:/root/works -v ~/.ssh:/root/.ssh -it  darrenzzy/ubunto-git-zsh  /bin/zsh 

### docker 本地拉去镜像后，运行和使用 =》 再对容器打包 =》在发布镜像

1. 先登录
	docker docker login
2. 给当前运行的容器打镜像
	docker commit 容器ID  apple/img_name
3. 给新的镜像打tag，方便后面推送
	docker tag apple/img_name apple/img_namev1.0
4. 推送镜像到远程 
	docker push apple/img_namev1.0


```
4.27
docker info：显示系统级别的信息，比如容器和镜像的数量等。

12.31 排查 docker cpu 过高
1、查看docker的cpu占用率：docker stats

2、进入cpu占用高的docker容器：docker exec -it 容器编号 /bin/bash

3、查看容器中具体进程cpu占用率，执行top，（如top命令无法使用，执行：export TERM=dumb ，然后在执行：top）

4、查看进程中线程cpu占用率：top -H -p 进程号

5、将异常线程号转化为16进制： printf "%x\n" 线程号

6、查看线程异常的日志信息：jstack 进程号|grep 16进制异常线程号 -A90

4.7号：
检查docker配置格式
docker-compose config


2月23号继续学习：

列出当前进行的容器
docker ps -l 

进行中的上一个容器id q: 只显示id
docker ps -lq 

用于shell中打印除指定容器id
docker ps -aq --filter name=$value

启动之前建立的容器
docker start  ‘id’

容器挂起
control +p +q 
从新在进入原来的容器
docker attach id
不进入原来的容器的，隔山打牛，直接返回容器输出内容
docker exec -it id  ls -l ~

正常关闭容器
docker stop id 
强制关闭
docker kill id
删除不用的容器
docker rm id

删除docker所有的容器
docker rm $(docker ps -aq)

删除2个月以前的镜像
docker images -q --filter "before=$(date -d "2 months ago" +"%Y-%m-%dT%H:%M:%S")" | xargs docker rmi

删除所有未在运行的容器
docker container prune

查看docker日志
docker logs -tf --tail 5 id

查看容器内部细节
docker inspect id

拷贝容器内容
docker cp id:/tmp...  ./

提交镜像：
docker commit -a='who' -m='what' id name:1.1




9.26
1 查看docker镜像（images）后可以导出导入镜像以供下次使用

docker save  contos：7 > /usr/local....
导出：
docker load < /usr/loacl....

2检查网络 
docker network inspect eosdev

查看自己eos钱包账户中的公私钥匙
keosd wallet private_keys -n my {钱包账户密码}

 
以当前的8080端口对应docker的80端口
docker run -d -p 8080:80 --name webserver nginx
如果参数是-P 大写 表示 本机随机分配端口到docker的80端口


docker run -d -p 80:80 --name webserver nginx
$ docker stop webserver



docker image ls

查看当前机器已安装的镜像：
docker image


java环境运行 
1首先检查 mvn -v是否有
2. 检查java-jdk 安装稳定版本
3. 使用jar运行  后面按照手册进行即可

4.使用war运行 ：先下载tomcat，然后cd bin shutdown.sh /startup.sh

可以把bin目录放到PATH中，方便以后操作
在运行之前，在webapps目录中放入 在项目中mvn package 打包好的war包，放入当前web目录，
然后就可以start运行了。


sudo npm install

npm要从官网下载安装！！！
brew install yarn

npx install-peerdeps --dev eslint-config-airbnb-base


npm install -g eslint-plugin-react


部署第一个fabric-Samples网络 

先拉取代码后 git clone https://github.com/hyperledger/fabric-samples.git
将下载的bootsrat。sh 拷贝过来，然后安装 sh bootstrap.sh  （测出需要等待很久）

创建网络

启动脚本 
第一步，生成必要文件，执行命令：

luoxiaohui:fabric-samples luoxiaohui$ cd first-network/
luoxiaohui:first-network luoxiaohui$ ./byfn.sh -m generate

第二步，启动网络，执行命令：
luoxiaohui:first-network luoxiaohui$ ./byfn.sh -m up


10.13
铸币之后发到一个地址，通过调智能合约后，分达到几个账户中，

1. Neptune(web client): admin project，应该是管理员后台界面
2. Interface(web server): 后台接口，Bet, Ram, Token, User, Applicant, etc
3. Saturn-IOS(wallet client): wallet app
4. Saturn-Android(wallet client): wallet app
5. Jupite(fabric config): 区块链网络，网络配置相关
6. SampleDapp: sample dapp
7. FutureBureau(chain code): 未来局chaincode
8. Earth(chain code): chaincode for blockchain token and user management.
9. Venus: no idea
10. DappJupiter: 与Jupiter区别？
11. Uranus: 区块链浏览器
12. GZH: empty 

1  智能合约 earth 基础上， 
2 dapp  ：api

一周任务：
chaincode 智能合约   earth

server interface  


//  stop停止所有容器
docker stop $(docker ps -a -q) 

// 删除所有镜像
docker rmi $(docker images -q)

// 删除指定名称镜像
docker images --format "{{.Repository}}:{{.ID}}" | grep key | awk -F ":" '{print $2}' | xargs docker rmi

// 删除指定名称的容器
docker ps -a --format "{{.ID}}\t{{.Image}}" |grep shanghai | awk '{print $1}' |xargs docker rm

```