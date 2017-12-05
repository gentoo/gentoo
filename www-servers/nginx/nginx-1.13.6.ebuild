# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

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
HTTP_HEADERS_MORE_MODULE_PV="0.32"
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
HTTP_FANCYINDEX_MODULE_PV="0.4.2"
HTTP_FANCYINDEX_MODULE_P="ngx_http_fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/aperezdc/ngx-fancyindex/archive/v${HTTP_FANCYINDEX_MODULE_PV}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/ngx-fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"

# http_lua (https://github.com/openresty/lua-nginx-module, BSD license)
HTTP_LUA_MODULE_PV="0.10.10"
HTTP_LUA_MODULE_P="ngx_http_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_URI="https://github.com/openresty/lua-nginx-module/archive/v${HTTP_LUA_MODULE_PV}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/lua-nginx-module-${HTTP_LUA_MODULE_PV}"

# http_auth_pam (https://github.com/stogh/ngx_http_auth_pam_module/, http://web.iti.upv.es/~sto/nginx/, BSD-2 license)
HTTP_AUTH_PAM_MODULE_PV="1.5.1"
HTTP_AUTH_PAM_MODULE_P="ngx_http_auth_pam-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="https://github.com/stogh/ngx_http_auth_pam_module/archive/v${HTTP_AUTH_PAM_MODULE_PV}.tar.gz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module, BSD license)
HTTP_UPSTREAM_CHECK_MODULE_PV="31b1b42873fa56620d8a873ac13f5f26b52d0cd6"
HTTP_UPSTREAM_CHECK_MODULE_P="ngx_http_upstream_check-${HTTP_UPSTREAM_CHECK_MODULE_PV}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/yaoweibin/nginx_upstream_check_module/archive/${HTTP_UPSTREAM_CHECK_MODULE_PV}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/nginx_upstream_check_module-${HTTP_UPSTREAM_CHECK_MODULE_PV}"

# http_metrics (https://github.com/zenops/ngx_metrics, BSD license)
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="ngx_metrics-${HTTP_METRICS_MODULE_PV}"
HTTP_METRICS_MODULE_URI="https://github.com/madvertise/ngx_metrics/archive/v${HTTP_METRICS_MODULE_PV}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/ngx_metrics-${HTTP_METRICS_MODULE_PV}"

# naxsi-core (https://github.com/nbs-system/naxsi, GPLv2+)
HTTP_NAXSI_MODULE_PV="0.55.3"
HTTP_NAXSI_MODULE_P="ngx_http_naxsi-${HTTP_NAXSI_MODULE_PV}"
HTTP_NAXSI_MODULE_URI="https://github.com/nbs-system/naxsi/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/naxsi-${HTTP_NAXSI_MODULE_PV}/naxsi_src"

# nginx-rtmp-module (https://github.com/arut/nginx-rtmp-module, BSD license)
RTMP_MODULE_PV="1.2.0"
RTMP_MODULE_P="ngx_rtmp-${RTMP_MODULE_PV}"
RTMP_MODULE_URI="https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_PV}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/nginx-rtmp-module-${RTMP_MODULE_PV}"

# nginx-dav-ext-module (https://github.com/arut/nginx-dav-ext-module, BSD license)
HTTP_DAV_EXT_MODULE_PV="0.1.0"
HTTP_DAV_EXT_MODULE_P="ngx_http_dav_ext-${HTTP_DAV_EXT_MODULE_PV}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/arut/nginx-dav-ext-module/archive/v${HTTP_DAV_EXT_MODULE_PV}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/nginx-dav-ext-module-${HTTP_DAV_EXT_MODULE_PV}"

# echo-nginx-module (https://github.com/openresty/echo-nginx-module, BSD license)
HTTP_ECHO_MODULE_PV="0.61"
HTTP_ECHO_MODULE_P="ngx_http_echo-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_URI="https://github.com/openresty/echo-nginx-module/archive/v${HTTP_ECHO_MODULE_PV}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/echo-nginx-module-${HTTP_ECHO_MODULE_PV}"

# mod_security for nginx (https://modsecurity.org/, Apache-2.0)
# keep the MODULE_P here consistent with upstream to avoid tarball duplication
HTTP_SECURITY_MODULE_PV="2.9.2"
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
HTTP_MEMC_MODULE_PV="0.18"
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
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools ssl-cert toolchain-funcs perl-module flag-o-matic user systemd versionator multilib

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="https://nginx.org"
SRC_URI="https://nginx.org/download/${P}.tar.gz
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

SLOT="mainline"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

# Package doesn't provide a real test suite
RESTRICT="test"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif
	fastcgi geo gzip limit_req limit_conn map memcached mirror proxy
	referer rewrite scgi ssi split_clients upstream_hash
	upstream_ip_hash upstream_keepalive upstream_least_conn
	upstream_zone userid uwsgi"
NGINX_MODULES_OPT="addition auth_request dav degradation flv geoip gunzip
	gzip_static image_filter mp4 perl random_index realip secure_link
	slice stub_status sub xslt"
NGINX_MODULES_STREAM_STD="access geo limit_conn map return split_clients
	upstream_hash upstream_least_conn upstream_zone"
NGINX_MODULES_STREAM_OPT="geoip realip ssl_preread"
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

IUSE="aio debug +http +http2 +http-cache +ipv6 libatomic libressl luajit +pcre
	pcre-jit rtmp selinux ssl threads userland_GNU vim-syntax"

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
	!www-servers/nginx:0"
DEPEND="${CDEPEND}
	nginx_modules_http_security? ( ${AUTOTOOLS_DEPEND} )
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
		#eapply -p0 "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/check_1.11.1+.patch
		eapply -p0 "${FILESDIR}"/http_upstream_check-nginx-1.11.5+.patch
	fi

	if use nginx_modules_http_security; then
		cd "${HTTP_SECURITY_MODULE_WD}" || die

		eautoreconf

		if use luajit ; then
			sed -i \
				-e 's|^\(LUA_PKGNAMES\)=.*|\1="luajit"|' \
				configure || die
		fi

		cd "${S}" || die
	fi

	if use nginx_modules_http_upload_progress; then
		cd "${HTTP_UPLOAD_PROGRESS_MODULE_WD}" || die
		eapply "${FILESDIR}"/http_uploadprogress-issue_50-r1.patch
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
	# mod_security needs to generate nginx/modsecurity/config before including it
	if use nginx_modules_http_security; then
		cd "${HTTP_SECURITY_MODULE_WD}" || die

		./configure \
			--enable-standalone-module \
			--disable-mlogc \
			--with-ssdeep=no \
			$(use_enable pcre-jit) \
			$(use_with nginx_modules_http_lua lua) || die "configure failed for mod_security"

		cd "${S}" || die
	fi

	local myconf=() http_enabled= mail_enabled= stream_enabled=

	use aio       && myconf+=( --with-file-aio )
	use debug     && myconf+=( --with-debug )
	use http2     && myconf+=( --with-http_v2_module )
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

	local WITHOUT_IPV6=
	if ! use ipv6; then
		WITHOUT_IPV6=" -DNGX_HAVE_INET6=0"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error_log \
		--pid-path="${EPREFIX}"/run/${PN}.pid \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--with-cc-opt="-I${EROOT}usr/include${WITHOUT_IPV6}" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
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
	use nginx_modules_http_security && emake -C "${HTTP_SECURITY_MODULE_WD}"

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D%/}" install

	cp "${FILESDIR}"/nginx.conf-r2 "${ED}"etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd-r4 nginx
	newconfd "${FILESDIR}"/nginx.confd nginx

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

	fperms 0700 ${keepdir_list}
	fowners ${PN}:${PN} ${keepdir_list}

	fperms 0710 /var/log/nginx
	fowners 0:${PN} /var/log/nginx

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
		dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README.rst
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
		ewarn ""
		ewarn "In nginx 1.9.5 the spdy module was superseded by http2."
		ewarn "Update your configs and package.use accordingly."
	fi

	if use nginx_modules_http_lua; then
		ewarn ""
		ewarn "While you can build lua 3rd party module against ${P}"
		ewarn "the author warns that >=${PN}-1.11.11 is still not an"
		ewarn "officially supported target yet. You are on your own."
		ewarn "Expect runtime failures, memory leaks and other problems!"
	fi

	if use nginx_modules_http_lua && use http2; then
		ewarn ""
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua http2\". For more info, see http://git.io/OldLsg"
	fi

	local _n_permission_layout_checks=0
	local _has_to_adjust_permissions=0
	local _has_to_show_permission_warning=0

	# Defaults to 1 to inform people doing a fresh installation
	# that we ship modified {scgi,uwsgi,fastcgi}_params files
	local _has_to_show_httpoxy_mitigation_notice=1

	local _replacing_version=
	for _replacing_version in ${REPLACING_VERSIONS}; do
		_n_permission_layout_checks=$((${_n_permission_layout_checks}+1))

		if [[ ${_n_permission_layout_checks} -gt 1 ]]; then
			# Should never happen:
			# Package is abusing slots but doesn't allow multiple parallel installations.
			# If we run into this situation it is unsafe to automatically adjust any
			# permission...
			_has_to_show_permission_warning=1

			ewarn "Replacing multiple ${PN}' versions is unsupported! " \
				"You will have to adjust permissions on your own."

			break
		fi

		local _replacing_version_branch=$(get_version_component_range 1-2 "${_replacing_version}")
		debug-print "Updating an existing installation (v${_replacing_version}; branch '${_replacing_version_branch}') ..."

		# Do we need to adjust permissions to fix CVE-2013-0337 (bug #458726, #469094)?
		# This was before we introduced multiple nginx versions so we
		# do not need to distinguish between stable and mainline
		local _need_to_fix_CVE2013_0337=1

		if version_is_at_least "1.4.1-r2" "${_replacing_version}"; then
			# We are updating an installation which should already be fixed
			_need_to_fix_CVE2013_0337=0
			debug-print "Skipping CVE-2013-0337 ... existing installation should not be affected!"
		else
			_has_to_adjust_permissions=1
			debug-print "Need to adjust permissions to fix CVE-2013-0337!"
		fi

		# Do we need to inform about HTTPoxy mitigation?
		# In repository since commit 8be44f76d4ac02cebcd1e0e6e6284bb72d054b0f
		if ! version_is_at_least "1.10" "${_replacing_version_branch}"; then
			# Updating from <1.10
			_has_to_show_httpoxy_mitigation_notice=1
			debug-print "Need to inform about HTTPoxy mitigation!"
		else
			# Updating from >=1.10
			local _fixed_in_pvr=
			case "${_replacing_version_branch}" in
				"1.10")
					_fixed_in_pvr="1.10.1-r2"
					;;
				"1.11")
					_fixed_in_pvr="1.11.3-r1"
					;;
				*)
					# This should be any future branch.
					# If we run this code it is safe to assume that the user has
					# already seen the HTTPoxy mitigation notice because he/she is doing
					# an update from previous version where we have already shown
					# the warning. Otherwise, we wouldn't hit this code path ...
					_fixed_in_pvr=
			esac

			if [[ -z "${_fixed_in_pvr}" ]] || version_is_at_least "${_fixed_in_pvr}" "${_replacing_version}"; then
				# We are updating an installation where we already informed
				# that we are mitigating HTTPoxy per default
				_has_to_show_httpoxy_mitigation_notice=0
				debug-print "No need to inform about HTTPoxy mitigation ... information was already shown for existing installation!"
			else
				_has_to_show_httpoxy_mitigation_notice=1
				debug-print "Need to inform about HTTPoxy mitigation!"
			fi
		fi

		# Do we need to adjust permissions to fix CVE-2016-1247 (bug #605008)?
		# All branches up to 1.11 are affected
		local _need_to_fix_CVE2016_1247=1

		if ! version_is_at_least "1.10" "${_replacing_version_branch}"; then
			# Updating from <1.10
			_has_to_adjust_permissions=1
			debug-print "Need to adjust permissions to fix CVE-2016-1247!"
		else
			# Updating from >=1.10
			local _fixed_in_pvr=
			case "${_replacing_version_branch}" in
				"1.10")
					_fixed_in_pvr="1.10.2-r3"
					;;
				"1.11")
					_fixed_in_pvr="1.11.6-r1"
					;;
				*)
					# This should be any future branch.
					# If we run this code it is safe to assume that we have already
					# adjusted permissions or were never affected because user is
					# doing an update from previous version which was safe or did
					# the adjustments. Otherwise, we wouldn't hit this code path ...
					_fixed_in_pvr=
			esac

			if [[ -z "${_fixed_in_pvr}" ]] || version_is_at_least "${_fixed_in_pvr}" "${_replacing_version}"; then
				# We are updating an installation which should already be adjusted
				# or which was never affected
				_need_to_fix_CVE2016_1247=0
				debug-print "Skipping CVE-2016-1247 ... existing installation should not be affected!"
			else
				_has_to_adjust_permissions=1
				debug-print "Need to adjust permissions to fix CVE-2016-1247!"
			fi
		fi
	done

	if [[ ${_has_to_adjust_permissions} -eq 1 ]]; then
		# We do not DIE when chmod/chown commands are failing because
		# package is already merged on user's system at this stage
		# and we cannot retry without losing the information that
		# the existing installation needs to adjust permissions.
		# Instead we are going to a show a big warning ...

		if [[ ${_has_to_show_permission_warning} -eq 0 ]] && [[ ${_need_to_fix_CVE2013_0337} -eq 1 ]]; then
			ewarn ""
			ewarn "The world-readable bit (if set) has been removed from the"
			ewarn "following directories to mitigate a security bug"
			ewarn "(CVE-2013-0337, bug #458726):"
			ewarn ""
			ewarn "  ${EPREFIX%/}/var/log/nginx"
			ewarn "  ${EPREFIX%/}${NGINX_HOME_TMP}/{,client,proxy,fastcgi,scgi,uwsgi}"
			ewarn ""
			ewarn "Check if this is correct for your setup before restarting nginx!"
			ewarn "This is a one-time change and will not happen on subsequent updates."
			ewarn "Furthermore nginx' temp directories got moved to '${EPREFIX%/}${NGINX_HOME_TMP}'"
			chmod o-rwx \
				"${EPREFIX%/}"/var/log/nginx \
				"${EPREFIX%/}"${NGINX_HOME_TMP}/{,client,proxy,fastcgi,scgi,uwsgi} || \
				_has_to_show_permission_warning=1
		fi

		if [[ ${_has_to_show_permission_warning} -eq 0 ]] && [[ ${_need_to_fix_CVE2016_1247} -eq 1 ]]; then
			ewarn ""
			ewarn "The permissions on the following directory have been reset in"
			ewarn "order to mitigate a security bug (CVE-2016-1247, bug #605008):"
			ewarn ""
			ewarn "  ${EPREFIX%/}/var/log/nginx"
			ewarn ""
			ewarn "Check if this is correct for your setup before restarting nginx!"
			ewarn "Also ensure that no other log directory used by any of your"
			ewarn "vhost(s) is not writeable for nginx user. Any of your log files"
			ewarn "used by nginx can be abused to escalate privileges!"
			ewarn "This is a one-time change and will not happen on subsequent updates."
			chown 0:nginx "${EPREFIX%/}"/var/log/nginx || _has_to_show_permission_warning=1
			chmod 710 "${EPREFIX%/}"/var/log/nginx || _has_to_show_permission_warning=1
		fi

		if [[ ${_has_to_show_permission_warning} -eq 1 ]]; then
			# Should never happen ...
			ewarn ""
			ewarn "*************************************************************"
			ewarn "***************         W A R N I N G         ***************"
			ewarn "*************************************************************"
			ewarn "The one-time only attempt to adjust permissions of the"
			ewarn "existing nginx installation failed. Be aware that we will not"
			ewarn "try to adjust the same permissions again because now you are"
			ewarn "using a nginx version where we expect that the permissions"
			ewarn "are already adjusted or that you know what you are doing and"
			ewarn "want to keep custom permissions."
			ewarn ""
		fi
	fi

	# Sanity check for CVE-2016-1247
	# Required to warn users who received the warning above and thought
	# they could fix it by unmerging and re-merging the package or have
	# unmerged a affected installation on purpose in the past leaving
	# /var/log/nginx on their system due to keepdir/non-empty folder
	# and are now installing the package again.
	local _sanity_check_testfile=$(mktemp --dry-run "${EPREFIX%/}"/var/log/nginx/.CVE-2016-1247.XXXXXXXXX)
	su -s /bin/sh -c "touch ${_sanity_check_testfile}" nginx >&/dev/null
	if [ $? -eq 0 ] ; then
		# Cleanup -- no reason to die here!
		rm -f "${_sanity_check_testfile}"

		ewarn ""
		ewarn "*************************************************************"
		ewarn "***************         W A R N I N G         ***************"
		ewarn "*************************************************************"
		ewarn "Looks like your installation is vulnerable to CVE-2016-1247"
		ewarn "(bug #605008) because nginx user is able to create files in"
		ewarn ""
		ewarn "  ${EPREFIX%/}/var/log/nginx"
		ewarn ""
		ewarn "Also ensure that no other log directory used by any of your"
		ewarn "vhost(s) is not writeable for nginx user. Any of your log files"
		ewarn "used by nginx can be abused to escalate privileges!"
	fi

	if [[ ${_has_to_show_httpoxy_mitigation_notice} -eq 1 ]]; then
		# HTTPoxy mitigation
		ewarn ""
		ewarn "This nginx installation comes with a mitigation for the HTTPoxy"
		ewarn "vulnerability for FastCGI, SCGI and uWSGI applications by setting"
		ewarn "the HTTP_PROXY parameter to an empty string per default when you"
		ewarn "are sourcing one of the default"
		ewarn ""
		ewarn "  - 'fastcgi_params' or 'fastcgi.conf'"
		ewarn "  - 'scgi_params'"
		ewarn "  - 'uwsgi_params'"
		ewarn ""
		ewarn "files in your server block(s)."
		ewarn ""
		ewarn "If this is causing any problems for you make sure that you are sourcing the"
		ewarn "default parameters _before_ you set your own values."
		ewarn "If you are relying on user-supplied proxy values you have to remove the"
		ewarn "correlating lines from the file(s) mentioned above."
		ewarn ""
	fi
}
