# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit lua-single

MY_P=${PN}-v${PV}

DESCRIPTION="Application firewall and intrusion detection"
HOMEPAGE="https://github.com/SpiderLabs/ModSecurity"
SRC_URI="https://github.com/SpiderLabs/ModSecurity/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc fuzzyhash geoip geoip2 json lmdb lua pcre2"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RDEPEND="dev-libs/libpcre:=
	dev-libs/libxml2
	net-misc/curl
	fuzzyhash? ( app-crypt/ssdeep )
	geoip? ( dev-libs/geoip )
	geoip2? ( dev-libs/libmaxminddb )
	json? ( dev-libs/yajl )
	lmdb? ( dev-db/lmdb )
	lua? ( ${LUA_DEPS} )
	pcre2? ( dev-libs/libpcre2:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

DOCS=( AUTHORS CHANGES README.md modsecurity.conf-recommended unicode.mapping )

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# 2 tests fail without portage too
	# https://github.com/SpiderLabs/ModSecurity/issues/2772
	sed -i '/test\/test-cases\/regression\/auditlog.json \\/d' Makefile.in || die
	sed -i '/test\/test-cases\/regression\/issue-2000.json \\/d' Makefile.in || die
	sed -i '/test\/test-cases\/regression\/config-secremoterules.json \\/d' Makefile.in || die
	sed -i '/test\/test-cases\/regression\/operator-ipMatchFromFile.json \\/d' Makefile.in || die
}

src_configure() {
	local myconf=(
		$(use_with fuzzyhash ssdeep)
		$(use_with geoip )
		$(use_with geoip2 maxmind)
		$(use_with json yajl)
		$(use_with lmdb)
		$(use_with lua)
		$(use_with pcre2)
	)

	econf "${myconf[@]}"
}

src_compile() {
	default

	if use doc; then
		cd doc && doxygen doxygen.cfg || die
	fi
}

src_install() {
	default
	use doc && dodoc -r doc/html
	find "${ED}" -name '*.la' -delete || die
}
