FROM php:5.6-fpm

RUN buildDeps='libfreetype6-dev libjpeg62-turbo-dev libpng12-dev zlib1g-dev libxml2-dev  wget ' \
    && apt-get update && apt-get install -y $buildDeps \
    && apt-get install -y  graphviz libcurl4-gnutls-dev curl libmcrypt-dev libmemcached-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt opcache xml pdo pdo_mysql mysqli sockets \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install xdebug-2.5.0 \
    && pecl install memcache-2.2.7 \
    && pecl install memcached \
    && pecl install redis-3.1.0 \
    && pecl install solr-2.4.0 \
    && docker-php-ext-enable memcache memcached redis xdebug solr \
    && wget http://pecl.php.net/get/yaf-2.3.5.tgz \
    && tar zxvf yaf-2.3.5.tgz \
    && rm yaf-2.3.5.tgz \
    && ( \
        cd yaf-2.3.5 \
        && phpize \
        && ./configure \
        && make -j$(nproc) \
        && make install \
    ) \
        && rm -r yaf-2.3.5 \
        && wget http://pecl.php.net/get/yac-0.9.2.tgz \
        && tar zxvf yac-0.9.2.tgz \
        && rm yac-0.9.2.tgz \
        && ( \
            cd yac-0.9.2 \
            && phpize \
            && ./configure \
            && make -j$(nproc) \
            && make install \
        ) \
            && rm -r yac-0.9.2 \
            && pecl install yar-1.2.5 \
            && pecl install xhprof-0.9.4 \
            && docker-php-ext-enable yaf yar xhprof yac \
            && apt-get purge -y --auto-remove $buildDeps
