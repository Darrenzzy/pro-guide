##### 有时候需要在服务器上写个脚本爬取信息，针对网站防爬虫对IP有要求的可以使用代理或者VPN， 这里介绍linux上使用pptp方法

* 安装:
`sudo yum install pptp pptp-setup`

* 设置服务器信息, 用户名, 密码:
`pptpsetup --create vpn_simple --server x.x.x.x --username user01 --password pwd01`

* 启用
`pppd call vpn_simple`

* 设置vpn为默认路由
ip route replace default dev ppp0

* 至此VPN就应该连上了， 查询当前IP
`curl http://icanhazip.com`

* 关闭
`killall pppd`

* 重启网络
`/etc/init.d/network restart`

