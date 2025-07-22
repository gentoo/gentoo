# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )

inherit lua-single

MY_P=${PN}-v${PV}

DESCRIPTION="Application firewall and intrusion detection"
HOMEPAGE="https://github.com/owasp-modsecurity/ModSecurity"
SRC_URI="
	https://github.com/owasp-modsecurity/ModSecurity/releases/download/v${PV}/${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0/3"
KEYWORDS="~amd64 ~arm arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="doc fuzzyhash geoip geoip2 json lmdb lua"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RDEPEND="
	dev-libs/libpcre2:=
	dev-libs/libxml2:=
	net-misc/curl
	fuzzyhash? ( app-crypt/ssdeep )
	geoip? ( dev-libs/geoip )
	geoip2? ( dev-libs/libmaxminddb )
	json? ( dev-libs/yajl )
	lmdb? ( dev-db/lmdb )
	lua? ( ${LUA_DEPS} )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )"

DOCS=( AUTHORS CHANGES README.md modsecurity.conf-recommended unicode.mapping )

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	local myconf=(
		$(use_with fuzzyhash ssdeep)
		$(use_with geoip )
		$(use_with geoip2 maxmind)
		$(use_with json yajl)
		$(use_with lmdb)
		$(use_with lua)
		--with-pcre2
	)

	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myconf[@]}"
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
