7.31
查询手册： 


删除索引
Delete /god_game_qa

查询一个、多个或者 _all 索引库（indices）和一个、多个或者所有types中查询
GET /index_2014*/type1,type2/_search
{
    "query": { }
}

分页 查询
POST god_game_qa/_search{
  "query" : {
    "bool" : {
    ....
    }
  },
  "from": 30,
  "size": 10
}

条件查询
{
    "bool": {
        "must":     { "match": { "tweet": "elasticsearch" }},
        "must_not": { "match": { "name":  "mary" }},
        "should":   [
				      { "term": { "title": "brown" }},
				      { "term": { "title": "fox"   }}
				    ],
        "filter":   { "range": { "age" : { "gt" : 30 }} }
    }
}

更新字段
POST /website/blog/1/_update
{
   "doc" : {
      "tags" : [ "testing" ],
      "views": 0
   }
}

打印查询语句
        if bs, err := item.Source.MarshalJSON(); err == nil {
          icelog.Infof("%s", string(bs))

          // json.Unmarshal(bs)

        }

添加字段：
PUT god_game_qa/_mapping/peiwan_stats
{
  "properties": {
    "location2": {
      "type": "geo_point"
    }
  }
}

PUT god_game_prod/_mapping/peiwan_stats
{
  "properties": {
    "highest_level_id_score": {
      "type": "integer"
    }
  }
}

<!-- 修改字段 -->
POST god_game_qa/peiwan_stats/_update_by_query
{
  "script": {
    "inline": "ctx._source.emails=null;ctx._source.emails=2222"
  },
  "query": {
    "term": {
      "god_id": "254"
    }
  }
}

解析 elastic 转成字符串 用于放到工具里看问题
src, _ := query.Source()
        if bs, err := json.Marshal(src); err == nil {
            icelog.Infof("### query:%s", string(bs))
        }

        GET /god_game_qa/peiwan_stats/_search
{"query": {"bool":{"filter":{"geo_distance":{"distance":"200km","location2":{"lat":31,"lon":121}}},"must":{"range":{"lts":{"from":"2018-11-28T14:07:49.19223357+08:00","include_lower":true,"include_upper":true,"to":"2019-11-28T14:07:49.191619954+08:00"}}}}}}




