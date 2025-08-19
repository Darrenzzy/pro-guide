# etcd

### 常用命令

```sh

# 查看当前节点列表
etcdctl member list --write-out="table"

# 指定节点存入 kv
etcdctl --endpoints=127.0.0.1:2379 put key 'value'

# 查看节点存入 kv
etcdctl --endpoints=127.0.0.1:2379 get key

# 获取节点 key 左前缀
etcdctl get --prefix k



```
