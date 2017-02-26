FROM php:7.1-fpm

RUN buildDeps='libxml2-dev  wget git zip unzip ' \
	&& apt-get update && apt-get install -y $buildDeps \
	&& apt-get install -y  graphviz libcurl4-gnutls-dev curl libmcrypt-dev libmemcached-dev libfreetype6-dev libjpeg62-turbo-dev libpng12-dev zlib1g-dev  \
	&& docker-php-ext-install -j$(nproc) iconv mcrypt opcache xml pdo pdo_mysql mysqli sockets \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
	&& pecl install redis-3.0.0 \
	&& pecl install solr-2.4.0 \
    && pecl install msgpack \
	&& docker-php-ext-enable redis solr msgpack \
	&& wget http://pecl.php.net/get/yaf-3.0.4.tgz \
	&& tar zxvf yaf-3.0.4.tgz \
	&& rm yaf-3.0.4.tgz \
	&& ( \
		cd yaf-3.0.4 \
		&& phpize \
		&& ./configure \
		&& make -j$(nproc) \
		&& make install \
	) \
	&& rm -r yaf-3.0.4 \
	&& wget http://pecl.php.net/get/yac-2.0.1.tgz \
	&& tar zxvf yac-2.0.1.tgz \
	&& rm yac-2.0.1.tgz \
	&& ( \
		cd yac-2.0.1 \
		&& phpize \
		&& ./configure \
		&& make -j$(nproc) \
		&& make install \
	) \
	&& rm -r yac-2.0.1 \
    && wget http://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.zip \
    && unzip NON_BLOCKING_IO_php7.zip \
    && rm NON_BLOCKING_IO_php7.zip \
    && ( \
        cd pecl-memcache-NON_BLOCKING_IO_php7 \
        && phpize \
        && ./configure --enable-memcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r pecl-memcache-NON_BLOCKING_IO_php7 \
    && git clone https://github.com/php-memcached-dev/php-memcached \
    && ( \
        cd php-memcached \
        && phpize \
        && ./configure --disable-memcached-sasl \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r php-memcached \
	&& pecl install yar-2.0.1 \
    && pecl install xdebug-2.5.0 \
    && wget http://github.com/Yaoguais/phpng-xhprof/archive/master.zip \
	&& unzip master.zip \
	&& rm master.zip \
	&& ( \
		cd phpng-xhprof-master \
		&& phpize \
		&& ./configure \
		&& make -j$(nproc) \
		&& make install \
	) \
	&& rm -r phpng-xhprof-master \
	&& docker-php-ext-enable yaf yar yac memcache memcached xdebug phpng_xhprof \
	&& apt-get purge -y --auto-remove $buildDeps
