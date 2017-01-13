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

myip="$(ifconfig | grep 'inet.*netmask.*broadcast')"
own_ip="$(echo $myip | awk '{print $2}')"
dns="114.114.114.144"

docker_machine_name="phpbox"

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

#检查某个容器是否存在，如果存在就删除
function check_and_stop_service() {
    service=$1
    
    if [ -n "$(docker ps -a | grep $service)" ] 
    then
        docker rm -vf $service
    fi
}

function service_start_redis_in_box() {
    container_name="b-redis"
    check_and_stop_service $container_name
    docker run --net=host --name $container_name -d $docker_hub_redis_image
}

function service_start_memcache_in_box() {
    container_name="b-memcache"
    check_and_stop_service $container_name
    docker run --net=host --name $container_name  -d $docker_hub_memcache_image
}

function service_start_php_in_box () {
    get_image $1
    container_name="phpfpm"
    check_and_stop_service $container_name 

    docker_exec="docker run --net=host --name $container_name -d "
   
    if [ $dns != "" ]
    then
        docker_exec="$docker_exec --dns=$dns "
    fi

    for i in ${add_host[*]}
    do
        docker_exec="$docker_exec --add-host $i "
    done
    
    docker_exec="$docker_exec -v $php_app:/app -v $php_ini:/usr/local/etc/php/php.ini "
    docker_exec="$docker_exec $choise_image"

    $docker_exec
}

function service_start_nginx_in_local() {
    check_and_stop_service nginx_server
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

    nginx_exec="$nginx_exec -v $php_app:/app nginx "

    $nginx_exec
}

function service_stop () {
    check_and_stop_service nginx_server 
    if [ "$(docker-machine ls | grep $docker_machine_name | awk '{ print $4 }')" != "Running" ]
    then
        return 1
    fi

   eval $(docker-machine env $docker_machine_name)
   check_and_stop_service b-redis
   check_and_stop_service b-memcache
   check_and_stop_service phpfpm
   unset_docker_export
}

function unset_docker_export() {
    unset DOCKER_TLS_VERIFY  DOCKER_HOST DOCKER_CERT_PATH DOCKER_MACHINE_NAME DOCKER_API_VERSION
}


function start_service() {
    php_version=$1

    service_start_nginx_in_local 
    check_virtualbox run
    eval $(docker-machine env $docker_machine_name)
    service_start_memcache_in_box
    service_start_redis_in_box

    case $php_version in 
        php5)
            service_start_php_in_box php5 
            ;;
        php7)
            service_start_php_in_box php7
            ;;
        *)
            echo "select in [php5]/[php7]"
            ;;
    esac

    unset_docker_export
}

function check_virtualbox() {
    osWant=$1 #[run] or [s] or [prepare]
    #check isset virualbox os
    if [ -z "$(docker-machine ls | grep $docker_machine_name)" ]
    then
        docker-machine create -d virtualbox $docker_machine_name
        echo ""
        echo "--------------------------------------------------"
        echo "| Need run:"
        echo "| 1. docker-machine ssh $docker_machine_name"
        echo '| 2. sudo sed -i "s|EXTRA_ARGS='|EXTRA_ARGS='--registry-mirror=http://7a1ec455.m.daocloud.io |g" /var/lib/boot2docker/profile'
        echo "| 3. exit"
        echo "| 4. docker-machine restart $docker_machine_name"
        echo "|"
        echo "--------------------------------------------------"
        exit 0
    fi

    #check os status
    vmstatus="Stop"
    if [ "$(docker-machine ls | grep $docker_machine_name | awk '{ print $4 }')" == "Running" ]
    then
        vmstatus="Running"
    fi

    if [[ $osWant == "run" && $vmstatus == "Stop" ]]
    then
        docker-machine start $docker_machine_name
    fi

    if [[ $osWant == "s" && $vmstatus == "Running" ]]
    then
        docker-machine stop $docker_machine_name
    fi
}

#main 
unset_docker_export
#检查并准备docker-machine
check_virtualbox prepare

case $choise in 
start )
    php_version=$2
    start_service $php_version 
    ;;

stop )
    service_stop
    check_virtualbox s
    ;;
restart )
    service_stop 
    php_version=$2
    start_service $php_version
    ;;

php5)
    start_docker_machine
    eval $(docker-machine env $docker_machine_name)

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
    unset_docker_export
    ;;
php7)
    start_docker_machine
    eval $(docker-machine env $docker_machine_name)

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
    unset_docker_export
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




