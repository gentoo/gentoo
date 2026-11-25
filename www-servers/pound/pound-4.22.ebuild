# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Add adns as a dependency in order to allow building with support for
#       dynamic backends
# TODO: Add hoard as a dependency in order to support the --enable-hoard configure
#       argument
# TODO: Install/support GNU Emacs major mode file src/pound-mode.el

LUA_COMPAT=( lua5-{3..4} )

inherit lua-single

DESCRIPTION="A http/https reverse-proxy and load-balancer"
HOMEPAGE="https://github.com/graygnuorg/pound"
SRC_URI="https://github.com/graygnuorg/pound/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"
IUSE="lua tcmalloc test"

RESTRICT="!test? ( test )"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
"
DEPEND="
	dev-libs/libpcre2:=
	dev-libs/openssl:=
	lua? ( ${LUA_DEPS} )
	tcmalloc? ( dev-util/google-perftools )
"
RDEPEND="
	${DEPEND}
	virtual/libcrypt:=
"
BDEPEND="
	test? (
		dev-lang/perl
		dev-perl/IO-FDPass
		dev-perl/IO-Socket-SSL
		dev-perl/JSON
		dev-perl/Net-SSLeay
	)
"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_configure() {
	local myconf=(
		--disable-dynamic-backends
		--disable-hoard
		--enable-pcre
		$(use_enable lua)
		$(use_enable tcmalloc)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}/pound.init" pound
	insinto /etc
	newins "${FILESDIR}/pound-2.2.cfg" pound.cfg
}
