# 个人开发环境搭建

## 功能
1. 使用docker的: Nginx, Redis, Memcache.
2. 支持Docker compose.
3. 支持Alfred workflow.

## 使用
**注意: 记得修改config_example文件夹中的配置文件, 或docker-compose.yml中配置路径**

1. 使用原生的docker-compose命令.
2. 载入manager_base.alfredworkflow. 使用Aflred启动.
    修改workflow中以下两个节点的shell脚本中的文件路径.
    - Run Script node.
    - Terminal Command node.

###命令:
- `dc up -d`: 后台启动环境
- `dc up`: 打开命令行, 并启动环境或查看之前启动的环境的nginx, redis, memcache 回显日志.
- `dc down`: 停止环境.

## 依赖
- docker
- docker-compose (建议支持version 3, 因为version 1, 2 没试验过)
