FROM docker:23.0.6-dind

# Dependencies
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# https://github.com/openshift/origin/issues/18942#issuecomment-907780179
RUN apk add --no-cache \
	busybox-extras \
	curl \
	git \
    openssl \
    bash \
    iputils \
    lftp \
    jq \
    openssh-client \
    bash \
    vim \
    python3 \
    gcompat \
    mysql-client 

# CLI TOOLS
COPY bin/oc /usr/local/bin/
COPY bin/mc /usr/local/bin/
RUN chmod a+x /usr/local/bin/oc /usr/local/bin/mc \
&& ln -s /usr/local/bin/oc /usr/local/bin/kubectl

# ttyd
COPY bin/ttyd /usr/local/bin/
RUN chmod a+x /usr/local/bin/ttyd

# VIM
SHELL ["/bin/bash", "-c"]
RUN echo $'set tabstop=2 \n\
set shiftwidth=2 \n\
set autoindent \n\
set expandtab \n\
set softtabstop=0' >> /etc/vim/vimrc;

# PHP
RUN apk add --no-cache \
	php81 \
    php81-curl \
    php81-pdo \
    php81-pdo_mysql \
    php81-mysqli \
    php81-mbstring

# Docker
COPY docker /opt/www/

WORKDIR /opt/www

STOPSIGNAL SIGKILL

EXPOSE 8080

COPY entrypoint-child.sh /entrypoint-child.sh
ENTRYPOINT ["sh", "/entrypoint-child.sh"]

#ENTRYPOINT ["tail"]
#CMD ["-f","/dev/null"]
