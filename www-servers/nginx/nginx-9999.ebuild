# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NGINX_SUBSYSTEMS=(+http stream mail)
NGINX_MODULES=(
	+http_{charset,gzip,ssi,userid,access,auth_basic,mirror,autoindex,geo,map}
	+http_{split_clients,referer,rewrite,proxy,fastcgi,uwsgi,scgi,grpc}
	+http_{memcached,limit_conn,limit_req,empty_gif,browser,upstream_hash}
	+http_{upstream_ip_hash,upstream_least_conn,upstream_random}
	+http_{upstream_keepalive,upstream_zone}
	http_{ssl,v2,v3,realip,addition,xslt,image_filter,geoip,sub,dav,flv,mp4}
	http_{gunzip,gzip_static,auth_request,random_index,secure_link,degradation}
	http_{slice,stub_status,perl}
	+mail_{pop3,imap,smtp}
	mail_ssl
	+stream_{limit_conn,access,geo,map,split_clients,return,pass,set}
	+stream_{upstream_hash,upstream_least_conn,upstream_random,upstream_zone}
	stream_{ssl,realip,geoip,ssl_preread}
)
NGINX_UPDATE_STREAM=live
NGINX_TESTS_COMMIT=live
NGINX_MISC_FILES=(
	nginx-{r2.logrotate,r2.service,r4.conf,r5.initd,r1.confd}
	nginx.tmpfiles
)

inherit nginx
