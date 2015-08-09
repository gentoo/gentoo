# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="The PowerDNS Recursor"
HOMEPAGE="http://www.powerdns.com/"
SRC_URI="http://downloads.powerdns.com/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua"

DEPEND="lua? ( >=dev-lang/lua-5.1 )"
RDEPEND="${DEPEND}
	!<net-dns/pdns-2.9.20-r1"
DEPEND="${DEPEND}
	>=dev-libs/boost-1.33.1"

pkg_setup() {
	filter-flags -ftree-vectorize
}

src_configure() {
	CC="$(tc-getCC)" \
	CXX="$(tc-getCXX)" \
	OPTFLAGS="" \
	LUA_LIBS_CONFIG="-llua" \
	LUA_CPPFLAGS_CONFIG="" \
	LUA="$(use lua && echo 1)" \
	./configure
}

src_compile() {
	emake \
		LOCALSTATEDIR=/var/lib/powerdns \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		OPTFLAGS="" \
		LUA_LIBS_CONFIG="-llua" \
		LUA_CPPFLAGS_CONFIG="" \
		LUA="$(use lua && echo 1)"
}

src_install() {
	dosbin pdns_recursor rec_control
	doman pdns_recursor.1 rec_control.1

	insinto /etc/powerdns
	doins "${FILESDIR}"/recursor.conf

	doinitd "${FILESDIR}"/precursor

	# Pretty ugly, uh?
	dodir /var/lib/powerdns/var/lib
	dosym ../.. /var/lib/powerdns/var/lib/powerdns
}
