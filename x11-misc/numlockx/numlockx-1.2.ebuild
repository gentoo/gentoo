# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="Turns on numlock in X"
HOMEPAGE="https://home.kde.org/~seli/numlockx/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
"

src_prepare() {
	sed -i \
		-e '/^K_.*$/d' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.in || die
	sed -i -e 's,@X_[_A-Z]\+@,,g' Makefile.am || die
	eautoreconf
}

src_install() {
	dobin ${PN}
	dodoc AUTHORS README
}
