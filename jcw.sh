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
docker_hub_memcached_image="memcached"               # memcache

# mac local ip for docker
local_ip="docker.for.mac.localhost"

# local dns
add_host=(
"host.test:$local_ip"
)

function check_and_stop_service() {
    service=$1
    
    if [ -n "$(docker ps -a | grep $service)" ] 
    then
        docker rm -vf $service
    fi
}


function start_nginx() {
    docker_name="local_nginx"
    check_and_stop_service $docker_name

    nginx_exec="docker run --name $docker_name -d -p 80:80 "

#    if [ -n "$dns" ]
#    then
#        nginx_exec="$nginx_exec --dns=$dns "
#    fi

    nginx_exec="$nginx_exec -v $nginx_conf:/etc/nginx/nginx.conf "

    if [ -n "$nginx_confd_dir" ]
    then
        nginx_exec="$nginx_exec -v $nginx_confd_dir:/etc/nginx/conf.d "
    fi
    
    nginx_exec="$nginx_exec $docker_hub_nginx_image"

    $nginx_exec
}

function start_redis() {
    docker_name="local_redis"
    check_and_stop_service $docker_name
    docker run --name $docker_name -d -p 6379:6379 $docker_hub_redis_image
}

function start_memcache() {
    docker_name="local_memcached"
    check_and_stop_service $docker_name
    docker run --name $docker_name -d -p 11211:11211 $docker_hub_memcached_image
}


function main() {
    start_nginx
    start_redis
    start_memcache
}

main
