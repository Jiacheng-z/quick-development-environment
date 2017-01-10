# PHP的个人开发环境Dockerfile

提供两个版本`php5.6`和`php7.1`

两个环境的扩展相同，包含下列扩展：

- iconv
- mcrypt
- gd
- opcache
- xml 
- pdo 
- pdo_mysql
- sockets
- memcache
- memcached 
- redis 
- solr
- yaf
- yar
- yac
- xhprof
- xdebug

做好的镜像在[docker hub](https://hub.docker.com/r/jiachengajtlkd/php/tags/)提供下载

## 使用样例

**1) 包含redis和memcache的样例**

```
docker run --name b-redis -d redis:3.0 \
&& docker run --name b-memcache  -d memcached:1.4 \
&& docker run --name phpfpm -d \
-v /Users/zhangjiacheng/WorkDir/Webserver/Project:/app \
-v /file_path/php.ini:/usr/local/etc/php/php.ini \
--link b-redis:redis \
--link b-memcache:memcache \
[docker image]
```

**2) 单独启动**

```
docker run --name phpfpm -d \
-v /Users/zhangjiacheng/WorkDir/Webserver/Project:/app \
-v /file_path/php.ini:/usr/local/etc/php/php.ini \
[docker image]
```

**3) 配合nginx提供服务**

```
docker run --name nginx_server -d -p 80:80 \
-v /file_path/nginx.conf:/etc/nginx/nginx.conf \
[-v /file_path/conf.d:/etc/nginx/conf.d \]
--link phpfpm:php \
--volumes-from phpfpm \
nginx
```


