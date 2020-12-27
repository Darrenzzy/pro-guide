DROP TABLE IF EXISTS `feeds`;
CREATE TABLE `feeds` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed唯一ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '作者ID',
  `content` blob  NOT NULL COMMENT 'Feed内容',
  `content_type` tinyint(4) UNSIGNED NOT NULL COMMENT 'Feed内容类型',
  `comment_switch` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否可以评论，1:可以 2:不可以',
  `tags` mediumblob COMMENT '所属标签',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `approvedtime` datetime(3) NULL COMMENT '通过时间',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否可用，1：可用 2：审核中 3：用户自己删除 4：系统和谐',
  `feed_type` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Feed类型，1：动态 2：帖子 3：资讯',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_uuid` (`uuid`),
  KEY `idx_userid` (`user_id`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '动态';

DROP TABLE IF EXISTS `up_feeds`;
CREATE TABLE `up_feeds` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed唯一ID',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '置顶时间',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_uuid` (`uuid`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '置顶动态';

DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` bigint(20) UNSIGNED NOT NULL COMMENT '评论唯一ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '作者ID',
  `feed_uuid` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed唯一ID',
  `root_comment_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '根评论唯一ID',
  `reply_comment_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '被回复的评论唯一ID',
  `content` varchar(200)  NOT NULL COMMENT '评论内容',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  `status` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否可用，1：可用 2：审核中 3：用户自己删除 4：系统和谐',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_uuid` (`uuid`),
  KEY `idx_feed` (`feed_uuid`),
  KEY `idx_user` (`user_id`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '评论';

DROP TABLE IF EXISTS `favorites_feed`;
CREATE TABLE `favorites_feed` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` bigint(20) UNSIGNED NOT NULL COMMENT '赞唯一ID',
  `feed_uuid` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed唯一ID',
  `feed_user_id` bigint(20) UNSIGNED NOT NULL COMMENT '被点赞者ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '点赞者ID',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:喜欢 2:撤销喜欢',
  `updatedtime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_uuid` (`uuid`),
  UNIQUE KEY `uni_feed_user` (`feed_uuid`, `user_id`),
  KEY `idx_feed_user` (`feed_user_id`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '赞动态';

DROP TABLE IF EXISTS `favorites_comment`;
CREATE TABLE `favorites_comment` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `uuid` bigint(20) UNSIGNED NOT NULL COMMENT '赞唯一ID',
  `comment_uuid` bigint(20) UNSIGNED NOT NULL COMMENT '评论唯一ID',
  `comment_user_id` bigint(20) UNSIGNED NOT NULL COMMENT '被点赞者ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '点赞者ID',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1:喜欢 2:撤销喜欢',
  `updatedtime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_uuid` (`uuid`),
  UNIQUE KEY `uni_comment_user` (`comment_uuid`, `user_id`),
  KEY `idx_comment_user` (`comment_user_id`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '赞评论';

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `feed_user_id` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed作者ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '点赞/评论者ID',
  `feed_uuid` bigint(20) UNSIGNED NOT NULL COMMENT 'Feed唯一ID',
  `favorites_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '赞唯一ID，取消赞删除记录',
  `comment_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '评论唯一ID',
  `createdtime` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
  PRIMARY KEY(`id`),
  KEY `idx_feed_user` (`feed_user_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '动态相关通知消息';

DROP TABLE IF EXISTS `reports`;
CREATE TABLE `reports` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '举报者ID',
  `bad_user` bigint(20) UNSIGNED NOT NULL COMMENT '被举报者ID',
  `feed_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '被举报的Feed唯一ID',
  `comment_uuid` bigint(20) UNSIGNED DEFAULT 0 COMMENT '被举报的评论唯一ID',
  `desc` varchar(200) DEFAULT '' COMMENT '举报原因描述',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1:待处理 2:已处理 3:忽略',
  `createdtime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedtime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY(`id`),
  UNIQUE KEY `uni_feed_user` (`user_id`, `feed_uuid`, `comment_uuid`),
  KEY `idx_baduser` (`bad_user`),
  KEY `idx_createdtime` (`createdtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '举报';

DROP TABLE IF EXISTS `switch_cfg`;
CREATE TABLE `switch_cfg` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `feed` tinyint(1) NOT NULL DEFAULT '1' COMMENT '发动态开关，1:先发后审 2:先审后发 3:禁止发动态',
  `comment` tinyint(1) NOT NULL DEFAULT '1' COMMENT '发评论开关，1:先发后审 2:先审后发 3:禁止发评论',
  `display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '动态/评论显示开关，1:所有内容正常显示 2:所有内容都不显示',
  `audit` tinyint(1) NOT NULL DEFAULT '2' COMMENT 'iOS审核开关，1:打开 2:关闭',
  `post` tinyint(1) NOT NULL DEFAULT '2' COMMENT '帖子开关，1:先发后审 2:先审后发',
  `updatedtime` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT '开关配置';

INSERT INTO `switch_cfg` (`id`, `feed`, `comment`, `display`, `audit`, `post`, `updatedtime`)
VALUES
  (DEFAULT, 1, 1, 1, 2, 2, DEFAULT);
