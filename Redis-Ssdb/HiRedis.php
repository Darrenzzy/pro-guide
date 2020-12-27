<?php

class HiRedis
{
    private $_cache;
    private $_type; # ssdb, redis
    private $_namespace;

    static $_redis_map = array();

    public $end_point;

    private $_batch_mode = false;
    private $_batch_cmds = array();


    function isSsdb()
    {
        return $this->_type === 'ssdb';
    }

    static function getInstance($end_point)
    {
        if (isset(self::$_redis_map[$end_point])) {
            return self::$_redis_map[$end_point];
        }
        // debug($end_point);
        list($type, $host, $port) = explode(':', $end_point);
        $host = str_replace('//', '', $host);

        $x_redis = new HiRedis($host, $port, $type);
        self::$_redis_map[$end_point] = $x_redis;
        return $x_redis;
    }

    function __construct($host, $port, $type = 'redis', $namespace = null)
    {
        $type = strtolower($type);
        $this->_type = $type;
        $this->_namespace = $namespace;
        $this->_cache = null;
        $this->_host = $host;
        $this->_port = $port;

        $this->end_point = $type . '://' . $host . ':' . $port;
        if ($namespace) {
            $this->end_point .= '/' . $namespace;
        }

    }

    public function init()
    {
        if (!$this->_cache) {
            if (!$this->isSsdb()) {
                $this->_cache = phpiredis_pconnect($this->_host, $this->_port);

            } elseif ($this->isSsdb()) {
                $this->_cache = new SSDB($this->_host, $this->_port);
                //$this->_cache->connect($this->_host, $this->_port);
                //$this->_cache->pconnect($this->_host, $this->_port);
                if ($this->_namespace) {
                    $this->_cache->option(SSDB::OPT_PREFIX, $this->_namespace); //设置key前缀
                }
            }
        }
    }

    # 以下key默认调用__call
    static $KEYS = array('set', 'get', 'setnx', 'ttl', 'expire', 'del', 'incr', 'getset',
        'exists', 'setbit', 'getbit', 'strlen', 'setex', 'mget', 'mset', 'keys',
        'incrby', 'decr', 'decrby', 'bitcount', 'multi', 'batch',
        'hset', 'hget', 'hdel', 'hexists', 'hlen', 'hgetall', 'hmget', 'hmset', 'hvals',
        'zadd', 'zscore', 'zrem', 'zcard', 'zrange', 'zrevrange', 'zincrby', 'zcount',
        'zremrangebyrank', 'zremrangebyscore', 'zrank', 'zrangebyscore', 'zrevrangebyscore',
        'lpush', 'rpush', 'lpop', 'rpop', 'llen', 'lrange', 'lindex', 'ltrim', 'lset', 'lrem', 'sadd',
        'hclear', 'zclear', 'qclear', 'zlist', 'hlist', 'qlist', 'multi_zget'
    );
    # multi_zget 别名zmscore

    # key不同, 参数相同的命令
    static $KEYS_DIFF_PARAMS_SAME = array('mset' => 'multi_set', 'incrby' => 'incr', 'hmset' => 'multi_hset',
        'hlen' => 'hsize', 'hget' => 'hget', 'zscore' => 'zget', 'zrem' => 'zdel', 'zcard' => 'zsize',
        'lpush' => 'qpush_front', 'rpush' => 'qpush_back', 'lpop' => 'qpop_front', 'rpop' => 'qpop_back',
        'llen' => 'qsize', 'lrange' => 'qslice', 'lset' => 'qset');

    #hvals<->hscan, ssdb不支持获取全部, redis/ssdb调用hvals时, 参数不同
    #zrange/zrevrange  ssdb不支持-1获取全部,
    #bitcount : 当value占有不超过8位,即1字节,  ssdb计算不了value中占有1的个数
    #getbit  redis/ssdb有所不同

    public function __call($cmd, $params)
    {
        $resp = null;
        $default = true;
        $cmd = trim($cmd);
        $cmd = strtolower($cmd);
        if (!in_array($cmd, self::$KEYS)) {
            echo "\n(error) " . $cmd . ' params ' . json_encode($params, JSON_UNESCAPED_UNICODE) . " command is not exists!";
            die;
        }

        try {
            $this->init();

            if ($this->_batch_mode) {
                $this->_batch_cmds[] = array($cmd, $params);
                return true;
            }

            if (!$this->isSsdb() && strpos($cmd, 'clear')) {
                $cmd = 'del';
            }
            # key不同, 参数相同, 替换cmd
            if ($this->isSsdb() && array_key_exists($cmd, self::$KEYS_DIFF_PARAMS_SAME)) {
                $cmd = self::$KEYS_DIFF_PARAMS_SAME[$cmd];
            }

            $cmd = trim($cmd);

            switch ($cmd) {
                case 'setex': #setx(key, ttl, value)
                    if ($this->isSsdb()) {
                        $cmd = 'setx';
                        $tmp = $params[2];
                        $params[2] = $params[1];
                        $params[1] = $tmp;
                    }
                    break;
                case 'mget':

                    if ($this->isSsdb()) {
                        $default = false;
                        $resp = array();
                        $values = $this->_cache->multi_get($params[0]);
                        foreach ($params[0] as $key) {
                            if (isset($values[$key])) {
                                $resp[] = $values[$key];
                            } else {
                                $resp[] = null;
                            }
                        }
                        //debug('command','multi_get',$params);
                        //debug($resp);
                    }
                    break;
                case 'decr':
                    if ($this->isSsdb()) {
                        $cmd = 'incr';
                        if (1 == count($params)) {
                            $params[1] = -1;
                        } else {
                            $params[1] = -$params[1];
                        }
                    }
                    break;
                case 'decrby':
                    if ($this->isSsdb()) {
                        $cmd = 'incr';
                        $params[1] = -$params[1];
                    }
                    break;
                case 'bitcount': // ssdb 占用不超过8位, 计算不出来1的个数
                    if ($this->isSsdb()) {
                        $cmd = 'countbit';
                        if (count($params) == 1) {
                            $params[1] = 0;
                            $params[2] = -1;
                        }
                    }
                    break;
                case 'hmget':

                    if ($this->isSsdb()) {
                        $default = false;
                        $key_score = $this->_cache->multi_hget($params[0], $params[1]);
                        foreach ($params[1] as $key) {
                            if (isset($key_score[$key])) {
                                $resp[$key] = $key_score[$key];
                            } else {
                                $resp[$key] = null;
                            }
                        }
                        //debug("command",'multi_hget',$params);
                        //debug($resp);
                    }
                    break;
                case 'hvals':
                    if ($this->isSsdb()) {
                        $cmd = 'hscan';
                        if (1 == count($params)) {
                            $params[1] = '';
                            $params[2] = '';
                            $params[3] = $this->_cache->hsize($params[0]);
                        }
                    }
                    break;
                case 'hset':
                    if ($this->isSsdb()) {
                        if (!is_string($params[2])) {
                            $params[2] = (string)$params[2];
                        }
                    }
                    break;
                case 'zadd':
                    if ($this->isSsdb()) {
                        $cmd = 'zset';
                        $tmp = $params[2];
                        $params[2] = $params[1];
                        $params[1] = $tmp;
                    }
                    break;
                case 'zrange': // zrange(key, 0, limit)不支持-1

                    if ($this->isSsdb()) {
                        $default = false;
                        if (-1 == $params[2]) {
                            $params[2] = $this->_cache->zsize($params[0]);
                        } else {
                            $params[2] = $params[2] - $params[1] + 1;
                        }
                        $resp = $this->_cache->zrange($params[0], $params[1], $params[2]);
                        if (count($params) == 3 && is_array($resp)) {
                            $resp = array_keys($resp);
                        }

                        // withscores
                        if (!$resp) {
                            $resp = array();
                        }
                        //debug('command','zrange',$params);
                        //debug($resp);

                    }
                    break;
                case 'zrevrange':

                    if ($this->isSsdb()) {
                        $default = false;
                        if (-1 == $params[2]) {
                            $params[2] = $this->_cache->zsize($params[0]);
                        } else {
                            $params[2] = $params[2] - $params[1] + 1;
                        }

                        $resp = $this->_cache->zrrange($params[0], $params[1], $params[2]);
                        if (count($params) == 3 && is_array($resp)) {
                            $resp = array_keys($resp);
                        }

                        // withscores
                        if (!$resp) {
                            $resp = array();
                        }
                        //debug('command','zrrange',$params);
                        //debug($resp);
                    }
                    break;
                case 'zincrby':

                    if ($this->isSsdb()) {
                        $cmd = 'zincr';
                        $tmp = $params[2];
                        $params[2] = $params[1];
                        $params[1] = $tmp;
                    }
                    break;
                case 'zrangebyscore':
                    if ($this->isSsdb()) {
                        $default = false;

                        echo "zrangebyscore is not exists";
                        return null;
                    }
                    break;
                case 'zrevrangebyscore':
                    if ($this->isSsdb()) {
                        $default = false;

                        echo "zrangebyscore is not exists";
                        return null;
                    }
                    break;
                case 'multi_zget':

                    if ($this->isSsdb()) {
                        $default = false;
                        $resp = array();
                        $values = $this->_cache->multi_zget($params[0], $params[1]);
                        foreach ($params[1] as $key) {
                            if (isset($values[$key])) {
                                $resp[$key] = $values[$key];
                            } else {
                                $resp[$key] = null;
                            }
                        }
                    }
                    break;
                case 'ltrim':

                    if ($this->isSsdb()) {
                        $default = false;
                        $list = $this->_cache->qslice($params[0], $params[1], $params[2]);
                        if (empty($list)) {
                            return null;
                        }
                        if (count($list) > 0) {
                            $resp = 1;
                            $this->_cache->qclear($params[0]);
                            foreach ($list as $value) {
                                $this->_cache->qpush_back($params[0], $value);
                            }
                        }
                        //debug('command','ltrim',$params);
                        //debug($resp);
                    }
                    break;
                case 'lrem':
                    if ($this->isSsdb()) {
                        $default = false;

                        warn("ssdb lrem is not exists");
                        return null;
                    }
                    break;
                case 'multi':
                    $default = false;
                    return $this->pipeline();
                    break;
                case 'batch':
                    $default = false;
                    return $this->pipeline();
                    break;
                default:
                    $default = true;
            }

            # 默认命令,
            if ($default) {
                if ($this->isSsdb()) {
                    $reflection_method = new ReflectionMethod($this->_cache, $cmd);
                    $resp = $reflection_method->invokeArgs($this->_cache, $params);
                    //debug("command", $cmd, $params);
                    //debug($resp);

                } else {

                    $command = $this->flatParamters($cmd, $params);
                    array_unshift($command, $cmd);

                    //$command = array("hset","axy12345test_hset13","k_6", '6');
                    //$command = array('mset', 'key1', '1', 'key2', '2', 'key3', '3', 'key4', '4', 'key5', '5');
                    // debug("command", $command, $params);
                    //debug("command", $command);

                    //$ttt = implode(' ', $command);
                    //$resp = phpiredis_command($this->_cache, $ttt);

                    $resp = @phpiredis_command_bs($this->_cache, $command);

                    if ('hgetall' == $cmd) { //["hf11","200","hf112","2000"] =>{"hf11":"200","hf112":"2000"}
                        $tmp_resp_array = array();
                        for ($i = 0; $i < count($resp); $i++) {
                            $tmp_resp_array[$resp[$i]] = $resp[$i + 1];
                            $i += 1;
                        }
                        $resp = $tmp_resp_array;

                    } else if ('hmget' == $cmd) {//值数组 => 键值对数组
                        $tmp_resp_array = array();
                        $field_array = $params[1];
                        if (is_array($resp) && is_array($field_array)) {
                            for ($i = 0; $i < count($resp); $i++) {
                                $tmp_resp_array[$field_array[$i]] = $resp[$i];
                            }
                        } else if (is_array($resp) && is_string($field_array)) {
                            $tmp_resp_array[$field_array] = $resp[0];
                        }
                        $resp = $tmp_resp_array;
                    }
                    //set mset hmset等  设置成功返回 OK => 1
                    if (is_string($resp) && 'OK' == $resp) {
                        $resp = 1;
                    }
                    //debug($resp);

                }

            }

        } catch (Exception $e) {

            info("[Exception] SSDB XRedis Exception command: {$cmd}, " . $e->getMessage());
            $this->_cache = null;
        }

        if ($resp === 'null' || $resp === 'NULL' || $resp === '' || $resp === 'false') {
            debug("XRedis cmd:" . $cmd . "===============resp:" . $resp, __FILE__, __LINE__);
            $resp = null;
        }

        return $resp;
    }


    // 参数是array(key=>val)的要识别哪些参数的key是有效的
    function flatParamters($cmd, $params)
    {
        $command = array();
        foreach ($params as $key => $val) {
            //debug($key, ":", $val);

            if (is_array($val)) {
                // mset, mget, hmset, hmget
                $this->flatMultiParams($cmd, $val, $command);
            } else {

                if (0 == $key) {
                    if ($this->_namespace) {
                        $val = $this->_namespace . ":" . $val;
                    }
                }

                $command[] = strval($val);
            }
        }

        return $command;
    }

    protected function flatMultiParams($cmd, $params, &$command)
    {
        foreach ($params as $k => $v) {

            if (in_array(strtolower($cmd), array('mset', 'hmset', 'zadd'))) {

                // 是否需要namespace
                if ($this->_namespace && in_array(strtolower($cmd), array('mset'))) {
                    $command[] = $this->_namespace . ":" . $k;
                } else {
                    $command[] = strval($k);
                }
            }

            // mget
            //if (in_array(strtolower($cmd), array('mget', 'hmget'))) {
            if ($this->_namespace && in_array(strtolower($cmd), array('mget', 'exists'))) {
                $v = $this->_namespace . ":" . $v;
            }
            // }

            $command[] = strval($v);
        }

    }

    public function pipeline()
    {
        $this->init();
        $this->_batch_mode = true;
        return $this;
    }

    public function exec()
    {
        $this->init();

        $resp = array();
        if ($this->_batch_mode) {

            // 必须先设置为否，不然死循环
            $this->_batch_mode = false;

            if ($this->isSsdb()) {
                foreach ($this->_batch_cmds as $argv) {
                    list($cmd, $params) = $argv;
                    $resp[] = $this->__call($cmd, $params);
                }
            } else {
                $commands = array();
                foreach ($this->_batch_cmds as $argv) {
                    list($cmd, $params) = $argv;

                    $command = $this->flatParamters($cmd, $params);
                    array_unshift($command, $cmd);

                    //debug($command);

                    $commands[] = $command;
                }

                //debug($commands);
                $resp = @phpiredis_multi_command_bs($this->_cache, $commands);


                if ($this->_batch_cmds) {
                    foreach ($this->_batch_cmds as $k => $argv) {
                        list($cmd, $params) = $argv;

                        if ('hgetall' === $cmd) {//["hf11","200","hf112","2000"] =>{"hf11":"200","hf112":"2000"}
                            $temp = $resp[$k];
                            $tmp_resp_array = array();
                            for ($i = 0; $i < count($temp); $i++) {
                                $tmp_resp_array[$temp[$i]] = $temp[$i + 1];
                                $i += 1;
                            }
                            $resp[$k] = $tmp_resp_array;
                        } else if ('hmget' == $cmd) {//值数组 => 键值对数组
                            $temp = $resp[$k];
                            $tmp_resp_array = array();
                            $field_array = $params[1];
                            if (is_array($temp) && is_array($field_array)) {
                                for ($i = 0; $i < count($temp); $i++) {
                                    $tmp_resp_array[$field_array[$i]] = $temp[$i];
                                }
                            } else if (is_array($temp) && is_string($field_array)) {
                                $tmp_resp_array[$field_array] = $temp[0];
                            }
                            $resp[$k] = $tmp_resp_array;
                        }
                    }
                }

                foreach ($resp as $resp_key => $resp_value) {//OK=>true
                    if ('OK' === $resp_value) {
                        $resp[$resp_key] = true;
                    } else if ('ERR no such key' === $resp_value || 'ERR index out of range' === $resp_value) {
                        $resp[$resp_key] = null;
                    }
                }

            }

            $this->_batch_cmds = array();
            return $resp;
        }

        if ($this->_batch_mode) {
            $this->_batch_mode = false;
        }

        return $resp;
    }

}
