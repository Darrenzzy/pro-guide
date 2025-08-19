

11.2
### 常用promql：

- 5 分钟内的所有时间序列样本数据：
	```
		http_requests_total{job="apiserver", handler="/api/order"}[5m]
	
	```
- 所有任务名称以 server 结尾。
	```http_requests_total{job=~".*server"}```

- http 返回码不以 4 开头的所有时间序列数据：
	```
		http_requests_total{status!~"4.."}	
	```

- 过去 5 分钟内的 http 请求数的平均增长速率
```
rate(http_requests_total[5m])
	
```

- 过去 5 分钟内的 http 请求数的平均增长速率总和，维度是 job
```
sum(rate(http_requests_total[5m])) by (job)	
```

- 返回每一个实例的空闲内存，单位是 MiB。
```
(instance_memory_limit_bytes - instance_memory_usage_bytes) / 1024 / 1024	
```

- 每个应用的剩余内存
```
sum(
  instance_memory_limit_bytes - instance_memory_usage_bytes
) by (app, proc) / 1024 / 1024
	
```

- 相同的集群调度群显示如下的每个实例的 CPU 使用率
```
instance_cpu_time_ns{app="lion", proc="web", rev="34d0f99", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="elephant", proc="worker", rev="34d0f99", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="turtle", proc="api", rev="4d3a513", env="prod", job="cluster-manager"}
instance_cpu_time_ns{app="fox", proc="widget", rev="4d3a513", env="prod", job="cluster-manager"}
...
	
```

- 按照应用和进程类型来获取 CPU 利用率最高的 3 个样本数据
```
topk(3, sum(rate(instance_cpu_time_ns[5m])) by (app, proc))
	
```