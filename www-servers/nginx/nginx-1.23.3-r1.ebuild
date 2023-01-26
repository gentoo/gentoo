# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following requirements in mind before adding external modules:
#	* alive upstream
#	* sane packaging
#	* builds cleanly
#	* does not need a patch for nginx core
# - TODO: test the google-perftools module (included in vanilla tarball)

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# devel_kit (https://github.com/simpl/ngx_devel_kit - BSD license)
DEVEL_KIT_MODULE_PV="0.3.2"
DEVEL_KIT_MODULE_P="ngx_devel_kit-${DEVEL_KIT_MODULE_PV}"
DEVEL_KIT_MODULE_URI="https://github.com/simpl/ngx_devel_kit/archive/v${DEVEL_KIT_MODULE_PV}.tar.gz"
DEVEL_KIT_MODULE_WD="${WORKDIR}/ngx_devel_kit-${DEVEL_KIT_MODULE_PV}"

# ngx_brotli (https://github.com/google/ngx_brotli - BSD-2 license)
HTTP_BROTLI_MODULE_PV="6e975bcb015f62e1f303054897783355e2a877dc"
HTTP_BROTLI_MODULE_P="ngx_brotli-${HTTP_BROTLI_MODULE_PV}"
HTTP_BROTLI_MODULE_URI="https://github.com/google/ngx_brotli/archive/${HTTP_BROTLI_MODULE_PV}.tar.gz"
HTTP_BROTLI_MODULE_WD="${WORKDIR}/ngx_brotli-${HTTP_BROTLI_MODULE_PV}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module - BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="68b3ab3b64a0cee7f785d161401c8be357bbed12"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_http_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/masterzen/nginx-upload-progress-module/archive/${HTTP_UPLOAD_PROGRESS_MODULE_PV}.tar.gz"
HTTP_UPLOAD_PROGRESS_MODULE_WD="${WORKDIR}/nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"

# http_headers_more (https://github.com/openresty/headers-more-nginx-module - BSD license)
HTTP_HEADERS_MORE_MODULE_PV="33b646d69f39604d71342ee241633975aa122b35"
HTTP_HEADERS_MORE_MODULE_P="ngx_http_headers_more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/openresty/headers-more-nginx-module/archive/${HTTP_HEADERS_MORE_MODULE_PV}.tar.gz"
HTTP_HEADERS_MORE_MODULE_WD="${WORKDIR}/headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/ - https://github.com/FRiCKLE/ngx_cache_purge - BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.3"
HTTP_CACHE_PURGE_MODULE_P="ngx_http_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"
HTTP_CACHE_PURGE_MODULE_URI="http://labs.frickle.com/files/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}.tar.gz"
HTTP_CACHE_PURGE_MODULE_WD="${WORKDIR}/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# http_slowfs_cache (https://github.com/FRiCKLE/ngx_slowfs_cache/ - http://labs.frickle.com/nginx_ngx_slowfs_cache/ - BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_http_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="http://labs.frickle.com/files/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}.tar.gz"
HTTP_SLOWFS_CACHE_MODULE_WD="${WORKDIR}/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

# http_fancyindex (https://github.com/aperezdc/ngx-fancyindex - BSD license)
HTTP_FANCYINDEX_MODULE_PV="cbc0d3fca4f06414612de441399393d4b3bbb315"
HTTP_FANCYINDEX_MODULE_P="ngx_http_fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/aperezdc/ngx-fancyindex/archive/${HTTP_FANCYINDEX_MODULE_PV}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/ngx-fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"

# http_lua (https://github.com/openresty/lua-nginx-module - BSD license)
HTTP_LUA_MODULE_PV="0.10.23rc1"
HTTP_LUA_MODULE_P="ngx_http_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_URI="https://github.com/openresty/lua-nginx-module/archive/v${HTTP_LUA_MODULE_PV}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/lua-nginx-module-${HTTP_LUA_MODULE_PV}"
LUA_COMPAT=( luajit )

# http_auth_pam (https://github.com/stogh/ngx_http_auth_pam_module/ - http://web.iti.upv.es/~sto/nginx/ - BSD-2 license)
HTTP_AUTH_PAM_MODULE_PV="1.5.3"
HTTP_AUTH_PAM_MODULE_P="ngx_http_auth_pam-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="https://github.com/stogh/ngx_http_auth_pam_module/archive/v${HTTP_AUTH_PAM_MODULE_PV}.tar.gz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module - BSD license)
HTTP_UPSTREAM_CHECK_MODULE_PV="0.4.0"
HTTP_UPSTREAM_CHECK_MODULE_P="ngx_http_upstream_check-${HTTP_UPSTREAM_CHECK_MODULE_PV}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/yaoweibin/nginx_upstream_check_module/archive/v${HTTP_UPSTREAM_CHECK_MODULE_PV}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/nginx_upstream_check_module-${HTTP_UPSTREAM_CHECK_MODULE_PV}"

# http_metrics (https://github.com/zenops/ngx_metrics - BSD license) - dropped by it's maintainer
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="ngx_metrics-${HTTP_METRICS_MODULE_PV}"
HTTP_METRICS_MODULE_URI="https://github.com/madvertise/ngx_metrics/archive/v${HTTP_METRICS_MODULE_PV}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/ngx_metrics-${HTTP_METRICS_MODULE_PV}"

# http_vhost_traffic_status (https://github.com/vozlt/nginx-module-vts - BSD-2 license)
HTTP_VHOST_TRAFFIC_STATUS_MODULE_PV="0.2.1"
HTTP_VHOST_TRAFFIC_STATUS_MODULE_P="ngx_http_vhost_traffic_status-${HTTP_VHOST_TRAFFIC_STATUS_MODULE_PV}"
HTTP_VHOST_TRAFFIC_STATUS_MODULE_URI="https://github.com/vozlt/nginx-module-vts/archive/v${HTTP_VHOST_TRAFFIC_STATUS_MODULE_PV}.tar.gz"
HTTP_VHOST_TRAFFIC_STATUS_MODULE_WD="${WORKDIR}/nginx-module-vts-${HTTP_VHOST_TRAFFIC_STATUS_MODULE_PV}"

# naxsi-core (https://github.com/wargio/naxsi - GPL-3 license)
HTTP_NAXSI_MODULE_PV="1.4"
HTTP_NAXSI_MODULE_P="ngx_http_naxsi-${HTTP_NAXSI_MODULE_PV}"
HTTP_NAXSI_MODULE_URI="https://github.com/wargio/naxsi/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/naxsi-${HTTP_NAXSI_MODULE_PV}/naxsi_src"

# naxsi-libinjection (https://github.com/libinjection/libinjection - BSD license)
HTTP_NAXSI_LIBINJECTION_MODULE_PV="4d66612db53594df5fda4e1ee8a382f32109644d"
HTTP_NAXSI_LIBINJECTION_MODULE_P="ngx_http_naxsi_libinjection-${HTTP_NAXSI_LIBINJECTION_MODULE_PV}"
HTTP_NAXSI_LIBINJECTION_MODULE_URI="https://github.com/libinjection/libinjection/archive/${HTTP_NAXSI_LIBINJECTION_MODULE_PV}.tar.gz"

# nginx-rtmp-module (https://github.com/arut/nginx-rtmp-module - BSD license)
RTMP_MODULE_PV="23e1873aa62acb58b7881eed2a501f5bf35b82e9"
RTMP_MODULE_P="ngx_rtmp-${RTMP_MODULE_PV}"
RTMP_MODULE_URI="https://github.com/arut/nginx-rtmp-module/archive/${RTMP_MODULE_PV}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/nginx-rtmp-module-${RTMP_MODULE_PV}"

# nginx-dav-ext-module (https://github.com/arut/nginx-dav-ext-module - BSD-2 license)
HTTP_DAV_EXT_MODULE_PV="3.0.0"
HTTP_DAV_EXT_MODULE_P="ngx_http_dav_ext-${HTTP_DAV_EXT_MODULE_PV}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/arut/nginx-dav-ext-module/archive/v${HTTP_DAV_EXT_MODULE_PV}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/nginx-dav-ext-module-${HTTP_DAV_EXT_MODULE_PV}"

# echo-nginx-module (https://github.com/openresty/echo-nginx-module - BSD-2 license)
HTTP_ECHO_MODULE_PV="0.63"
HTTP_ECHO_MODULE_P="ngx_http_echo-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_URI="https://github.com/openresty/echo-nginx-module/archive/v${HTTP_ECHO_MODULE_PV}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/echo-nginx-module-${HTTP_ECHO_MODULE_PV}"

# modsecurity for nginx (https://github.com/SpiderLabs/ModSecurity-nginx - https://github.com/SpiderLabs/ModSecurity - Apache-2.0 license)
HTTP_SECURITY_MODULE_PV="1.0.3"
HTTP_SECURITY_MODULE_P="modsecurity-nginx-${HTTP_SECURITY_MODULE_PV}"
HTTP_SECURITY_MODULE_URI="https://github.com/SpiderLabs/ModSecurity-nginx/archive/refs/tags/v${HTTP_SECURITY_MODULE_PV}.tar.gz"
HTTP_SECURITY_MODULE_WD="${WORKDIR}/ModSecurity-nginx-${HTTP_SECURITY_MODULE_PV}"

# push-stream-module (http://www.nginxpushstream.com - https://github.com/wandenberg/nginx-push-stream-module - GPL-3 license)
HTTP_PUSH_STREAM_MODULE_PV="8c02220d484d7848bc8e3a6d9b1c616987e86f66"
HTTP_PUSH_STREAM_MODULE_P="ngx_http_push_stream-${HTTP_PUSH_STREAM_MODULE_PV}"
HTTP_PUSH_STREAM_MODULE_URI="https://github.com/wandenberg/nginx-push-stream-module/archive/${HTTP_PUSH_STREAM_MODULE_PV}.tar.gz"
HTTP_PUSH_STREAM_MODULE_WD="${WORKDIR}/nginx-push-stream-module-${HTTP_PUSH_STREAM_MODULE_PV}"

# sticky-module (https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng - BSD-2 license)
HTTP_STICKY_MODULE_PV="1.2.6-10-g08a395c66e42"
HTTP_STICKY_MODULE_P="nginx_http_sticky_module_ng-${HTTP_STICKY_MODULE_PV}"
HTTP_STICKY_MODULE_URI="https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/${HTTP_STICKY_MODULE_PV}.tar.bz2"
HTTP_STICKY_MODULE_WD="${WORKDIR}/nginx-goodies-nginx-sticky-module-ng-08a395c66e42"

# mogilefs-module (https://github.com/vkholodkov/nginx-mogilefs-module - BSD license)
HTTP_MOGILEFS_MODULE_PV="020937ff4624fc31928adb51a5c43753bf256b34"
HTTP_MOGILEFS_MODULE_P="ngx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"
HTTP_MOGILEFS_MODULE_URI="https://github.com/vkholodkov/nginx-mogilefs-module/archive/${HTTP_MOGILEFS_MODULE_PV}.tar.gz"
HTTP_MOGILEFS_MODULE_WD="${WORKDIR}/nginx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"

# memc-module (https://github.com/openresty/memc-nginx-module - BSD-2 license)
HTTP_MEMC_MODULE_PV="c507601211b971fc8b22ed2ce642c80b154791f6"
HTTP_MEMC_MODULE_P="ngx_memc_module-${HTTP_MEMC_MODULE_PV}"
HTTP_MEMC_MODULE_URI="https://github.com/openresty/memc-nginx-module/archive/${HTTP_MEMC_MODULE_PV}.tar.gz"
HTTP_MEMC_MODULE_WD="${WORKDIR}/memc-nginx-module-${HTTP_MEMC_MODULE_PV}"

# nginx-ldap-auth-module (https://github.com/kvspb/nginx-auth-ldap - BSD-2 license)
HTTP_LDAP_MODULE_PV="83c059b73566c2ee9cbda920d91b66657cf120b7"
HTTP_LDAP_MODULE_P="nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"
HTTP_LDAP_MODULE_URI="https://github.com/kvspb/nginx-auth-ldap/archive/${HTTP_LDAP_MODULE_PV}.tar.gz"
HTTP_LDAP_MODULE_WD="${WORKDIR}/nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"

# geoip2 (https://github.com/leev/ngx_http_geoip2_module - BSD-2 license)
GEOIP2_MODULE_PV="3.4"
GEOIP2_MODULE_P="ngx_http_geoip2_module-${GEOIP2_MODULE_PV}"
GEOIP2_MODULE_URI="https://github.com/leev/ngx_http_geoip2_module/archive/${GEOIP2_MODULE_PV}.tar.gz"
GEOIP2_MODULE_WD="${WORKDIR}/ngx_http_geoip2_module-${GEOIP2_MODULE_PV}"

# njs-module (https://github.com/nginx/njs - BSD-2 license)
NJS_MODULE_PV="0.7.9"
NJS_MODULE_P="njs-${NJS_MODULE_PV}"
NJS_MODULE_URI="https://github.com/nginx/njs/archive/${NJS_MODULE_PV}.tar.gz"
NJS_MODULE_WD="${WORKDIR}/njs-${NJS_MODULE_PV}"

# We handle deps below ourselves
SSL_DEPS_SKIP=1
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools lua-single ssl-cert toolchain-funcs perl-module systemd pax-utils

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="https://nginx.org"
SRC_URI="
	https://nginx.org/download/${P}.tar.gz
	${DEVEL_KIT_MODULE_URI} -> ${DEVEL_KIT_MODULE_P}.tar.gz
	nginx_modules_http_auth_ldap? ( ${HTTP_LDAP_MODULE_URI} -> ${HTTP_LDAP_MODULE_P}.tar.gz )
	nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
	nginx_modules_http_brotli? ( ${HTTP_BROTLI_MODULE_URI} -> ${HTTP_BROTLI_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} -> ${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( ${HTTP_ECHO_MODULE_URI} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_fancyindex? ( ${HTTP_FANCYINDEX_MODULE_URI} -> ${HTTP_FANCYINDEX_MODULE_P}.tar.gz )
	nginx_modules_http_geoip2? ( ${GEOIP2_MODULE_URI} -> ${GEOIP2_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_javascript? ( ${NJS_MODULE_URI} -> ${NJS_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( ${HTTP_MEMC_MODULE_URI} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
	nginx_modules_http_mogilefs? ( ${HTTP_MOGILEFS_MODULE_URI} -> ${HTTP_MOGILEFS_MODULE_P}.tar.gz )
	nginx_modules_http_naxsi? (
		${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz
		${HTTP_NAXSI_LIBINJECTION_MODULE_URI} -> ${HTTP_NAXSI_LIBINJECTION_MODULE_P}.tar.gz
	)
	nginx_modules_http_push_stream? ( ${HTTP_PUSH_STREAM_MODULE_URI} -> ${HTTP_PUSH_STREAM_MODULE_P}.tar.gz )
	nginx_modules_http_security? ( ${HTTP_SECURITY_MODULE_URI} -> ${HTTP_SECURITY_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} -> ${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	nginx_modules_http_sticky? ( ${HTTP_STICKY_MODULE_URI} -> ${HTTP_STICKY_MODULE_P}.tar.bz2 )
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
	nginx_modules_http_vhost_traffic_status? ( ${HTTP_VHOST_TRAFFIC_STATUS_MODULE_URI} -> ${HTTP_VHOST_TRAFFIC_STATUS_MODULE_P}.tar.gz )
	nginx_modules_stream_geoip2? ( ${GEOIP2_MODULE_URI} -> ${GEOIP2_MODULE_P}.tar.gz )
	nginx_modules_stream_javascript? ( ${NJS_MODULE_URI} -> ${NJS_MODULE_P}.tar.gz )
	rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
"

LICENSE="BSD-2 BSD SSLeay MIT GPL-2 GPL-2+ nginx_modules_http_security? ( Apache-2.0 ) nginx_modules_http_push_stream? ( GPL-3 )"

SLOT="mainline"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

# Package doesn't provide a real test suite
RESTRICT="test"

NGINX_MODULES_STD="
	access auth_basic autoindex browser charset empty_gif fastcgi geo
	grpc gzip limit_req limit_conn map memcached mirror proxy referer
	rewrite scgi ssi split_clients upstream_hash upstream_ip_hash
	upstream_keepalive upstream_least_conn upstream_zone userid uwsgi
"
NGINX_MODULES_OPT="
	addition auth_request dav degradation flv geoip gunzip gzip_static
	image_filter mp4 perl random_index realip secure_link slice stub_status
	sub xslt
"
NGINX_MODULES_STREAM_STD="
	access geo limit_conn map return split_clients upstream_hash
	upstream_least_conn upstream_zone
"
NGINX_MODULES_STREAM_OPT="geoip realip ssl_preread"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
	http_auth_ldap
	http_auth_pam
	http_brotli
	http_cache_purge
	http_dav_ext
	http_echo
	http_fancyindex
	http_geoip2
	http_headers_more
	http_javascript
	http_lua
	http_memc
	http_metrics
	http_mogilefs
	http_naxsi
	http_push_stream
	http_security
	http_slowfs_cache
	http_sticky
	http_upload_progress
	http_upstream_check
	http_vhost_traffic_status
	stream_geoip2
	stream_javascript
"

IUSE="aio debug +http +http2 +http-cache libatomic pcre +pcre2 pcre-jit rtmp selinux ssl threads vim-syntax"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_STREAM_STD; do
	IUSE="${IUSE} nginx_modules_stream_${mod}"
done

for mod in $NGINX_MODULES_STREAM_OPT; do
	IUSE="${IUSE} nginx_modules_stream_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

# Add so we can warn users updating about config changes
# @TODO: jbergstroem: remove on next release series
IUSE="${IUSE} nginx_modules_http_spdy"

COMMON_DEPEND="
	acct-group/nginx
	acct-user/nginx
	virtual/libcrypt:=
	pcre? ( dev-libs/libpcre:= )
	pcre2? ( dev-libs/libpcre2:= )
	pcre-jit? ( dev-libs/libpcre:=[jit] )
	ssl? (
		dev-libs/openssl:0=
	)
	http2? (
		>=dev-libs/openssl-1.0.1c:0=
	)
	http-cache? (
		dev-libs/openssl:0=
	)
	nginx_modules_http_brotli? ( app-arch/brotli:= )
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_geoip2? ( dev-libs/libmaxminddb:= )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd:=[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8:= )
	nginx_modules_http_rewrite? ( dev-libs/libpcre:= )
	nginx_modules_http_secure_link? ( dev-libs/openssl:0= )
	nginx_modules_http_xslt? ( dev-libs/libxml2:= dev-libs/libxslt )
	nginx_modules_http_lua? ( ${LUA_DEPS} )
	nginx_modules_http_auth_pam? ( sys-libs/pam )
	nginx_modules_http_metrics? ( dev-libs/yajl:= )
	nginx_modules_http_dav_ext? ( dev-libs/libxml2 )
	nginx_modules_http_security? ( dev-libs/modsecurity )
	nginx_modules_http_auth_ldap? ( net-nds/openldap:=[ssl?] )
	nginx_modules_stream_geoip? ( dev-libs/geoip )
	nginx_modules_stream_geoip2? ( dev-libs/libmaxminddb:= )
"
RDEPEND="
	${COMMON_DEPEND}
	app-misc/mime-types[nginx]
	selinux? ( sec-policy/selinux-nginx )
	!www-servers/nginx:0
"
DEPEND="
	${COMMON_DEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )
"
BDEPEND="nginx_modules_http_brotli? ( virtual/pkgconfig )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

REQUIRED_USE="
	pcre-jit? ( pcre )
	nginx_modules_http_fancyindex? ( nginx_modules_http_addition )
	nginx_modules_http_grpc? ( http2 )
	nginx_modules_http_lua? (
		${LUA_REQUIRED_USE}
		nginx_modules_http_rewrite
		pcre
		!pcre2
	)
	nginx_modules_http_naxsi? ( nginx_modules_http_rewrite pcre )
	nginx_modules_http_dav_ext? ( nginx_modules_http_dav nginx_modules_http_xslt )
	nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
	nginx_modules_http_security? ( pcre )
	nginx_modules_http_push_stream? ( ssl )
"

pkg_setup() {
	NGINX_HOME="/var/lib/nginx"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	if use libatomic; then
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use !http; then
		ewarn "To actually disable all http-functionality you also have"
		ewarn "to disable all nginx http modules."
	fi

	if use nginx_modules_http_mogilefs && use threads; then
		eerror "mogilefs won't compile with threads support."
		eerror "Please disable either flag and try again."
		die "Can't compile mogilefs with threads support"
	fi

	use nginx_modules_http_lua && lua-single_pkg_setup
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.4.1-fix-perl-install-path.patch"
	eapply "${FILESDIR}/${PN}-httpoxy-mitigation-r1.patch"

	if use nginx_modules_http_auth_ldap; then
		cd "${HTTP_LDAP_MODULE_WD}" || die
		eapply "${FILESDIR}/${PN}-1.23.2-mod_auth_ldap-fix.patch"
		cd "${S}" || die
	fi

	if use nginx_modules_http_sticky; then
		cd "${HTTP_STICKY_MODULE_WD}" || die
		eapply "${FILESDIR}"/http_sticky-nginx-1.23.0.patch
		cd "${S}" || die
	fi

	if use nginx_modules_http_naxsi; then
		cd "${HTTP_NAXSI_MODULE_WD}" || die
		rm -r libinjection || die
		mv ../../libinjection-${HTTP_NAXSI_LIBINJECTION_MODULE_PV} libinjection || die
		cd "${S}" || die
	fi

	if use nginx_modules_http_brotli; then
		cd "${HTTP_BROTLI_MODULE_WD}" || die
		eapply "${FILESDIR}"/http_brotli-detect-brotli-r3.patch
		cd "${S}" || die
	fi

	if use nginx_modules_http_upstream_check; then
		eapply -p0 "${FILESDIR}"/http_upstream_check-nginx-1.11.5+.patch
	fi

	if use nginx_modules_http_cache_purge; then
		cd "${HTTP_CACHE_PURGE_MODULE_WD}" || die
		eapply "${FILESDIR}"/http_cache_purge-1.11.6+.patch
		cd "${S}" || die
	fi

	if use nginx_modules_http_upload_progress; then
		cd "${HTTP_UPLOAD_PROGRESS_MODULE_WD}" || die
		eapply "${FILESDIR}"/http_uploadprogress-nginx-1.23.0.patch
		cd "${S}" || die
	fi

	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):' || die
	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die
	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done

	eapply_user
}

src_configure() {
	local myconf=() http_enabled= mail_enabled= stream_enabled=

	use aio       && myconf+=( --with-file-aio )
	use debug     && myconf+=( --with-debug )
	use http2     && myconf+=( --with-http_v2_module )
	use libatomic && myconf+=( --with-libatomic )
	use pcre      && myconf+=( --with-pcre --without-pcre2 )
	use pcre-jit  && myconf+=( --with-pcre-jit )
	use threads   && myconf+=( --with-threads )

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=( --without-http_${mod}_module )
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf+=( --with-http_${mod}_module )
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=( --with-http_realip_module )
	fi

	# third-party modules
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_UPLOAD_PROGRESS_MODULE_WD} )
	fi

	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_HEADERS_MORE_MODULE_WD} )
	fi

	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_CACHE_PURGE_MODULE_WD} )
	fi

	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_SLOWFS_CACHE_MODULE_WD} )
	fi

	if use nginx_modules_http_fancyindex; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_FANCYINDEX_MODULE_WD} )
	fi

	if use nginx_modules_http_lua; then
		http_enabled=1
		export LUAJIT_LIB=$(dirname $(lua_get_shared_lib))
		export LUAJIT_INC=$(lua_get_include_dir)
		myconf+=( --add-module=${DEVEL_KIT_MODULE_WD} )
		myconf+=( --add-module=${HTTP_LUA_MODULE_WD} )
	fi

	if use nginx_modules_http_auth_pam; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_AUTH_PAM_MODULE_WD} )
	fi

	if use nginx_modules_http_upstream_check; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_UPSTREAM_CHECK_MODULE_WD} )
	fi

	if use nginx_modules_http_metrics; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_METRICS_MODULE_WD} )
	fi

	if use nginx_modules_http_naxsi ; then
		http_enabled=1
		myconf+=(  --add-module=${HTTP_NAXSI_MODULE_WD} )
	fi

	if use rtmp ; then
		http_enabled=1
		myconf+=( --add-module=${RTMP_MODULE_WD} )
	fi

	if use nginx_modules_http_dav_ext ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_DAV_EXT_MODULE_WD} )
	fi

	if use nginx_modules_http_echo ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_ECHO_MODULE_WD} )
	fi

	if use nginx_modules_http_security ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_SECURITY_MODULE_WD} )
	fi

	if use nginx_modules_http_push_stream ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_PUSH_STREAM_MODULE_WD} )
	fi

	if use nginx_modules_http_sticky ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_STICKY_MODULE_WD} )
	fi

	if use nginx_modules_http_mogilefs ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_MOGILEFS_MODULE_WD} )
	fi

	if use nginx_modules_http_memc ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_MEMC_MODULE_WD} )
	fi

	if use nginx_modules_http_auth_ldap; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_LDAP_MODULE_WD} )
	fi

	if use nginx_modules_http_vhost_traffic_status; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_VHOST_TRAFFIC_STATUS_MODULE_WD} )
	fi

	if use nginx_modules_http_geoip2 || use nginx_modules_stream_geoip2; then
		myconf+=( --add-module=${GEOIP2_MODULE_WD} )
	fi

	if use nginx_modules_http_javascript || use nginx_modules_stream_javascript; then
		myconf+=( --add-module="${NJS_MODULE_WD}/nginx" )
	fi

	if use nginx_modules_http_brotli; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_BROTLI_MODULE_WD} )
	fi

	if use http || use http-cache || use http2 || use nginx_modules_http_javascript; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=( --without-http-cache )
		use ssl && myconf+=( --with-http_ssl_module )
	else
		myconf+=( --without-http --without-http-cache )
	fi

	# Stream modules
	for mod in $NGINX_MODULES_STREAM_STD; do
		if use nginx_modules_stream_${mod}; then
			stream_enabled=1
		else
			myconf+=( --without-stream_${mod}_module )
		fi
	done

	for mod in $NGINX_MODULES_STREAM_OPT; do
		if use nginx_modules_stream_${mod}; then
			stream_enabled=1
			myconf+=( --with-stream_${mod}_module )
		fi
	done

	if use nginx_modules_stream_geoip2 || use nginx_modules_stream_javascript; then
		stream_enabled=1
	fi

	if [ $stream_enabled ]; then
		myconf+=( --with-stream )
		use ssl && myconf+=( --with-stream_ssl_module )
	fi

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf+=( --without-mail_${mod}_module )
		fi
	done

	if [ $mail_enabled ]; then
		myconf+=( --with-mail )
		use ssl && myconf+=( --with-mail_ssl_module )
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=(  --add-module=${mod} )
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export AR CC

	if ! use prefix; then
		myconf+=( --user=${PN} )
		myconf+=( --group=${PN} )
	fi

	if [[ -n "${EXTRA_ECONF}" ]]; then
		myconf+=( ${EXTRA_ECONF} )
		ewarn "EXTRA_ECONF applied. Now you are on your own, good luck!"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error_log \
		--pid-path="${EPREFIX}"/run/${PN}.pid \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--with-cc-opt="-I${ESYSROOT}/usr/include" \
		--with-ld-opt="-L${ESYSROOT}/usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}"/var/log/${PN}/access_log \
		--http-client-body-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/client \
		--http-proxy-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/proxy \
		--http-fastcgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/fastcgi \
		--http-scgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/scgi \
		--http-uwsgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/uwsgi \
		--with-compat \
		"${myconf[@]}" || die "configure failed"

	# A purely cosmetic change that makes nginx -V more readable. This can be
	# good if people outside the gentoo community would troubleshoot and
	# question the users setup.
	sed -i -e "s|${WORKDIR}|external_module|g" objs/ngx_auto_config.h || die
}

src_compile() {
	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install

	cp "${FILESDIR}"/nginx.conf-r3 "${ED}"/etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd-r4 nginx
	newconfd "${FILESDIR}"/nginx.confd nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	doman man/nginx.8
	dodoc CHANGES* README

	# just keepdir. do not copy the default htdocs files (bug #449136)
	keepdir /var/www/localhost
	rm -rf "${ED}"/usr/html || die

	# set up a list of directories to keep
	local keepdir_list="${NGINX_HOME_TMP}"/client
	local module
	for module in proxy fastcgi scgi uwsgi; do
		use nginx_modules_http_${module} && keepdir_list+=" ${NGINX_HOME_TMP}/${module}"
	done

	keepdir /var/log/nginx ${keepdir_list}

	# this solves a problem with SELinux where nginx doesn't see the directories
	# as root and tries to create them as nginx
	fperms 0750 "${NGINX_HOME_TMP}"
	fowners ${PN}:0 "${NGINX_HOME_TMP}"

	fperms 0700 ${keepdir_list}
	fowners ${PN}:${PN} ${keepdir_list}

	fperms 0710 /var/log/nginx
	fowners 0:${PN} /var/log/nginx

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate-r1 nginx

	# Don't create /run
	rm -rf "${ED}"/run || die

	if use lua_single_target_luajit; then
		pax-mark m "${ED}/usr/sbin/nginx"
	fi

	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/ || die
		emake DESTDIR="${D}" INSTALLDIRS=vendor
		perl_delete_localpod
		cd "${S}" || die
	fi

	if use nginx_modules_http_cache_purge; then
		docinto ${HTTP_CACHE_PURGE_MODULE_P}
		dodoc "${HTTP_CACHE_PURGE_MODULE_WD}"/{CHANGES,README.md,TODO.md}
	fi

	if use nginx_modules_http_slowfs_cache; then
		docinto ${HTTP_SLOWFS_CACHE_MODULE_P}
		dodoc "${HTTP_SLOWFS_CACHE_MODULE_WD}"/{CHANGES,README.md}
	fi

	if use nginx_modules_http_fancyindex; then
		docinto ${HTTP_FANCYINDEX_MODULE_P}
		dodoc "${HTTP_FANCYINDEX_MODULE_WD}"/README.rst
	fi

	if use nginx_modules_http_lua; then
		docinto ${HTTP_LUA_MODULE_P}
		dodoc "${HTTP_LUA_MODULE_WD}"/README.markdown
	fi

	if use nginx_modules_http_auth_pam; then
		docinto ${HTTP_AUTH_PAM_MODULE_P}
		dodoc "${HTTP_AUTH_PAM_MODULE_WD}"/{README.md,ChangeLog}
	fi

	if use nginx_modules_http_upstream_check; then
		docinto ${HTTP_UPSTREAM_CHECK_MODULE_P}
		dodoc "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/{README,CHANGES}
	fi

	if use nginx_modules_http_naxsi; then
		insinto /etc/nginx/naxsi
		doins "${HTTP_NAXSI_MODULE_WD}"/../distros/nginx/*
		doins "${HTTP_NAXSI_MODULE_WD}"/../naxsi_rules/naxsi_core.rules
		doins -r "${HTTP_NAXSI_MODULE_WD}"/../naxsi_rules/blocking
		doins -r "${HTTP_NAXSI_MODULE_WD}"/../naxsi_rules/whitelists
	fi

	if use rtmp; then
		docinto ${RTMP_MODULE_P}
		dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
	fi

	if use nginx_modules_http_dav_ext; then
		docinto ${HTTP_DAV_EXT_MODULE_P}
		dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README.rst
	fi

	if use nginx_modules_http_echo; then
		docinto ${HTTP_ECHO_MODULE_P}
		dodoc "${HTTP_ECHO_MODULE_WD}"/README.markdown
	fi

	if use nginx_modules_http_security; then
		docinto ${HTTP_SECURITY_MODULE_P}
		dodoc "${HTTP_SECURITY_MODULE_WD}"/{AUTHORS,CHANGES,README.md}
	fi

	if use nginx_modules_http_push_stream; then
		docinto ${HTTP_PUSH_STREAM_MODULE_P}
		dodoc "${HTTP_PUSH_STREAM_MODULE_WD}"/{AUTHORS,CHANGELOG.textile,README.textile}
	fi

	if use nginx_modules_http_sticky; then
		docinto ${HTTP_STICKY_MODULE_P}
		dodoc "${HTTP_STICKY_MODULE_WD}"/{README.md,Changelog.txt,docs/sticky.pdf}
	fi

	if use nginx_modules_http_memc; then
		docinto ${HTTP_MEMC_MODULE_P}
		dodoc "${HTTP_MEMC_MODULE_WD}"/README.markdown
	fi

	if use nginx_modules_http_auth_ldap; then
		docinto ${HTTP_LDAP_MODULE_P}
		dodoc "${HTTP_LDAP_MODULE_WD}"/example.conf
	fi
}

pkg_postinst() {
	if use ssl; then
		if [[ ! -f "${EROOT}"/etc/ssl/${PN}/${PN}.key ]]; then
			install_cert /etc/ssl/${PN}/${PN}
			use prefix || chown ${PN}:${PN} "${EROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	fi
}
