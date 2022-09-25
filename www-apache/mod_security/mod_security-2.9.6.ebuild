# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit autotools apache-module lua-single

MY_PN=modsecurity
MY_P=${MY_PN}-${PV}

DESCRIPTION="Application firewall and intrusion detection for Apache"
HOMEPAGE="https://github.com/SpiderLabs/ModSecurity"
SRC_URI="https://github.com/SpiderLabs/ModSecurity/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc fuzzyhash geoip jit json lua mlogc"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

COMMON_DEPEND="dev-libs/apr
	dev-libs/apr-util[openssl]
	dev-libs/libxml2
	dev-libs/libpcre[jit?]
	virtual/libcrypt:=
	fuzzyhash? ( app-crypt/ssdeep )
	json? ( dev-libs/yajl )
	lua? ( ${LUA_DEPS} )
	mlogc? ( net-misc/curl )
	www-servers/apache[apache2_modules_unique_id]"
BDEPEND="doc? ( app-doc/doxygen )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	geoip? ( dev-libs/geoip )
	mlogc? ( dev-lang/perl )"
PDEPEND=">=www-apache/modsecurity-crs-2.2.6-r1"

S="${WORKDIR}/${MY_P}"

APACHE2_MOD_FILE="apache2/.libs/${PN}2.so"
APACHE2_MOD_CONF="79_${PN}"
APACHE2_MOD_DEFINE="SECURITY"

# Tests require symbols only defined within the Apache binary.
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.3-autoconf_lua_package_name.patch
)

need_apache2

pkg_setup() {
	_init_apache2
	_init_apache2_late
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		--enable-request-early
		--with-apxs="${APXS}"
		--with-pic
		$(use_with fuzzyhash ssdeep)
		$(use_with json yajl)
		$(use_enable mlogc)
		$(use_with lua)
		$(use_enable lua lua-cache)
		$(use_enable jit pcre-jit)
		$(use_enable doc docs) )

	econf ${myconf[@]}
}

src_compile() {
	default
}

src_install() {
	apache-module_src_install

	dodoc CHANGES README.md modsecurity.conf-recommended unicode.mapping

	if use doc; then
		dodoc -r doc/apache/html
	fi

	if use mlogc; then
		insinto /etc/
		newins mlogc/mlogc-default.conf mlogc.conf
		dobin mlogc/mlogc
		dobin mlogc/mlogc-batch-load.pl
		newdoc mlogc/INSTALL INSTALL-mlogc
	fi

	# Use /var/lib instead of /var/cache. This stuff is "persistent,"
	# and isn't a cached copy of something that we can recreate.
	# Bug 605496.
	keepdir /var/lib/modsecurity
	fowners apache:apache /var/lib/modsecurity
	fperms 0750 /var/lib/modsecurity
	for dir in data tmp upload; do
		keepdir "/var/lib/modsecurity/${dir}"
		fowners apache:apache "/var/lib/modsecurity/${dir}"
		fperms 0750 "/var/lib/modsecurity/${dir}"
	done
}

pkg_postinst() {
	elog "The base configuration file has been renamed ${APACHE2_MOD_CONF}"
	elog "so that you can put your own configuration in (for example)"
	elog "90_modsecurity_local.conf."
	elog ""
	elog "That would be the correct place for site-global security rules."
	elog "Note: 80_modsecurity_crs.conf is used by www-apache/modsecurity-crs"
}
