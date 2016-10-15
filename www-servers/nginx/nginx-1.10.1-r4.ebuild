# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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

# devel_kit (https://github.com/simpl/ngx_devel_kit, BSD license)
DEVEL_KIT_MODULE_PV="0.3.0"
DEVEL_KIT_MODULE_P="ngx_devel_kit-${DEVEL_KIT_MODULE_PV}-r1"
DEVEL_KIT_MODULE_URI="https://github.com/simpl/ngx_devel_kit/archive/v${DEVEL_KIT_MODULE_PV}.tar.gz"
DEVEL_KIT_MODULE_WD="${WORKDIR}/ngx_devel_kit-${DEVEL_KIT_MODULE_PV}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.2"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_http_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}-r1"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/masterzen/nginx-upload-progress-module/archive/v${HTTP_UPLOAD_PROGRESS_MODULE_PV}.tar.gz"
HTTP_UPLOAD_PROGRESS_MODULE_WD="${WORKDIR}/nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"

# http_headers_more (https://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.31"
HTTP_HEADERS_MORE_MODULE_P="ngx_http_headers_more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/agentzh/headers-more-nginx-module/archive/v${HTTP_HEADERS_MORE_MODULE_PV}.tar.gz"
HTTP_HEADERS_MORE_MODULE_WD="${WORKDIR}/headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, https://github.com/FRiCKLE/ngx_cache_purge, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.3"
HTTP_CACHE_PURGE_MODULE_P="ngx_http_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"
HTTP_CACHE_PURGE_MODULE_URI="http://labs.frickle.com/files/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}.tar.gz"
HTTP_CACHE_PURGE_MODULE_WD="${WORKDIR}/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_http_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="http://labs.frickle.com/files/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}.tar.gz"
HTTP_SLOWFS_CACHE_MODULE_WD="${WORKDIR}/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

# http_fancyindex (https://github.com/aperezdc/ngx-fancyindex, BSD license)
HTTP_FANCYINDEX_MODULE_PV="0.4.1"
HTTP_FANCYINDEX_MODULE_P="ngx_http_fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/aperezdc/ngx-fancyindex/archive/v${HTTP_FANCYINDEX_MODULE_PV}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/ngx-fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"

# http_lua (https://github.com/openresty/lua-nginx-module, BSD license)
HTTP_LUA_MODULE_PV="0.10.6"
HTTP_LUA_MODULE_P="ngx_http_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_URI="https://github.com/openresty/lua-nginx-module/archive/v${HTTP_LUA_MODULE_PV}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/lua-nginx-module-${HTTP_LUA_MODULE_PV}"

# http_auth_pam (https://github.com/stogh/ngx_http_auth_pam_module/, http://web.iti.upv.es/~sto/nginx/, BSD-2 license)
HTTP_AUTH_PAM_MODULE_PV="1.5.1"
HTTP_AUTH_PAM_MODULE_P="ngx_http_auth_pam-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="https://github.com/stogh/ngx_http_auth_pam_module/archive/v${HTTP_AUTH_PAM_MODULE_PV}.tar.gz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module, BSD license)
HTTP_UPSTREAM_CHECK_MODULE_PV="0.3.0-10-gf3bdb7b"
HTTP_UPSTREAM_CHECK_MODULE_P="ngx_http_upstream_check-${HTTP_UPSTREAM_CHECK_MODULE_PV}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/yaoweibin/nginx_upstream_check_module/archive/v${HTTP_UPSTREAM_CHECK_MODULE_PV}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/nginx_upstream_check_module-f3bdb7b85a194e2ad58e3c306c1d021ee76da2f5"

# http_metrics (https://github.com/zenops/ngx_metrics, BSD license)
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="ngx_metrics-${HTTP_METRICS_MODULE_PV}"
HTTP_METRICS_MODULE_URI="https://github.com/madvertise/ngx_metrics/archive/v${HTTP_METRICS_MODULE_PV}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/ngx_metrics-${HTTP_METRICS_MODULE_PV}"

# naxsi-core (https://github.com/nbs-system/naxsi, GPLv2+)
HTTP_NAXSI_MODULE_PV="0.55.1"
HTTP_NAXSI_MODULE_P="ngx_http_naxsi-${HTTP_NAXSI_MODULE_PV}"
HTTP_NAXSI_MODULE_URI="https://github.com/nbs-system/naxsi/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/naxsi-${HTTP_NAXSI_MODULE_PV}/naxsi_src"

# nginx-rtmp-module (https://github.com/arut/nginx-rtmp-module, BSD license)
RTMP_MODULE_PV="1.1.10"
RTMP_MODULE_P="ngx_rtmp-${RTMP_MODULE_PV}"
RTMP_MODULE_URI="https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_PV}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/nginx-rtmp-module-${RTMP_MODULE_PV}"

# nginx-dav-ext-module (https://github.com/arut/nginx-dav-ext-module, BSD license)
HTTP_DAV_EXT_MODULE_PV="0.0.3"
HTTP_DAV_EXT_MODULE_P="ngx_http_dav_ext-${HTTP_DAV_EXT_MODULE_PV}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/arut/nginx-dav-ext-module/archive/v${HTTP_DAV_EXT_MODULE_PV}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/nginx-dav-ext-module-${HTTP_DAV_EXT_MODULE_PV}"

# echo-nginx-module (https://github.com/openresty/echo-nginx-module, BSD license)
HTTP_ECHO_MODULE_PV="0.60"
HTTP_ECHO_MODULE_P="ngx_http_echo-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_URI="https://github.com/openresty/echo-nginx-module/archive/v${HTTP_ECHO_MODULE_PV}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/echo-nginx-module-${HTTP_ECHO_MODULE_PV}"

# mod_security for nginx (https://modsecurity.org/, Apache-2.0)
# keep the MODULE_P here consistent with upstream to avoid tarball duplication
HTTP_SECURITY_MODULE_PV="2.9.1"
HTTP_SECURITY_MODULE_P="modsecurity-${HTTP_SECURITY_MODULE_PV}"
HTTP_SECURITY_MODULE_URI="https://www.modsecurity.org/tarball/${HTTP_SECURITY_MODULE_PV}/${HTTP_SECURITY_MODULE_P}.tar.gz"
HTTP_SECURITY_MODULE_WD="${WORKDIR}/${HTTP_SECURITY_MODULE_P}"

# push-stream-module (http://www.nginxpushstream.com, https://github.com/wandenberg/nginx-push-stream-module, GPL-3)
HTTP_PUSH_STREAM_MODULE_PV="0.5.2"
HTTP_PUSH_STREAM_MODULE_P="ngx_http_push_stream-${HTTP_PUSH_STREAM_MODULE_PV}"
HTTP_PUSH_STREAM_MODULE_URI="https://github.com/wandenberg/nginx-push-stream-module/archive/${HTTP_PUSH_STREAM_MODULE_PV}.tar.gz"
HTTP_PUSH_STREAM_MODULE_WD="${WORKDIR}/nginx-push-stream-module-${HTTP_PUSH_STREAM_MODULE_PV}"

# sticky-module (https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng, BSD-2)
HTTP_STICKY_MODULE_PV="1.2.6-10-g08a395c66e42"
HTTP_STICKY_MODULE_P="nginx_http_sticky_module_ng-${HTTP_STICKY_MODULE_PV}"
HTTP_STICKY_MODULE_URI="https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/${HTTP_STICKY_MODULE_PV}.tar.bz2"
HTTP_STICKY_MODULE_WD="${WORKDIR}/nginx-goodies-nginx-sticky-module-ng-08a395c66e42"

# mogilefs-module (https://github.com/vkholodkov/nginx-mogilefs-module, BSD-2)
HTTP_MOGILEFS_MODULE_PV="1.0.4"
HTTP_MOGILEFS_MODULE_P="ngx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"
HTTP_MOGILEFS_MODULE_URI="https://github.com/vkholodkov/nginx-mogilefs-module/archive/${HTTP_MOGILEFS_MODULE_PV}.tar.gz"
HTTP_MOGILEFS_MODULE_WD="${WORKDIR}/nginx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"

# memc-module (https://github.com/openresty/memc-nginx-module, BSD-2)
HTTP_MEMC_MODULE_PV="0.17"
HTTP_MEMC_MODULE_P="ngx_memc_module-${HTTP_MEMC_MODULE_PV}"
HTTP_MEMC_MODULE_URI="https://github.com/openresty/memc-nginx-module/archive/v${HTTP_MEMC_MODULE_PV}.tar.gz"
HTTP_MEMC_MODULE_WD="${WORKDIR}/memc-nginx-module-${HTTP_MEMC_MODULE_PV}"

# nginx-ldap-auth-module (https://github.com/kvspb/nginx-auth-ldap, BSD-2)
HTTP_LDAP_MODULE_PV="49a8b4d28fc4a518563c82e0b52821e5f37db1fc"
HTTP_LDAP_MODULE_P="nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"
HTTP_LDAP_MODULE_URI="https://github.com/kvspb/nginx-auth-ldap/archive/${HTTP_LDAP_MODULE_PV}.tar.gz"
HTTP_LDAP_MODULE_WD="${WORKDIR}/nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"

# We handle deps below ourselves
SSL_DEPS_SKIP=1

inherit ssl-cert toolchain-funcs perl-module flag-o-matic user systemd versionator multilib

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.org"
SRC_URI="http://nginx.org/download/${P}.tar.gz
	${DEVEL_KIT_MODULE_URI} -> ${DEVEL_KIT_MODULE_P}.tar.gz
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} -> ${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} -> ${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	nginx_modules_http_fancyindex? ( ${HTTP_FANCYINDEX_MODULE_URI} -> ${HTTP_FANCYINDEX_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
	nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
	nginx_modules_http_naxsi? ( ${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz )
	rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
	nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( ${HTTP_ECHO_MODULE_URI} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_security? ( ${HTTP_SECURITY_MODULE_URI} -> ${HTTP_SECURITY_MODULE_P}.tar.gz )
	nginx_modules_http_push_stream? ( ${HTTP_PUSH_STREAM_MODULE_URI} -> ${HTTP_PUSH_STREAM_MODULE_P}.tar.gz )
	nginx_modules_http_sticky? ( ${HTTP_STICKY_MODULE_URI} -> ${HTTP_STICKY_MODULE_P}.tar.bz2 )
	nginx_modules_http_mogilefs? ( ${HTTP_MOGILEFS_MODULE_URI} -> ${HTTP_MOGILEFS_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( ${HTTP_MEMC_MODULE_URI} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_auth_ldap? ( ${HTTP_LDAP_MODULE_URI} -> ${HTTP_LDAP_MODULE_P}.tar.gz )"

LICENSE="BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
	nginx_modules_http_security? ( Apache-2.0 )
	nginx_modules_http_push_stream? ( GPL-3 )"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif
	fastcgi geo gzip limit_req limit_conn map memcached proxy referer
	rewrite scgi ssi split_clients upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition auth_request dav degradation flv geoip gunzip
	gzip_static image_filter mp4 perl random_index realip secure_link
	slice stub_status sub xslt"
NGINX_MODULES_STREAM="access limit_conn upstream"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
	http_upload_progress
	http_headers_more
	http_cache_purge
	http_slowfs_cache
	http_fancyindex
	http_lua
	http_auth_pam
	http_upstream_check
	http_metrics
	http_naxsi
	http_dav_ext
	http_echo
	http_security
	http_push_stream
	http_sticky
	http_mogilefs
	http_memc
	http_auth_ldap"

IUSE="aio debug +http +http2 +http-cache ipv6 libatomic libressl luajit +pcre
	pcre-jit rtmp selinux ssl threads userland_GNU vim-syntax"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_STREAM; do
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

CDEPEND="
	pcre? ( dev-libs/libpcre:= )
	pcre-jit? ( dev-libs/libpcre:=[jit] )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	http2? (
		!libressl? ( >=dev-libs/openssl-1.0.1c:0= )
		libressl? ( dev-libs/libressl:= )
	)
	http-cache? (
		userland_GNU? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd:=[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8:= )
	nginx_modules_http_rewrite? ( dev-libs/libpcre:= )
	nginx_modules_http_secure_link? (
		userland_GNU? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	nginx_modules_http_xslt? ( dev-libs/libxml2:= dev-libs/libxslt )
	nginx_modules_http_lua? ( !luajit? ( dev-lang/lua:0= ) luajit? ( dev-lang/luajit:2= ) )
	nginx_modules_http_auth_pam? ( virtual/pam )
	nginx_modules_http_metrics? ( dev-libs/yajl:= )
	nginx_modules_http_dav_ext? ( dev-libs/expat )
	nginx_modules_http_security? (
		dev-libs/apr:=
		dev-libs/apr-util:=
		dev-libs/libxml2:=
		net-misc/curl
		www-servers/apache
	)
	nginx_modules_http_auth_ldap? ( net-nds/openldap[ssl?] )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-nginx )
	!www-servers/nginx:mainline"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

REQUIRED_USE="pcre-jit? ( pcre )
	nginx_modules_http_lua? ( nginx_modules_http_rewrite )
	nginx_modules_http_naxsi? ( pcre )
	nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
	nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
	nginx_modules_http_security? ( pcre )
	nginx_modules_http_push_stream? ( ssl )"

pkg_setup() {
	NGINX_HOME="/var/lib/nginx"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "${NGINX_HOME}" ${PN}
	eend $?

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
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi

	if use nginx_modules_http_mogilefs && use threads; then
		eerror "mogilefs won't compile with threads support."
		eerror "Please disable either flag and try again."
		die "Can't compile mogilefs with threads support"
	fi
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.4.1-fix-perl-install-path.patch"
	eapply "${FILESDIR}/${PN}-httpoxy-mitigation-r1.patch"

	if use nginx_modules_http_upstream_check; then
		eapply -p0 "${HTTP_UPSTREAM_CHECK_MODULE_WD}/check_1.9.2+".patch
	fi

	if use nginx_modules_http_lua; then
		sed -i -e 's/-llua5.1/-llua/' "${HTTP_LUA_MODULE_WD}/config" || die
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
	# mod_security needs to generate nginx/modsecurity/config before including it
	if use nginx_modules_http_security; then
		cd "${HTTP_SECURITY_MODULE_WD}" || die
		if use luajit ; then
			sed -i \
				-e 's|^\(LUA_PKGNAMES\)=.*|\1="luajit"|' \
				configure || die
		fi
		./configure \
			--enable-standalone-module \
			--disable-mlogc \
			--with-ssdeep=no \
			$(use_enable pcre-jit) \
			$(use_with nginx_modules_http_lua lua) || die "configure failed for mod_security"
	fi

	cd "${S}" || die

	local myconf=() http_enabled= mail_enabled= stream_enabled=

	use aio       && myconf+=( --with-file-aio )
	use debug     && myconf+=( --with-debug )
	use http2     && myconf+=( --with-http_v2_module )
	use ipv6      && myconf+=( --with-ipv6 )
	use libatomic && myconf+=( --with-libatomic )
	use pcre      && myconf+=( --with-pcre )
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
		if use luajit; then
			export LUAJIT_LIB=$(pkg-config --variable libdir luajit)
			export LUAJIT_INC=$(pkg-config --variable includedir luajit)
		else
			export LUA_LIB=$(pkg-config --variable libdir lua)
			export LUA_INC=$(pkg-config --variable includedir lua)
		fi
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
		myconf+=( --add-module=${HTTP_SECURITY_MODULE_WD}/nginx/modsecurity )
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

	if use http || use http-cache || use http2; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=( --without-http-cache )
		use ssl && myconf+=( --with-http_ssl_module )
	else
		myconf+=( --without-http --without-http-cache )
	fi

	# Stream modules
	for mod in $NGINX_MODULES_STREAM; do
		if use nginx_modules_stream_${mod}; then
			stream_enabled=1
		else
			# Treat stream upstream slightly differently
			if ! use nginx_modules_stream_upstream; then
				myconf+=( --without-stream_upstream_hash_module )
				myconf+=( --without-stream_upstream_least_conn_module )
				myconf+=( --without-stream_upstream_zone_module )
			else
				myconf+=( --without-stream_${mod}_module )
			fi
		fi
	done

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
	tc-export CC

	if ! use prefix; then
		myconf+=( --user=${PN} )
		myconf+=( --group=${PN} )
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error_log \
		--pid-path="${EPREFIX}"/run/${PN}.pid \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}"/var/log/${PN}/access_log \
		--http-client-body-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/client \
		--http-proxy-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/proxy \
		--http-fastcgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/fastcgi \
		--http-scgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/scgi \
		--http-uwsgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/uwsgi \
		"${myconf[@]}" || die "configure failed"

	# A purely cosmetic change that makes nginx -V more readable. This can be
	# good if people outside the gentoo community would troubleshoot and
	# question the users setup.
	sed -i -e "s|${WORKDIR}|external_module|g" objs/ngx_auto_config.h || die
}

src_compile() {
	use nginx_modules_http_security && emake -C "${HTTP_SECURITY_MODULE_WD}"

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D%/}" install

	cp "${FILESDIR}"/nginx.conf-r2 "${ED}"etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd-r3 nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	doman man/nginx.8
	dodoc CHANGES* README

	# just keepdir. do not copy the default htdocs files (bug #449136)
	keepdir /var/www/localhost
	rm -rf "${D}"usr/html || die

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

	fperms 0700 /var/log/nginx ${keepdir_list}
	fowners ${PN}:${PN} /var/log/nginx ${keepdir_list}

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate-r1 nginx

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
		insinto /etc/nginx
		doins "${HTTP_NAXSI_MODULE_WD}"/../naxsi_config/naxsi_core.rules
	fi

	if use rtmp; then
		docinto ${RTMP_MODULE_P}
		dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
	fi

	if use nginx_modules_http_dav_ext; then
		docinto ${HTTP_DAV_EXT_MODULE_P}
		dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README
	fi

	if use nginx_modules_http_echo; then
		docinto ${HTTP_ECHO_MODULE_P}
		dodoc "${HTTP_ECHO_MODULE_WD}"/README.markdown
	fi

	if use nginx_modules_http_security; then
		docinto ${HTTP_SECURITY_MODULE_P}
		dodoc "${HTTP_SECURITY_MODULE_WD}"/{CHANGES,README.TXT,authors.txt}
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
		if [[ ! -f "${EROOT}"etc/ssl/${PN}/${PN}.key ]]; then
			install_cert /etc/ssl/${PN}/${PN}
			use prefix || chown ${PN}:${PN} "${EROOT}"etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	fi

	if use nginx_modules_http_spdy; then
		ewarn "In nginx 1.9.5 the spdy module was superseded by http2."
		ewarn "Update your configs and package.use accordingly."
	fi

	if use nginx_modules_http_lua && use http2; then
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua http2\". For more info, see http://git.io/OldLsg"
	fi

	# This is the proper fix for bug #458726/#469094, resp. CVE-2013-0337 for
	# existing installations
	local fix_perms=0

	for rv in ${REPLACING_VERSIONS}; do
		version_compare ${rv} 1.4.1-r2
		[[ $? -eq 1 ]] && fix_perms=1
	done

	if [[ $fix_perms -eq 1 ]] ; then
		ewarn "To fix a security bug (CVE-2013-0337, bug #458726) had the following"
		ewarn "directories the world-readable bit removed (if set):"
		ewarn "  ${EPREFIX}/var/log/nginx"
		ewarn "  ${EPREFIX}${NGINX_HOME_TMP}/{,client,proxy,fastcgi,scgi,uwsgi}"
		ewarn "Check if this is correct for your setup before restarting nginx!"
		ewarn "This is a one-time change and will not happen on subsequent updates."
		ewarn "Furthermore nginx' temp directories got moved to ${NGINX_HOME_TMP}"
		chmod -f o-rwx "${EPREFIX}"/var/log/nginx "${EPREFIX}${NGINX_HOME_TMP}"/{,client,proxy,fastcgi,scgi,uwsgi}
	fi

	# If the nginx user can't change into or read the dir, display a warning.
	# If su is not available we display the warning nevertheless since we can't check properly
	su -s /bin/sh -c 'cd /var/log/nginx/ && ls' nginx >&/dev/null
	if [ $? -ne 0 ] ; then
		ewarn "Please make sure that the nginx user or group has at least"
		ewarn "'rx' permissions on /var/log/nginx (default on a fresh install)"
		ewarn "Otherwise you end up with empty log files after a logrotate."
	fi

	# HTTPoxy mitigation
	ewarn ""
	ewarn "This nginx installation comes with a mitigation for the HTTPoxy"
	ewarn "vulnerability for FastCGI applications by setting the HTTP_PROXY FastCGI"
	ewarn "parameter to an empty string per default when you are sourcing the default"
	ewarn "'fastcgi_params' or 'fastcgi.conf' in your server block(s)."
	ewarn ""
	ewarn "If this is causing any problems for you make sure that you are sourcing the"
	ewarn "default parameters _before_ you set your own values."
	ewarn "If you are relying on user-supplied proxy values you have to remove the"
	ewarn "correlating lines from 'fastcgi_params' and or 'fastcgi.conf'."
}
