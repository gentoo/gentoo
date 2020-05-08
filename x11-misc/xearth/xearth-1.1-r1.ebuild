# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

HOMEPAGE="https://hewgill.com/xearth/original/"
DESCRIPTION="Xearth sets the X root window to an image of the Earth"
SRC_URI="ftp://cag.lcs.mit.edu/pub/tuna/${P}.tar.gz
	ftp://ftp.cs.colorado.edu/users/tuna/${P}.tar.gz"

SLOT="0"
LICENSE="xearth"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake
	app-text/rman
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
}

src_configure() {
	xmkmf || die
}

src_compile() {
	emake CC=$(tc-getCC) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	newman xearth.man xearth.1
	dobin xearth
	dodoc BUILT-IN GAMMA-TEST HISTORY README
}
