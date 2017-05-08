# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit apache-module

MY_PN=modsecurity
MY_P=${MY_PN}-${PV}

DESCRIPTION="Application firewall and intrusion detection for Apache"
HOMEPAGE="http://www.modsecurity.org/"
SRC_URI="http://www.modsecurity.org/tarball/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc fuzzyhash geoip jit json lua mlogc"

COMMON_DEPEND="dev-libs/apr
	dev-libs/apr-util[openssl]
	dev-libs/libxml2
	dev-libs/libpcre[jit?]
	fuzzyhash? ( app-crypt/ssdeep )
	json? ( dev-libs/yajl )
	lua? ( dev-lang/lua:0 )
	mlogc? ( net-misc/curl )
	www-servers/apache[apache2_modules_unique_id]"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"
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

need_apache2

src_configure() {
	econf --enable-shared \
		  --disable-static \
		  --with-apxs="${APXS}" \
		  --enable-request-early \
		  --with-pic \
		  $(use_with fuzzyhash ssdeep) \
		  $(use_with json yajl) \
		  $(use_enable mlogc) \
		  $(use_with lua) \
		  $(use_enable lua lua-cache) \
		  $(use_enable jit pcre-jit)
}

src_compile() {
	default

	# Building the docs is broken at the moment, see e.g.
	# https://github.com/SpiderLabs/ModSecurity/issues/1322
	if use doc; then
		doxygen doc/doxygen-apache.conf || die 'failed to build documentation'
	fi
}

src_install() {
	apache-module_src_install

	dodoc CHANGES README.TXT modsecurity.conf-recommended

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
	fperms 0770 /var/lib/modsecurity
}

pkg_postinst() {
	elog "The base configuration file has been renamed ${APACHE2_MOD_CONF}"
	elog "so that you can put your own configuration in (for example)"
	elog "90_modsecurity_local.conf."
	elog ""
	elog "That would be the correct place for site-global security rules."
	elog "Note: 80_modsecurity_crs.conf is used by www-apache/modsecurity-crs"
}
