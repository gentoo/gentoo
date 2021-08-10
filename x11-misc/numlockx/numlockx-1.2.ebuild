# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Changes keyboard's numlock state under X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 sparc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXtst"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	mv configure.{in,ac} || die
	sed -i '/^K_/d; s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die
	sed -i 's/@X_.*@//g' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf X_LDFLAGS="${LDFLAGS}"
}
