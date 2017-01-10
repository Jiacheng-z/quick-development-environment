#!/bin/bash

choise=$1

choise_image="" #用户选择的镜像
docker_hub_php56_image="jiachengajtlkd/php:5.6-fpm"
docker_hub_php71_image="jiachengajtlkd/php:7.1-fpm"
docker_hub_redis_image="redis:3.0"
docker_hub_memcache_image="memcached:1.4"

php_app="/Users/zhangjiacheng/WorkDir/Webserver/Project" #app文件路径
php_ini="/Users/zhangjiacheng/WorkDir/Docker/Config/php/php.ini" #php.ini路径

nginx_conf="/Users/zhangjiacheng/WorkDir/Docker/Config/nginx/nginx.conf" #nginx.conf路径
nginx_confd="/Users/zhangjiacheng/WorkDir/Docker/Config/nginx/conf.d" #nginx server 配置路径 可以为空

own_ip="172.17.0.1"
dns="114.114.114.144"

#向docker启动时添加的host
add_host=(
"admin.testmiaoche.com:$own_ip"
"api.testmiaoche.com:$own_ip"
)

function get_image() {
    version=$1
    if [ $version == "php5" ] 
    then
        choise_image=$docker_hub_php56_image
    else
        choise_image=$docker_hub_php71_image
    fi
}

function service_start_fpm () {
    get_image $1

    docker run --name b-redis -d $docker_hub_redis_image
    docker run --name b-memcache  -d $docker_hub_memcache_image
    
    docker_exec="docker run --name phpfpm -d "
   
    if [ $dns != "" ]
    then
        docker_exec="$docker_exec --dns=$dns "
    fi

    for i in ${add_host[*]}
    do
        docker_exec="$docker_exec --add-host $i "
    done
    
    docker_exec="$docker_exec -v $php_app:/app -v $php_ini:/usr/local/etc/php/php.ini "
    docker_exec="$docker_exec --link b-redis:redis --link b-memcache:memcache "
    docker_exec="$docker_exec $choise_image"
    
    $docker_exec

    #start nginx
    nginx_exec="docker run --name nginx_server -d -p 80:80 "
    
    if [ $dns != "" ]
    then
        nginx_exec="$nginx_exec --dns=$dns "
    fi
    
    nginx_exec="$nginx_exec -v $nginx_conf:/etc/nginx/nginx.conf "

    if [ $nginx_confd != "" ]
    then
        nginx_exec="$nginx_exec -v $nginx_confd:/etc/nginx/conf.d "
    fi 

    nginx_exec="$nginx_exec --link phpfpm:php --volumes-from phpfpm nginx"

    $nginx_exec
}

function service_stop () {
    docker rm -v -f nginx_server phpfpm b-redis b-memcache
}

case $choise in 
start )
    php_version=$2
    case $php_version in 
        php5)
            service_start_fpm php5 
            ;;
        php7)
            service_start_fpm php7
            ;;
        *)
            echo "select in [php5]/[php7]"
            ;;
    esac
    ;;

stop )
    service_stop
    ;;
restart )
    service_stop 
    php_version=$2
    case $php_version in 
        php5)
            service_start_fpm php5 
            ;;
        php7)
            service_start_fpm php7
            ;;
        *)
            echo "select in [php5]/[php7]"
            ;;
    esac
    ;;

php5)
    get_image php5
    case $2 in 
        app)
            shift
            shift
            docker run -it --rm -v $php_app:/app -w /app $choise_image $*
            ;;
        *)
            shift 
            docker run -it --rm -v $PWD:/app -w /app $choise_image $*
            ;;
    esac
    ;;
php7)
    get_image php7
    case $2 in 
        app)
            shift
            shift
            docker run -it --rm -v $php_app:/app -w /app $choise_image $*
            ;;
        *)
            shift 
            docker run -it --rm -v $PWD:/app -w /app $choise_image $*
            ;;
    esac
    ;;

*)
    echo "./docker_run.sh [move] [version]"
    echo ""
    echo "  move: [start] [restart] [stop] [php5] [php7]"
    echo ""
    echo "  [start]: start a nginx,php,redis,memcache service"
    echo "      [version]: php5 or php7"
    echo "  [restart]: restart service"
    echo "      [version]: php5 or php7"
    echo "  [stop]: stop service"
    echo "  [php5]: use php-5.6 to run script"
    echo "  [php7]: use php-7.1 to run script"
    ;;
esac




