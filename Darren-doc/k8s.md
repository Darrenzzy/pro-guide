# k8s 问题及解决方案
### Kubernetes 资源定义   
apiVersion: monitoring.coreos.com/v1

- k8s 的类型有 
        Deployment 用于声明式管理 Pod 部署，提供滚动升级和回滚等功能。
        ConfigMap 用于存储非机密性的配置数据。   kind: Secret敏感数据
        Service  定义一组 Pod，它们共享相同的网络标识和策略
        Namespace 用于将集群划分为多个虚拟集群，
        ServiceAccount（ServiceAccount）：为 Pod 中的进程定义身份。
        PersistentVolume（PersistentVolume）：集群中的永久存储。
        Pod（Pod）：最小的可部署单元，用于承载容器
        PrometheusRule =》监控相关


        通过label 定义我们可以将上面的各种kind串联起来。
        metadata:
          labels:
            app: kube-prometheus-stack

        是一种用于 Kubernetes 环境中监控和获取数据的工具集。

        spec:
          groups:
          - name: pixiu-adx
          表示后面通过这个name搜索 我们设置的监控规则

### 重启服务 
        kubectl --kubeconfig ~/.kube/config rollout restart deployment consumer-pixiu-notice  -n test-1

### 创建configmap文件
        kubectl --kubeconfig ~/.kube/config -n dev-2 create configmap pixiu-ad-backend --dry-run=client -oyaml  --from-file ./configs/dev/config.yaml > ./deploy/test/base/dev/configmap.yaml

        
### 重新应用配置文件
        kubectl --kubeconfig ~/.kube/config apply -f ./deploy/test/base/dev/configmap.yaml

### 
        kubectl --kubeconfig ~/.kube/config.hw.test delete pod cronjob-monitor-28346860-7rs88 -n test-1
### 查看指定集群 的普罗监控信息
kubectl --kubeconfig ~/.kube/config -n monitor get prometheusrule -o yaml metadata_name


### pod 重新部署失败后，需要调研什么原因导致失败，看pod状态是 ErrImagePull
        kubectl --kubeconfig ~/.kube/xxx describe pods podname -n namespace
        拉到最后描述显示 kubelet Failed to pull image "repoxxx:names": rpc error: code = Unknown desc = failed to resolve reference "xxxx": failed to authorize: failed to fetch oauth token: unexpected status: 401 Unauthorized

        得知是yaml中imagePullSecrets配置对应的秘钥错误导致的。因为在新的命名空间搞，所以不太清楚配置。

### 代理集群节点到本地端口
* kubectl  --kubeconfig  ~/.kube/xxxx  port-forward -n prod podname  8080:8080


### 重启服务时pod断开流程：
优雅方式：收到SIGTERM信号后，对外提供服务的pod，要先断开端口监听，在依次向中心注销服务，退出进程

### 常用本地脚本
```bash

# 修改configmap后，集群应用执行
function kapply(){
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG  apply -f $1
}
# 查看当前集群所有pod列表
function ka(){
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV get po
}
# 查看指定pod的全部日志
function kr(){
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV logs -f $1  "
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV logs -f $1
}

# 
function krollout(){
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG  rollout restart Deployment $1 -n $ALI_ENV"
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG  rollout restart Deployment $1 -n $ALI_ENV
}

# 查看集群指定pod环境变量
function kenv(){
        podname=`kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV get po |grep XXXX |awk '{print $1}' |head -n 1`
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV  exec $podname  -- printenv"
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV  exec $podname  -- printenv
}

# 进入指定pod 容器内操作
function kexec(){
        podname=`kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV get po |grep XXXX |awk '{print $1}' |head -n 1`
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV  exec -it $podname  -- /bin/sh"
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV exec -it $podname  -- /bin/sh
}

# 快速查看模糊匹配的pod日志
function kf(){
        podname=`kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV get po |grep $1 |awk '{print $1}' |head -n 1`
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV logs -f $podname"
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG -n $ALI_ENV logs -f $podname
}

function kdescribe(){
        echo "kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG describe pods  -n $ALI_ENV $1"
        kubectl --kubeconfig ~/.kube/$ALI_KB_CONFIG describe pods  -n $ALI_ENV $1
}

```

### 常用排查命令


本地启动监听pod端口
 kubectl  --kubeconfig  ~/.kube/config  port-forward -n test podname 9090:9090


