# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Check the upstream uwsgi-2.0 branch, not master, for backports

LUA_COMPAT=( lua5-1 )
PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="threads(+)"

RUBY_OPTIONAL="yes"
USE_RUBY="ruby31 ruby32"

PHP_EXT_INI="no"
PHP_EXT_NAME="dummy"
PHP_EXT_OPTIONAL_USE="php"
USE_PHP="php8-1 php8-2" # deps must be registered separately below

POSTGRES_COMPAT=( 13 14 15 16 )

MY_P="${P/_/-}"

inherit flag-o-matic lua-single multiprocessing pax-utils php-ext-source-r3
inherit postgres python-r1 ruby-ng

DESCRIPTION="uWSGI server for Python web applications"
HOMEPAGE="https://uwsgi-docs.readthedocs.io/en/latest/"
SRC_URI="https://github.com/unbit/uwsgi/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 x86 ~amd64-linux"

UWSGI_PLUGINS_STD=(
	ping cache carbon nagios rpc rrdtool
	http ugreen signal syslog rsyslog
	router_{uwsgi,redirect,basicauth,rewrite,http,cache,static,memcached,redis,hash,expires,metrics}
	{core,fast,raw,ssl}router
	redislog mongodblog log{file,socket}
	spooler cheaper_busyness symcall
	transformation_{chunked,gzip,offload,tofile}
	zergpool
)
UWSGI_PLUGINS_OPT=(
	alarm_{curl,xmpp} clock_{monotonic,realtime} curl_cron
	dumbloop echo emperor_{amqp,pg,zeromq} forkptyrouter
	geoip graylog2 legion_cache_fetch ldap log{crypto,pipe} notfound pam
	rados router_{access,radius,spnego,xmldir}
	sqlite ssi stats_pusher_statsd
	systemd_logger transformation_toupper tuntap webdav xattr xslt zabbix
)

LANG_SUPPORT_SIMPLE=( cgi mono perl ) # plugins which can be built in the main build process
LANG_SUPPORT_EXTENDED=( go lua php python ruby )

# plugins to be ignored (for now):
# cheaper_backlog2: example plugin
# coroae: TODO
# cplusplus: partially example code, needs explicit class
# dummy: no idea
# example: example plugin
# exception_log: example plugin
# *java*: TODO
# v8: TODO
# matheval: TODO
IUSE="apache2 +caps debug +embedded expat jemalloc json +pcre +routing selinux +ssl +xml yajl yaml zeromq"

for plugin in ${UWSGI_PLUGINS_STD[@]}; do IUSE="${IUSE} +uwsgi_plugins_${plugin}"; done
for plugin in ${UWSGI_PLUGINS_OPT[@]}; do IUSE="${IUSE} uwsgi_plugins_${plugin}"; done
IUSE="${IUSE} ${LANG_SUPPORT_SIMPLE[@]} ${LANG_SUPPORT_EXTENDED[@]}"

REQUIRED_USE="
	|| ( ${LANG_SUPPORT_SIMPLE[@]} ${LANG_SUPPORT_EXTENDED[@]} )
	uwsgi_plugins_logcrypto? ( ssl )
	uwsgi_plugins_sslrouter? ( ssl )
	routing? ( pcre )
	uwsgi_plugins_emperor_pg? ( ${POSTGRES_REQ_USE} )
	uwsgi_plugins_emperor_zeromq? ( zeromq )
	uwsgi_plugins_forkptyrouter? ( uwsgi_plugins_corerouter )
	uwsgi_plugins_router_xmldir? ( xml !expat )
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
	expat? ( xml )
"

# Dependency notes:
# - util-linux is required for libuuid when requesting zeromq support
# - sys-devel/gcc[go] is needed for libgo.so
#
# Order:
# 1. Unconditional
# 2. General features
# 3. Plugins
# 4. Language/app support
CDEPEND="
	sys-libs/zlib
	virtual/libcrypt:=
	caps? ( sys-libs/libcap )
	json? (
		!yajl? ( dev-libs/jansson:= )
		yajl? ( dev-libs/yajl )
	)
	pcre? ( dev-libs/libpcre2 )
	ssl? ( dev-libs/openssl:= )
	xml? (
		!expat? ( dev-libs/libxml2 )
		expat? ( dev-libs/expat )
	)
	yaml? ( dev-libs/libyaml )
	zeromq? (
		net-libs/zeromq
		sys-apps/util-linux
	)
	uwsgi_plugins_alarm_curl? ( net-misc/curl )
	uwsgi_plugins_alarm_xmpp? ( net-libs/gloox )
	uwsgi_plugins_curl_cron? ( net-misc/curl )
	uwsgi_plugins_emperor_pg? ( ${POSTGRES_DEP} )
	uwsgi_plugins_geoip? ( dev-libs/geoip )
	uwsgi_plugins_ldap? ( net-nds/openldap:= )
	uwsgi_plugins_pam? ( sys-libs/pam )
	uwsgi_plugins_sqlite? ( dev-db/sqlite:3 )
	uwsgi_plugins_rados? ( sys-cluster/ceph )
	uwsgi_plugins_router_access? ( sys-apps/tcp-wrappers )
	uwsgi_plugins_router_spnego? ( virtual/krb5 )
	uwsgi_plugins_systemd_logger? ( sys-apps/systemd )
	uwsgi_plugins_webdav? ( dev-libs/libxml2 )
	uwsgi_plugins_xslt? ( dev-libs/libxslt )
	go? ( sys-devel/gcc:=[go] )
	lua? ( ${LUA_DEPS} )
	mono? ( dev-lang/mono:= )
	perl? ( dev-lang/perl:= )
	php? (
		php_targets_php8-1? ( dev-lang/php:8.1[embed] )
		php_targets_php8-2? ( dev-lang/php:8.2[embed] )
	)
	python? ( ${PYTHON_DEPS} )
	ruby? ( $(ruby_implementations_depend) )
"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	selinux? ( sec-policy/selinux-uwsgi )
	uwsgi_plugins_rrdtool? ( net-analyzer/rrdtool )
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	python_setup
	use lua && lua-single_pkg_setup
	use ruby && ruby-ng_pkg_setup
	use uwsgi_plugins_emperor_pg && postgres_pkg_setup
}

src_unpack() {
	default
}

src_prepare() {
	default

	sed -i \
		-e "s|'-O2', ||" \
		-e "s|'-Werror', ||" \
		-e "s|uc.get('plugin_dir')|uc.get('plugin_build_dir')|" \
		uwsgiconfig.py || die "sed failed"

	sed -i \
		-e "s|/lib|/$(get_libdir)|" \
		plugins/php/uwsgiplugin.py || die "sed failed"
}

src_configure() {
	local embedded_plugins=()
	local plugins=()
	local malloc_impl="libc"
	local json="false"
	local xml="false"

	local p
	for p in ${UWSGI_PLUGINS_STD[@]} ${UWSGI_PLUGINS_OPT[@]} ; do
		use uwsgi_plugins_${p} && embedded_plugins+=("${p}")
	done
	for p in ${LANG_SUPPORT_SIMPLE[@]} ; do
		use ${p} && plugins+=("${p}")
	done

	# do not embed any plugins
	if ! use embedded; then
		plugins=( ${plugins[@]} ${embedded_plugins[@]} )
		embedded_plugins=()
	fi

	# flatten the arrays
	plugins=${plugins[@]}
	embedded_plugins=${embedded_plugins[@]}

	# rename some of the use flags, language plugins are always real plugins
	plugins="${plugins/perl/psgi}"
	plugins="${plugins/sqlite/sqlite3}"
	embedded_plugins="${embedded_plugins/sqlite/sqlite3}"

	# override defaults as requested by the user
	if use xml; then
		use expat && xml="expat" || xml="libxml2"
	fi
	if use json; then
		use yajl && json="yajl" || json="jansson"
	fi
	use jemalloc && malloc_impl="jemalloc"

	# Incompatible w/ C23 prototypes
	append-cflags -std=gnu17

	# prepare the buildconf for gentoo
	cp "${FILESDIR}"/gentoo.buildconf buildconf/gentoo.ini || die
	sed -i \
		-e "s|VAR_XML|${xml}|" \
		-e "s|VAR_YAML|$(usex yaml libyaml true)|" \
		-e "s|VAR_JSON|${json}|" \
		-e "s|VAR_SSL|$(usex ssl true false)|" \
		-e "s|VAR_PCRE|$(usex pcre true false)|" \
		-e "s|VAR_PCRE2|$(usex pcre true false)|" \
		-e "s|VAR_ZMQ|$(usex zeromq true false)|" \
		-e "s|VAR_ROUTING|$(usex routing true false)|" \
		-e "s|VAR_DEBUG|$(usex debug true false)|" \
		-e "s|VAR_MALLOC|${malloc_impl}|" \
		-e "s|VAR_PLUGINS|${plugins// /, }|" \
		-e "s|VAR_PLUGIN_DIR|${EPREFIX}/usr/$(get_libdir)/uwsgi|" \
		-e "s|VAR_BUILD_DIR|${T}/plugins|" \
		-e "s|VAR_EMBEDDED|${embedded_plugins// /, }|" \
		buildconf/gentoo.ini || die "sed failed"

	if ! use caps; then
		sed -i -e 's|sys/capability.h|DISABLED|' uwsgiconfig.py || die "sed failed"
	fi

	if ! use zeromq; then
		sed -i -e 's|uuid/uuid.h|DISABLED|' uwsgiconfig.py || die "sed failed"
	fi

	if use uwsgi_plugins_emperor_pg ; then
		sed -i \
			-e "s|pg_config|${PG_CONFIG}|" \
			plugins/emperor_pg/uwsgiplugin.py || die "sed failed"
	fi
}

each_ruby_compile() {
	cd "${WORKDIR}/${MY_P}" || die "sed failed"

	UWSGICONFIG_RUBYPATH="${RUBY}" ${EPYTHON} uwsgiconfig.py --plugin plugins/rack gentoo rack_${RUBY##*/} || die "building plugin for ${RUBY} failed"
	UWSGICONFIG_RUBYPATH="${RUBY}" ${EPYTHON} uwsgiconfig.py --plugin plugins/fiber gentoo fiber_${RUBY##*/}|| die "building fiber plugin for ${RUBY} failed"
	UWSGICONFIG_RUBYPATH="${RUBY}" ${EPYTHON} uwsgiconfig.py --plugin plugins/rbthreads gentoo rbthreads_${RUBY##*/}|| die "building rbthreads plugin for ${RUBY} failed"
}

python_compile_plugins() {
	local EPYV
	local PYV
	EPYV=${EPYTHON/.}
	PYV=${EPYV/python}

	${EPYTHON} uwsgiconfig.py --plugin plugins/python gentoo ${EPYV} || die "building plugin for ${EPYTHON} failed"
	${EPYTHON} uwsgiconfig.py --plugin plugins/asyncio gentoo asyncio${PYV} || die "building plugin for asyncio-support in ${EPYTHON} failed"
}

python_install_symlinks() {
	dosym uwsgi /usr/bin/uwsgi_${EPYTHON/.}
}

src_compile() {
	mkdir -p "${T}/plugins" || die

	export CPUCOUNT="$(makeopts_jobs)"

	${EPYTHON} uwsgiconfig.py --build gentoo || die "building uwsgi failed"

	if use go ; then
		${EPYTHON} uwsgiconfig.py --plugin plugins/gccgo gentoo || die "building plugin for go failed"
	fi

	if use lua ; then
		# setting the name for the pkg-config file to lua, since that is the name
		# provided by the wrapper from Lua eclasses
		UWSGICONFIG_LUAPC="lua" ${EPYTHON} uwsgiconfig.py --plugin plugins/lua gentoo || die "building plugin for lua failed"
	fi

	if use php ; then
		for s in $(php_get_slots); do
			UWSGICONFIG_PHPDIR="/usr/$(get_libdir)/${s}" ${EPYTHON} uwsgiconfig.py --plugin plugins/php gentoo ${s/.} || die "building plugin for ${s} failed"
		done
	fi

	if use python ; then
		python_foreach_impl python_compile_plugins
	fi

	if use ruby ; then
		ruby-ng_src_compile
	fi
}

src_install() {
	dobin uwsgi
	pax-mark m "${D}"/usr/bin/uwsgi

	insinto /usr/$(get_libdir)/uwsgi
	doins "${T}/plugins"/*.so

	use cgi && dosym uwsgi /usr/bin/uwsgi_cgi
	use go && dosym uwsgi /usr/bin/uwsgi_go
	use lua && dosym uwsgi /usr/bin/uwsgi_lua
	use mono && dosym uwsgi /usr/bin/uwsgi_mono
	use perl && dosym uwsgi /usr/bin/uwsgi_psgi

	if use php ; then
		local s
		for s in $(php_get_slots); do
			dosym uwsgi /usr/bin/uwsgi_${s/.}
		done
	fi

	if use python ; then
		python_foreach_impl python_install_symlinks
		python_foreach_impl python_domodule uwsgidecorators.py
	fi

	newinitd "${FILESDIR}"/uwsgi.initd-r7 uwsgi
	newconfd "${FILESDIR}"/uwsgi.confd-r4 uwsgi
	keepdir /etc/"${PN}".d
	use uwsgi_plugins_spooler && keepdir /var/spool/"${PN}"
}

pkg_postinst() {
	if use apache2 ; then
		ewarn "As reported on bug #650776 [1], Apache module mod_proxy_uwsgi"
		ewarn "is being transferred to upstream Apache since 2.4.30, see [2]."
		ewarn "We therefore do not build them any more."
		ewarn "    [1] https://bugs.gentoo.org/650776"
		ewarn "    [2] https://github.com/unbit/uwsgi/issues/1636"
	fi

	elog "Append the following options to the uwsgi call to load the respective language plugin:"
	use cgi    && elog "  '--plugins cgi' for cgi"
	use lua    && elog "  '--plugins lua' for lua"
	use mono   && elog "  '--plugins mono' for mono"
	use perl   && elog "  '--plugins psgi' for perl"

	if use php ; then
		for s in $(php_get_slots); do
			elog "  '--plugins ${s/.}' for ${s}"
		done
	fi

	python_pkg_postinst() {
		local EPYV
		local PYV
		EPYV=${EPYTHON/.}
		PYV=${EPYV/python}

		elog " "
		elog "  '--plugins ${EPYV}' for ${EPYTHON}"
		elog "  '--plugins ${EPYV},asyncio${PYV}' for asyncio support in ${EPYTHON}"
	}

	use python && python_foreach_impl python_pkg_postinst

	if use ruby ; then
		for ruby in $(ruby_get_use_implementations) ; do
			elog "  '--plugins rack_${ruby/.}' for ${ruby}"
			elog "  '--plugins fiber_${ruby/.}' for ${ruby} fibers"
			elog "  '--plugins rbthreads_${ruby/.}' for ${ruby} rbthreads"
		done
	fi
}
