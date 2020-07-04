# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit apache-module

MY_PN=modsecurity
MY_P=${MY_PN}-${PV}

DESCRIPTION="Application firewall and intrusion detection for Apache"
HOMEPAGE="https://www.modsecurity.org/"
SRC_URI="https://www.modsecurity.org/tarball/${PV}/${MY_P}.tar.gz"

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

pkg_setup() {
	_init_apache2
	_init_apache2_late
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

	dodoc CHANGES README.md modsecurity.conf-recommended

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
