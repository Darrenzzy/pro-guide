
```
brew 安装后 启动nsq 和关闭
To have launchd start nsq now and restart at login:
  brew services start nsq
Or, if you don't want/need a background service you can just run:
  nsqd -data-path=/usr/local/var/nsq
```
```
  nsq
├── apps              # 所有组件的main入口目录
│   ├── nsq_pubsub
│   ├── nsq_stat
│   ├── nsq_tail
│   ├── nsq_to_file
│   ├── nsq_to_http
│   ├── nsq_to_nsq
│   ├── nsqadmin      # nsqadmin组件入口
│   ├── nsqd          # nsqd组件入口
│   ├── nsqlookupd    # nsqlookup组件入口
│   └── to_nsq
├── bench               # 批量测试工具
│   ├── bench.py
│   ├── bench_channels  # 
│   ├── bench_reader    # 消息的消费者
│   ├── bench_writer    # 消息的生产者
├── contrib
│   ├── nsq.spec               # 可根据该文件生成nsq的rpm包
│   ├── nsqadmin.cfg.example   # nsqadmin配置文件举例
│   ├── nsqd.cfg.example       # nsqd配置文件举例
│   └── nsqlookupd.cfg.example # nsqlookup配置文件举例
├── internal        # nsq的基础库
├── nsqadmin        # web组件
├── nsqd            # 消息处理组件
├── nsqlookupd      # 管理nsqd拓扑信息组件
```