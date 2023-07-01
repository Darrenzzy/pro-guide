# k8s 问题及解决方案

### pod 重新部署失败后，需要调研什么原因导致失败，看pod状态是 ErrImagePull
        kubectl --kubeconfig ~/.kube/xxx describe pods podname -n namespace
        拉到最后描述显示 kubelet Failed to pull image "repoxxx:names": rpc error: code = Unknown desc = failed to resolve reference "xxxx": failed to authorize: failed to fetch oauth token: unexpected status: 401 Unauthorized

        得知是yaml中imagePullSecrets配置对应的秘钥错误导致的。因为在新的命名空间搞，所以不太清楚配置。


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


```
