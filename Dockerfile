FROM lsiobase/alpine
MAINTAINER dewey <mail@notmyhostna.me>

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install runtime packages
RUN \
 apk add --no-cache \
	ca-certificates \
	curl \
	fcgi \
  git \
	geoip \
	gzip \
	logrotate \
	nginx \
	rtorrent \
	screen \
	tar \
	unrar \
	unzip \
	wget \
	zip && \

 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	php7 \
	php7-cgi \
	php7-fpm \
	php7-json  \
	php7-mbstring \
	php7-pear && \

# install build packages
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	cppunit-dev \
	curl-dev \
	file \
	g++ \
	gcc \
	libtool \
	make \
	ncurses-dev \
	openssl-dev && \

# install webui
 mkdir -p \
	/usr/share/webapps/rutorrent \
	/defaults/rutorrent-conf && \
 curl -o \
 /tmp/rutorrent.tar.gz -L \
	"https://github.com/Novik/ruTorrent/archive/master.tar.gz" && \
 tar xf \
 /tmp/rutorrent.tar.gz -C \
	/usr/share/webapps/rutorrent --strip-components=1 && \
 mv /usr/share/webapps/rutorrent/conf/* \
	/defaults/rutorrent-conf/ && \
 rm -rf \
	/defaults/rutorrent-conf/users && \

# install only rutorrent plugins needed
rm -rf /usr/share/webapps/rutorrent/plugins/_getdir \
  /usr/share/webapps/rutorrent/plugins/_noty \
  /usr/share/webapps/rutorrent/plugins/_noty2 \
  /usr/share/webapps/rutorrent/plugins/_task \
  /usr/share/webapps/rutorrent/plugins/autotools \
  /usr/share/webapps/rutorrent/plugins/check_port \
  /usr/share/webapps/rutorrent/plugins/chunks \
  /usr/share/webapps/rutorrent/plugins/cookies \
  /usr/share/webapps/rutorrent/plugins/cpuload \
  /usr/share/webapps/rutorrent/plugins/create \
  /usr/share/webapps/rutorrent/plugins/data \
  # /usr/share/webapps/rutorrent/plugins/datadir \
  /usr/share/webapps/rutorrent/plugins/diskspace \
  /usr/share/webapps/rutorrent/plugins/edit \
  # /usr/share/webapps/rutorrent/plugins/erasedata \
  /usr/share/webapps/rutorrent/plugins/extratio \
  /usr/share/webapps/rutorrent/plugins/extsearch \
  /usr/share/webapps/rutorrent/plugins/feeds \
  /usr/share/webapps/rutorrent/plugins/filedrop \
  # /usr/share/webapps/rutorrent/plugins/geoip \
  /usr/share/webapps/rutorrent/plugins/history \
  /usr/share/webapps/rutorrent/plugins/httprpc \
  /usr/share/webapps/rutorrent/plugins/ipad \
  /usr/share/webapps/rutorrent/plugins/loginmgr \
  /usr/share/webapps/rutorrent/plugins/lookat \
  /usr/share/webapps/rutorrent/plugins/mediainfo \
  /usr/share/webapps/rutorrent/plugins/ratio \
  /usr/share/webapps/rutorrent/plugins/retrackers \
  # /usr/share/webapps/rutorrent/plugins/rpc \
  /usr/share/webapps/rutorrent/plugins/rss \
  /usr/share/webapps/rutorrent/plugins/rssurlrewrite \
  /usr/share/webapps/rutorrent/plugins/rutracker_check \
  /usr/share/webapps/rutorrent/plugins/scheduler \
  /usr/share/webapps/rutorrent/plugins/screenshots \
  /usr/share/webapps/rutorrent/plugins/seedingtime \
  /usr/share/webapps/rutorrent/plugins/show_peers_like_wtorrent \
  # /usr/share/webapps/rutorrent/plugins/source \
  # /usr/share/webapps/rutorrent/plugins/theme \
  /usr/share/webapps/rutorrent/plugins/throttle \
  # /usr/share/webapps/rutorrent/plugins/tracklabels \
  /usr/share/webapps/rutorrent/plugins/trafic \
  /usr/share/webapps/rutorrent/plugins/unpack \
  /usr/share/webapps/rutorrent/plugins/xmpp && \

# get additional theme
git clone git://github.com/phlooo/ruTorrent-MaterialDesign.git /usr/share/webapps/rutorrent/plugins/theme/themes/MaterialDesign && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /downloads
