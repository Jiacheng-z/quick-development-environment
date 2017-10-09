#!/bin/bash

# website path
website_path="/Users/zhangjiacheng/Code"

# nginx configures path
nginx_conf="/Users/zhangjiacheng/Code/nginx/nginx.conf"           # nginx.conf
nginx_confd_dir="/Users/zhangjiacheng/Code/nginx/conf.d"      # nginx conf.d dir

# php configures
php_ini=""              # php.ini

# docker images configures
docker_hub_php56_image="jiachengajtlkd/php:5.6-fpm" # php5.6 php-fpm
docker_hub_php71_image="jiachengajtlkd/php:7.1-fpm" # php7.1 php-fpm
docker_hub_nginx_image="nginx"                      # nginx
docker_hub_redis_image="redis"                      # redis
docker_hub_memcache_image="memcached"               # memcache

# mac local ip for docker
local_ip="docker.for.mac.localhost"

# local dns
add_host=(
"host.test:$local_ip"
)

function start_nginx_image() {
    image_name="local_nginx"

    if [ -n "$(docker ps -a | grep $image_name)" ] 
    then
        docker rm -vf $image_name
    fi

    nginx_exec="docker run --name $image_name -d -p 80:80 "

    if [ -n "$dns" ]
    then
        nginx_exec="$nginx_exec --dns=$dns "
    fi

    nginx_exec="$nginx_exec -v $nginx_conf:/etc/nginx/nginx.conf "

    if [ -n "$nginx_confd_dir" ]
    then
        nginx_exec="$nginx_exec -v $nginx_confd_dir:/etc/nginx/conf.d "
    fi
    
    nginx_exec="$nginx_exec $docker_hub_nginx_image"

    echo $nginx_exec

    $nginx_exec
}

start_nginx_image
